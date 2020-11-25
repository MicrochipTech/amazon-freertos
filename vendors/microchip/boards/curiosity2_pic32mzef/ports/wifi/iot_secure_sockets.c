/*
 * Amazon FreeRTOS Secure Sockets V1.1.8
 * Copyright (C) 2018 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://aws.amazon.com/freertos
 * http://www.FreeRTOS.org
 */

/* Define _SECURE_SOCKETS_WRAPPER_NOT_REDEFINE to prevent secure sockets functions
 * from redefining in iot_secure_sockets_wrapper_metrics.h */
#define _SECURE_SOCKETS_WRAPPER_NOT_REDEFINE

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "FreeRTOSIPConfig.h"
#include "list.h"
#include "semphr.h"
#include "FreeRTOS_IP.h"
#include "FreeRTOS_Sockets.h"
#include "iot_secure_sockets.h"
#include "iot_tls.h"
#include "task.h"
#include "iot_pkcs11.h"
#include "iot_crypto.h"
#include "socket.h"
#include "iot_wifi.h"
#include "m2m_socket_host_if.h"
#include "m2m_hif.h"
#include "configuration.h"


#undef _SECURE_SOCKETS_WRAPPER_NOT_REDEFINE


/* The socket type itself. */
typedef void (*tpfAppSocketRecvCb) ( Socket_t pxSocket );


typedef enum
{
    WDRV_MAC_EVENT_SOCKET_CONNECT = 0x040,    /* socket connect event */
    WDRV_MAC_EVENT_SOCKET_RECV = 0x080,    /* socket recv event */
    WDRV_MAC_EVENT_SOCKET_SEND = 0x100,    /* socket send event */

} WDRV_MAC_EVENT_TYPE;


#define SOCKET_CONNECT_TIMEOUT           ( pdMS_TO_TICKS( 10000 ) )

/*-----------------------------------------------------------*/

/* Make sure this section match whatever in winc1500 driver  socket.c" */
typedef struct{
    uint8_t                *pu8UserBuffer;
    uint16_t                u16UserBufferSize;
    uint16_t                u16SessionID;
    uint16_t                u16DataOffset;
    uint8_t                bIsUsed;
    uint8_t                u8SSLFlags;
    uint8_t                bIsRecvPending;
}tstrSocket;


#define SSL_FLAGS_ACTIVE                    NBIT0
#define SSL_FLAGS_BYPASS_X509                NBIT1
#define SSL_FLAGS_2_RESERVD                    NBIT2
#define SSL_FLAGS_3_RESERVD                    NBIT3
#define SSL_FLAGS_CACHE_SESSION                NBIT4
#define SSL_FLAGS_NO_TX_COPY                NBIT5
#define SSL_FLAGS_CHECK_SNI                    NBIT6

#define SOCKET_REQUEST(reqID, reqArgs, reqSize, reqPayload, reqPayloadSize, reqPayloadOffset)        \
    hif_send(M2M_REQ_GROUP_IP, reqID, reqArgs, reqSize, reqPayload, reqPayloadSize, reqPayloadOffset)
/*-----------------------------------------------------------*/

typedef enum{
    CONNECT_SEM    = 0,
    /*!<
        Semaphore used for connect operation wait
    */
    SEND_SEM,
    /*!<
        Semaphore used for send operation wait
    */
    RECV_SEM,
    /*!<
        Semaphore used for receive operation wait
    */
    RECV_BUF_SEM,
    /*!<
        Semaphore used for protect receive buffer
    */
    MAX_SEM

}tenuSocketSemaphoreType;


/**
 * @brief Socket context.
 *
 * \sa PORT_SPECIFIC_LINK
 */
typedef struct xSocketsSockaddr
{
    uint8_t* recvBuffer;       /**< pointer to the socket receive buffer. */
    uint8_t shutdownCalled;       /**< indicate if a socket has been shut down. */
    int8_t socketConnecting; /**< indicate if a socket is connecting. */
    int8_t socketConnected; /**< indicate if a socket is connected. */
    int8_t recvCalled; /**< indicate if a recv was called before. */
    uint32_t socketRecvTO;        /**< Indicate blocking recv timeout. */
    uint32_t socketSendTO;     /**<  Indicate blocking send timeout. */
    uint32_t socketRecvLength;     /**<  Indicate recv length. */
    uint32_t socketRecvOffset;     /**<  Indicate the data offset in the recv buffer. */
    uint32_t socketSendLength;     /**<  Indicate sent message length. */
    int32_t socketSendOutstanding; /**<  Indicate outstanding send message length. */
    SemaphoreHandle_t xSocketsOpSemaphore[MAX_SEM];/**<  Semaphores used for various operations. */
    StaticSemaphore_t xSocketsOpSemaphoreBuffer[MAX_SEM];/**<  Semaphores used for various operations. */
    TaskHandle_t waitingTask[MAX_SEM]; /**<  Task handle used for various operations. */
    volatile tpfAppSocketRecvCb    appSocketRecvCb;  /**<  Socket Recv callback. */
    char sniServerName[HOSTNAME_MAX_SIZE];
} SocketCntx_t;

/* Internal variables. */
static SemaphoreHandle_t xSocketsSemaphore = NULL;
static StaticSemaphore_t xSocketsSemaphoreBuffer;
static const TickType_t xSocketSemConnectWaitTicks = SOCKET_CONNECT_TIMEOUT;
static const TickType_t xSocketSemBufWaitTicks = ( pdMS_TO_TICKS( 10000 ) );
// const TickType_t xSemaphoreWaitTicks = pdMS_TO_TICKS( 5000 );
static SocketCntx_t xSocketCntx[TCP_SOCK_MAX] = {{0},};
extern SemaphoreHandle_t xWiFiSemaphore;
extern const TickType_t xSemaphoreWaitTicks;
extern TaskHandle_t waiting_task;
extern volatile tstrSocket                gastrSockets[MAX_SOCKET];


#define SOCKET_OFFSET 1
#define RECV_BUFFER_SIZE 1500

/*-----------------------------------------------------------*/

/*
 * helper routines.
 */

static void AWS_MCHP_SocketConnectEvent(SOCKET sock)
{
     xTaskNotify( (xSocketCntx[sock].waitingTask)[CONNECT_SEM], WDRV_MAC_EVENT_SOCKET_CONNECT, eSetBits );

}

static void AWS_MCHP_SocketRecvEvent(SOCKET sock)
{
     if(xSocketCntx[sock].socketRecvTO> 0)
             xTaskNotify(  (xSocketCntx[sock].waitingTask)[RECV_SEM], WDRV_MAC_EVENT_SOCKET_RECV, eSetBits );
    else
    {
        if(xSocketCntx[sock].appSocketRecvCb)
             xSocketCntx[sock].appSocketRecvCb(sock);
    }
}

static void AWS_MCHP_SocketSendEvent(SOCKET sock)
{
     xTaskNotify( (xSocketCntx[sock].waitingTask)[SEND_SEM], WDRV_MAC_EVENT_SOCKET_SEND, eSetBits );
}

/*-----------------------------------------------------------*/

static void SocketRequireTLS(SOCKET sock)
{
    tstrSSLSocketCreateCmd    strSSLCreate;
    volatile tstrSocket        *pstrSock = &gastrSockets[sock];

    strSSLCreate.sslSock = sock;
    pstrSock->u8SSLFlags = SSL_FLAGS_ACTIVE | SSL_FLAGS_NO_TX_COPY;
    SOCKET_REQUEST(SOCKET_CMD_SSL_CREATE, (uint8_t*)&strSSLCreate, sizeof(tstrSSLSocketCreateCmd), 0, 0, 0);
}

/*-----------------------------------------------------------*/

/**
 * \brief Callback function of TCP client socket.
 *
 * \param[in] sock socket handler.
 * \param[in] u8Msg Type of Socket notification
 * \param[in] pvMsg A structure contains notification informations.
 *
 * \return None.
 */
void socket_cb(SOCKET sock, uint8_t u8Msg, void *pvMsg)
{
    switch (u8Msg) {
        case SOCKET_MSG_CONNECT:
        {
            tstrSocketConnectMsg *pstrConnect = (tstrSocketConnectMsg *)pvMsg;
            if (pstrConnect && pstrConnect->s8Error >= SOCK_ERR_NO_ERROR) {

                configPRINTF(("Successfully connected, sock =%d\r\n", sock));
                xSocketCntx[sock].socketConnected= 1;
                
                } else {
                xSocketCntx[sock].socketConnected = pstrConnect->s8Error;
                configPRINTF(("Connect error! code(%d), sock = %d\r\n", (xSocketCntx[sock].socketConnected), sock));
            }

            if(xSocketCntx[sock].socketConnecting)
                AWS_MCHP_SocketConnectEvent(sock);
        }
        break;
        
        case SOCKET_MSG_SEND:
        {
            short int s16SentBytes = *((short int*)pvMsg);

            xSocketCntx[sock].socketSendLength+= s16SentBytes;
            xSocketCntx[sock].socketSendOutstanding-= s16SentBytes;
            //configPRINTF(("Socket send :%d\r\n",(s16SentBytes)));                    
            if(s16SentBytes < 0)
            {
                configPRINTF(("Socket send error:%d\r\n",(s16SentBytes)));
                xSocketCntx[sock].socketSendOutstanding = 0;
            }
            else
            {
                if((0 < xSocketCntx[sock].socketSendTO) && (xSocketCntx[sock].socketSendOutstanding == 0))
                        {
                    AWS_MCHP_SocketSendEvent(sock);
                }

            }
        }
        break;
        
        case SOCKET_MSG_RECV:
        {
            tstrSocketRecvMsg *pstrRecv = (tstrSocketRecvMsg *)pvMsg;

            if (pstrRecv) {
                //configPRINTF(("Socket recv :%d\r\n",(pstrRecv->s16BufferSize)));    
                if(pstrRecv->s16BufferSize < 0)
                {
                    configPRINTF(("Socket  error:%d\r\n",(pstrRecv->s16BufferSize )));
                }
                else
                xSocketCntx[sock].socketRecvLength= pstrRecv->s16BufferSize;
                xSocketCntx[sock].recvCalled = 0;
               
            }
            AWS_MCHP_SocketRecvEvent(sock);    
            
               
        }

        default:
        break;
    }

}


/*-----------------------------------------------------------*/

/*
 * Interface routines.
 */

int32_t SOCKETS_Close( Socket_t xSocket )
{
    SOCKET sock =  (( SOCKET ) xSocket)-SOCKET_OFFSET;;
    int32_t ret = 0;
    int8_t i=0;

    if(0 > sock)
    {
       return SOCKETS_EINVAL;
    }
    
    /* WINC1500 stack has BSD like interface, there is no shut down and close, only
         one of them. hence, if shut down is called for this socket we just return.*/
    if(xSocketCntx[sock].shutdownCalled)
    {
        xSocketCntx[sock].shutdownCalled = 0;
        return SOCKETS_ERROR_NONE;
    }

    xSocketCntx[sock].socketConnected = 0;
    memset(xSocketCntx[sock].sniServerName, 0, sizeof(xSocketCntx[sock].sniServerName));
    
    /* wait until all outstanding data are sent */
    while(xSocketCntx[sock].socketSendOutstanding!=0)vTaskDelay(10);

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {
        configPRINTF(("Socket Close Called\r\n"));  
        ret = shutdown((SOCKET)sock);
        xSemaphoreGive(xWiFiSemaphore);
        if (ret == 0)
        {
            xSocketCntx[sock].socketConnected= 0;
            
            if( xSemaphoreTake( (xSocketCntx[sock].xSocketsOpSemaphore[RECV_BUF_SEM]), xSocketSemBufWaitTicks ) == pdTRUE )
            {
                if(xSocketCntx[sock].recvBuffer != NULL)
                    vPortFree(xSocketCntx[sock].recvBuffer);
                ret = SOCKETS_ERROR_NONE;
                xSemaphoreGive(xSocketCntx[sock].xSocketsOpSemaphore[RECV_BUF_SEM]);
            }
            else
            {
                configPRINTF(("Timeout to free receive buffer\r\n")); 
                ret = SOCKETS_EINVAL;
            } 

             configPRINTF(("Socket Close Completed \r\n"));  
        }
        else
        {
            ret = SOCKETS_EINVAL;
        }
    }
    else
    {
        ret = SOCKETS_EWOULDBLOCK;
    }
    
  

    return ret;

}
/*-----------------------------------------------------------*/

int32_t SOCKETS_Connect( Socket_t xSocket,
                         SocketsSockaddr_t * pxAddress,
                         Socklen_t xAddressLength )
{
    int32_t lStatus = SOCKETS_ERROR_NONE;
    SOCKET Socket =  (( SOCKET ) xSocket)-SOCKET_OFFSET;; 
    struct sockaddr_in addr = { 0 };
    EventBits_t evBits;


    if( ( Socket >= 0 ) && ( pxAddress != NULL ) )
    {
            if(pxAddress->ulAddress == NULL || pxAddress->usPort == 0)
            return SOCKETS_EINVAL;
            
        //Socket mutual execution
        if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore)[CONNECT_SEM], xSocketSemConnectWaitTicks ) == pdTRUE )
        {
            if(xSocketCntx[Socket].socketConnected || xSocketCntx[Socket].socketConnecting )
            {
                xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[CONNECT_SEM]);
                return SOCKETS_EISCONN;
            }

            //Wi-Fi semaphore is for SPI mutual access
            if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
            {  
                    /* Connect the wrapped socket. */
                    addr.sin_addr.s_addr = (pxAddress->ulAddress);
                    addr.sin_family = pxAddress->ucSocketDomain;
                    addr.sin_port = pxAddress->usPort;
                xSocketCntx[Socket].socketConnected = 0;
                xSocketCntx[Socket].socketConnecting = 1;
                
                lStatus = connect( Socket, (struct sockaddr*)&addr, sizeof(struct sockaddr_in ));
             
                if(lStatus != SOCKETS_ERROR_NONE)
                    lStatus = SOCKETS_EINVAL;
                 xSemaphoreGive(xWiFiSemaphore);
            }
            else
            {
                xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[CONNECT_SEM]);
                    return SOCKETS_SOCKET_ERROR;
            }

            /* Wait for socket connect to complete. */
           (xSocketCntx[Socket].waitingTask)[CONNECT_SEM] = xTaskGetCurrentTaskHandle();

                xTaskNotifyWait( WDRV_MAC_EVENT_SOCKET_CONNECT, WDRV_MAC_EVENT_SOCKET_CONNECT, &evBits, SOCKET_CONNECT_TIMEOUT );

            if( ( evBits & WDRV_MAC_EVENT_SOCKET_CONNECT ) == 0 )
            {
                /* Timed out. */
                configPRINTF( ( "connect timeout\r\n" ) );
                lStatus =  SOCKETS_SOCKET_ERROR;
                xSocketCntx[Socket].socketConnecting = 0;
            }
            else
            {
                if(1 == xSocketCntx[Socket].socketConnected)
                {
                    lStatus = SOCKETS_ERROR_NONE;
                }
                else
                {
                    lStatus = xSocketCntx[Socket].socketConnected;
                    xSocketCntx[Socket].socketConnected = 0;
                }
                
                 xSocketCntx[Socket].socketConnecting = 0;
            }
          xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[CONNECT_SEM]);
        }    
        else
        {
            /* Timed out. */
            lStatus =  SOCKETS_SOCKET_ERROR;
        }

       
    }
    else
    {
        lStatus = SOCKETS_EINVAL;
    }    

    return lStatus;

}
/*-----------------------------------------------------------*/

uint32_t SOCKETS_GetHostByName( const char * pcHostName )
{
    uint32_t ipAddress = 0;
    WIFIReturnCode_t ret = eWiFiFailure; 

    if(pcHostName == NULL)
    {
        return SOCKETS_EINVAL;
    }
    
    ret = WIFI_GetHostIP(pcHostName, &ipAddress);
    if ((ret != eWiFiSuccess) || (ipAddress == 0))
    {
        configPRINTF(("get host ip failed %d %d\r\n",ret, ipAddress));
    }

    return ipAddress;
}
/*-----------------------------------------------------------*/
void socket_recv_command_task (void * params)
{
    int32_t lStatus = SOCKETS_SOCKET_ERROR;
    SOCKET Socket =  (( SOCKET ) params);
    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {    
        if (Socket >=0)
        {
            if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]), xSocketSemBufWaitTicks ) == pdTRUE )
            {  
                if (xSocketCntx[Socket].recvBuffer != NULL)
                {
                    lStatus = recv( Socket, xSocketCntx[Socket].recvBuffer, RECV_BUFFER_SIZE, 0 );
                    if(lStatus !=M2M_SUCCESS)
                    {
                        configPRINTF( ( "recv fail, ret = %d\r\n", lStatus ) );
                    }
                }
                xSemaphoreGive(xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]);
            }
            
        }
        xSemaphoreGive(xWiFiSemaphore);
    }
    else
    {
    }
    
    vTaskDelete( NULL );   
}
int32_t SOCKETS_Recv( Socket_t xSocket,
                      void * pvBuffer,
                      size_t xBufferLength,
                      uint32_t ulFlags )
{
    int32_t lStatus = SOCKETS_SOCKET_ERROR;
    SOCKET Socket =  (( SOCKET ) xSocket) -SOCKET_OFFSET;
    EventBits_t evBits;

    if((Socket<0) || (pvBuffer == NULL))
        return SOCKETS_EINVAL;

    if(xSocketCntx[Socket].socketConnected==0)
        return SOCKETS_SOCKET_ERROR;

    if((xSocket<=0) || (pvBuffer == NULL))
        return SOCKETS_EINVAL;

    if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore)[RECV_SEM], xSocketSemConnectWaitTicks ) == pdTRUE )
    {  
            //check if received a packet before.
        if(xSocketCntx[Socket].socketRecvLength > 0)
        {    
            if(xSocketCntx[Socket].socketRecvLength <= xBufferLength)
            {
                // the buffer supplied is enough to accommdate all the data received
                lStatus = xSocketCntx[Socket].socketRecvLength;
                if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]), xSocketSemBufWaitTicks ) == pdTRUE )
                {  
                    memcpy((uint8_t*)pvBuffer, xSocketCntx[Socket].recvBuffer+xSocketCntx[Socket].socketRecvOffset, lStatus);

                    xSocketCntx[Socket].socketRecvLength =0;
                    xSocketCntx[Socket].socketRecvOffset =0;
                    xSemaphoreGive(xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]);
                }
                else
                {
                     lStatus = 0;
                }
            }
            else
            {
                if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]), xSocketSemBufWaitTicks ) == pdTRUE )
                {  
                    // Buffer is smaller than all the received data.
                    lStatus = xBufferLength;
                    memcpy((uint8_t*)pvBuffer, xSocketCntx[Socket].recvBuffer+xSocketCntx[Socket].socketRecvOffset, lStatus);
                    xSocketCntx[Socket].socketRecvLength -= xBufferLength;
                    xSocketCntx[Socket].socketRecvOffset+= xBufferLength;
                    xSemaphoreGive(xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]);
                 }
                else
                {
                     lStatus = 0;
                }
            }
            
            xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[RECV_SEM]);
            return lStatus;
        }

        if(xSocketCntx[Socket].recvCalled != 1)
        {
            xTaskCreate( socket_recv_command_task,
                         "socket_recv_command_task",
                         512,
                         Socket,
                         tskIDLE_PRIORITY+3, NULL );          
        }
        
        //indicate recv called, don't call again until data is received.
        xSocketCntx[Socket].recvCalled = 1;
        
            /* Wait for socket recv to complete if it's a blocking socket. */
        if(xSocketCntx[Socket].socketRecvTO> 0){

            (xSocketCntx[Socket].waitingTask)[RECV_SEM] = xTaskGetCurrentTaskHandle();
                
            xTaskNotifyWait( WDRV_MAC_EVENT_SOCKET_RECV, WDRV_MAC_EVENT_SOCKET_RECV, &evBits, xSocketCntx[Socket].socketRecvTO);

            if( ( evBits & WDRV_MAC_EVENT_SOCKET_RECV ) == 0 )
            {
                /* Timed out. */
                configPRINTF( ( "recv timeout\r\n" ) );
                lStatus =  SOCKETS_EWOULDBLOCK;
            }
            else
            {
                /* Socket recv callback completed */

               if(xSocketCntx[Socket].socketRecvLength <= xBufferLength)
                {
                    // the buffer supplied is enough to accommdate all the data received
                    lStatus = xSocketCntx[Socket].socketRecvLength;
                    xSocketCntx[Socket].socketRecvLength =0;
                    xSocketCntx[Socket].socketRecvOffset =0;


                }
                else
                {
                   // Buffer is smaller than all the received data.
                   xSocketCntx[Socket].socketRecvLength -= xBufferLength;
                    xSocketCntx[Socket].socketRecvOffset+= xBufferLength;
                    lStatus = xBufferLength;
                }

               if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]), xSocketSemBufWaitTicks ) == pdTRUE )
               { 
                   memcpy((uint8_t*)pvBuffer, xSocketCntx[Socket].recvBuffer, lStatus);
                   xSemaphoreGive(xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]);
               }
               else
                {
                     lStatus = 0;
                }
            }
              
        }
        else
               lStatus = SOCKETS_EWOULDBLOCK;  
        }
    else
    {
    // timeout
        return SOCKETS_SOCKET_ERROR;
    }

    xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[RECV_SEM]);
    
    return lStatus;

}
/*-----------------------------------------------------------*/

int32_t SOCKETS_Send( Socket_t xSocket,
                      const void * pvBuffer,
                      size_t xDataLength,
                      uint32_t ulFlags )
{
    int32_t lStatus = SOCKETS_SOCKET_ERROR;
    int32_t sentDataLength = 0;
    int32_t sendSize = 0;
    int8_t errCount=0;
    SOCKET Socket =  (( SOCKET ) xSocket) -SOCKET_OFFSET;
    EventBits_t evBits;

    if((Socket<0) || (pvBuffer == NULL))
        return SOCKETS_EINVAL;
    
    if (xSocketCntx[Socket].socketConnected <= 0)
        return SOCKETS_SOCKET_ERROR;
        
    if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore)[SEND_SEM], xSocketSemConnectWaitTicks ) == pdTRUE )
    {  
            xSocketCntx[Socket].socketSendLength = 0;
         xSocketCntx[Socket].socketSendOutstanding += xDataLength;

        //WINC1500 socket send expects a buffer of length <= xDataLength-sentDataLength)
        //loop until all data is sent
        while((sentDataLength != xDataLength) && (errCount<10))
        {
        
             if( (xDataLength-sentDataLength)  > SOCKET_BUFFER_MAX_LENGTH)
                 sendSize = SOCKET_BUFFER_MAX_LENGTH;
             else
                 sendSize = xDataLength-sentDataLength;

            //Wi-Fi semaphore is for SPI mutual access
            if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
            {              
                    lStatus = send( Socket, ((uint8_t*)pvBuffer)+sentDataLength, sendSize, 0);
            }
            else
            {
                //timeout
                    xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[SEND_SEM]);
                return SOCKETS_SOCKET_ERROR;                
            }
            
            xSemaphoreGive(xWiFiSemaphore);
            
             if(lStatus !=M2M_SUCCESS)
                {
                    if(lStatus ==SOCK_ERR_BUFFER_FULL)
                    {
                    //No memory in WINC, try again
                    errCount++;
                        continue;
                    }
                else
                {
                    //failed miserably
                        xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[SEND_SEM]);
                    return lStatus;
                }
                }
             else
                 sentDataLength+=sendSize;
                    
        }

            /* Wait for socket send to complete if it's a blocking socket. */
        if(0 < xSocketCntx[Socket].socketSendTO)
                {
                    (xSocketCntx[Socket].waitingTask)[SEND_SEM] = xTaskGetCurrentTaskHandle();

                    xTaskNotifyWait( WDRV_MAC_EVENT_SOCKET_SEND, WDRV_MAC_EVENT_SOCKET_SEND, &evBits, xSocketCntx[Socket].socketSendTO );

                if( ( evBits & WDRV_MAC_EVENT_SOCKET_SEND ) == 0 )
                {
                    /* Timed out. */
                    configPRINTF( ( "send timeout\r\n" ) );

                }

              /* Socket send callback completed */
              lStatus = xSocketCntx[Socket].socketSendLength;
              xSocketCntx[Socket].socketSendLength =0;

         }
         else
             lStatus = xDataLength;
                
    }
    else
    {
        return SOCKETS_SOCKET_ERROR;
    }
    
    xSemaphoreGive((xSocketCntx[Socket].xSocketsOpSemaphore)[SEND_SEM]);
    
    return lStatus;
}
/*-----------------------------------------------------------*/

int32_t SOCKETS_SetSockOpt( Socket_t xSocket,
                            int32_t lLevel,
                            int32_t lOptionName,
                            const void * pvOptionValue,
                            size_t xOptionLength )
{
    int32_t lStatus = SOCKETS_ERROR_NONE;
    TickType_t xTimeout;
    SOCKET Socket = (( SOCKET ) xSocket) -SOCKET_OFFSET; 
    int sslOptionEnable = 1;

    if(Socket<0)
        return SOCKETS_EINVAL;
    
    switch( lOptionName )
    {
        case SOCKETS_SO_SERVER_NAME_INDICATION:
            /* Non-NULL destination string indicates that SNI extension should
             * be used during TLS negotiation. */
            
			if (xSocketCntx[Socket].socketConnected > 0)
           	{
                lStatus = SOCKETS_ENOPROTOOPT;
                break;
            }
			memcpy(xSocketCntx[Socket].sniServerName, pvOptionValue,strlen((char*)pvOptionValue)); 
            if (gastrSockets[Socket].u8SSLFlags & SSL_FLAGS_ACTIVE)
            {
				setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_SNI, (char*)pvOptionValue, strlen((char*)pvOptionValue) + 1);
#ifdef WDRV_WINC_DEVICE_WINC1500
            	setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_ENABLE_SNI_VALIDATION, &sslOptionEnable, 4);
#else
            	setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_ENABLE_CERTNAME_VALIDATION, &sslOptionEnable, 4);
#endif
            	//SO_SSL_ENABLE_CERTNAME_VALIDATION
			}
            break;

        case SOCKETS_SO_TRUSTED_SERVER_CERTIFICATE:
            /* Non-NULL server certificate field indicates that the WINC1500 default trust
             * list should not be used. */
			if (xSocketCntx[Socket].socketConnected > 0)
            {
                lStatus = SOCKETS_ENOPROTOOPT;
                break;
            }
	        /* Not supported for now */
	        //WriteRootCertificate((char*)pvOptionValue, xOptionLength);
            break;

        case SOCKETS_SO_REQUIRE_TLS:
            
            if (xSocketCntx[Socket].socketConnected > 0)
            {
                lStatus = SOCKETS_ENOPROTOOPT;
                break;
            }
            
            SocketRequireTLS(Socket);
            setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_ENABLE_SESSION_CACHING, &sslOptionEnable, 4);
            
            if (strlen((char*)xSocketCntx[Socket].sniServerName) > 0)
            {
                setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_SNI, xSocketCntx[Socket].sniServerName, strlen(xSocketCntx[Socket].sniServerName) + 1);
#ifdef WDRV_WINC_DEVICE_WINC1500
                setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_ENABLE_SNI_VALIDATION, &sslOptionEnable, 4);
#else
                setsockopt(Socket, SOL_SSL_SOCKET, SO_SSL_ENABLE_CERTNAME_VALIDATION, &sslOptionEnable, 4);
#endif
				//SO_SSL_ENABLE_CERTNAME_VALIDATION
            }                
            

            break;

        case SOCKETS_SO_ALPN_PROTOCOLS:
           /* currently not supported */
            lStatus = SOCKETS_ENOPROTOOPT;
            break;

        case SOCKETS_SO_NONBLOCK:
            if (xSocketCntx[Socket].socketConnected <= 0)
            {
                lStatus = SOCKETS_ENOPROTOOPT;
                break;
            }
            xSocketCntx[Socket].socketRecvTO=0;
            xSocketCntx[Socket].socketSendTO=0;
            break;

        case SOCKETS_SO_RCVTIMEO:
        case SOCKETS_SO_SNDTIMEO:
            /* Comply with Berkeley standard - a 0 timeout is wait forever. */
            xTimeout = *( ( const TickType_t * ) pvOptionValue ); /*lint !e9087 pvOptionValue passed should be of TickType_t */

            if( xTimeout == 0U )
            {
                xTimeout = portMAX_DELAY;
            }

            xSocketCntx[Socket].socketRecvTO=xTimeout;
         xSocketCntx[Socket].socketSendTO=xTimeout;
            break;

    case SOCKETS_SO_WAKEUP_CALLBACK:
         xSocketCntx[Socket].appSocketRecvCb = (tpfAppSocketRecvCb)pvOptionValue;
        break;
        
        default:
        lStatus = SOCKETS_EINVAL;
            break;
    }

    return lStatus;
}
/*-----------------------------------------------------------*/

int32_t SOCKETS_Shutdown( Socket_t xSocket,
                          uint32_t ulHow )
{
    SOCKET Socket = (( SOCKET ) xSocket)-SOCKET_OFFSET;
    int32_t ret = 0;
    int8_t i=0;

    if (2 < ulHow)
    {
        return SOCKETS_EINVAL;
    }

    if(0 > Socket)
    {
       return SOCKETS_EINVAL;
    }

    /* Wait until all outgoing data has been sent */
    while(xSocketCntx[Socket].socketSendOutstanding!=0)vTaskDelay(10);

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {
        configPRINTF(("Socket Shutdown Called\r\n"));  
        ret = shutdown((SOCKET)Socket);
        xSemaphoreGive(xWiFiSemaphore);
        if (ret == 0)
        {
            xSocketCntx[Socket].shutdownCalled = 1;
            xSocketCntx[Socket].socketConnected= 0;
            
            if( xSemaphoreTake( (xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]), xSocketSemBufWaitTicks ) == pdTRUE )
            {
                if(xSocketCntx[Socket].recvBuffer != NULL)
                    vPortFree(xSocketCntx[Socket].recvBuffer);
				xSocketCntx[Socket].recvBuffer=NULL;
                ret = SOCKETS_ERROR_NONE;
                xSemaphoreGive(xSocketCntx[Socket].xSocketsOpSemaphore[RECV_BUF_SEM]);
            }
            else
            {
                configPRINTF(("Timeout to free receive buffer\r\n")); 
                ret = SOCKETS_EINVAL;
            } 

             configPRINTF(("Socket Shutdown Completed\r\n"));  
        }
        else
        {
            ret = SOCKETS_EINVAL;
        }
    }
    else
    {
        ret = SOCKETS_EWOULDBLOCK;
    }
    
    

    return ret;
}
/*-----------------------------------------------------------*/

Socket_t SOCKETS_Socket( int32_t lDomain,
                         int32_t lType,
                         int32_t lProtocol )
{
   SOCKET Socket;
    int8_t i=0;

    /* Ensure that only supported values are supplied. */
    configASSERT( lDomain == SOCKETS_AF_INET );
    configASSERT( (lType == SOCKETS_SOCK_STREAM && lProtocol == SOCKETS_IPPROTO_TCP) );

    if( xSemaphoreTake( xSocketsSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {  
        Socket = socket( lDomain, lType,  NULL);
        
        /* Create the wrapped socket. */
        if( Socket < 0 )
        {
            xSemaphoreGive(xSocketsSemaphore);    
            return SOCKETS_INVALID_SOCKET;
        }
        else
        {
            memset(&(xSocketCntx[Socket]), 0, sizeof(SocketCntx_t));
            xSocketCntx[Socket].recvBuffer = pvPortMalloc(RECV_BUFFER_SIZE);

            for(i =0 ; i <MAX_SEM ; i++)
            {
                if ((xSocketCntx[Socket].xSocketsOpSemaphore)[i] == NULL)
                {
                    (xSocketCntx[Socket].xSocketsOpSemaphore)[i] = xSemaphoreCreateBinaryStatic( &((xSocketCntx[Socket].xSocketsOpSemaphoreBuffer)[i]) );
                    
                       if ((xSocketCntx[Socket].xSocketsOpSemaphore)[i] == NULL)
                       {
                            /* Init failed. */
                            configPRINTF( ( "\r\nfailed to allocate Sockets semaphore\r\n" ) );
                            shutdown(Socket);
                            xSemaphoreGive(xSocketsSemaphore);
                            return SOCKETS_INVALID_SOCKET;
                       }

                     xSocketCntx[Socket].socketRecvTO = xSocketCntx[Socket].socketSendTO = portMAX_DELAY;

                    if( xSemaphoreGive( (xSocketCntx[Socket].xSocketsOpSemaphore)[i] ) != pdTRUE )
                    {
                        // We would expect this call to not fail to allow one task in
                        configPRINTF( ( "\r\nfailed to Give Sockets semaphore\r\n" ) );
                        shutdown(Socket);
                        xSemaphoreGive(xSocketsSemaphore);
                        return SOCKETS_INVALID_SOCKET;
                    }
                   
                }
            }
        }
        xSemaphoreGive(xSocketsSemaphore);
    }
    else
    {
        return SOCKETS_INVALID_SOCKET;
    }

    /* WINC sockets range is [0-6], AWS consider 0 returned as an error
          Hence we offset our socket by 1 and subtract it in any API to get 
          real socket number*/    
    return (Socket+SOCKET_OFFSET);
}
/*-----------------------------------------------------------*/

BaseType_t SOCKETS_Init( void )
{
   /* 
     *   When using WINC1500 internal TCP/IP stack, this is done in 
     *  WiFi init during WiFi_on fucntion.
     */
     
    /* Create a binary semaphore for socket API mutual execution */
    if (xSocketsSemaphore == NULL){
        xSocketsSemaphore = xSemaphoreCreateBinaryStatic( &xSocketsSemaphoreBuffer );
        
       if (xSocketsSemaphore == NULL){
            /* Init failed. */
            configPRINTF( ( "\r\nfailed to allocate Sockets semaphore\r\n" ) );
            return pdFAIL;
       }
    
       if( xSemaphoreGive( xSocketsSemaphore ) != pdTRUE )
    {
             // We would expect this call to not fail to allow one task in
             configPRINTF( ( "\r\nfailed to Give Sockets semaphore\r\n" ) );
             return pdFAIL;
    }
    }
    
    /* set DNS/IP callbacks */
    //registerSocketCallback( socket_cb, dns_resolve_cb);

    return pdPASS;
}

/**
 * @brief Create a static PKCS #11 crypto session handle to share across socket
 * and FreeRTOS+TCP threads. Assume that two or more threads may race to be the
 * first to initialize the static and handle that case accordingly.
 */
static CK_RV prvSocketsGetCryptoSession( SemaphoreHandle_t * pxSessionLock,
                                         CK_SESSION_HANDLE * pxSession,
                                         CK_FUNCTION_LIST_PTR_PTR ppxFunctionList )
{
    CK_RV xResult = CKR_OK;
    CK_C_GetFunctionList pxCkGetFunctionList = NULL;
    static CK_SESSION_HANDLE xPkcs11Session = 0;
    static CK_FUNCTION_LIST_PTR pxPkcs11FunctionList = NULL;
    static StaticSemaphore_t xStaticSemaphore;
    static SemaphoreHandle_t xSessionLock = NULL;
    CK_ULONG ulCount = 0;
    CK_SLOT_ID * pxSlotIds = NULL;

    /* Check if one-time initialization of the lock is needed.*/
    portENTER_CRITICAL();

    if( NULL == xSessionLock )
    {
        xSessionLock = xSemaphoreCreateMutexStatic( &xStaticSemaphore );
    }

    *pxSessionLock = xSessionLock;
    portEXIT_CRITICAL();

    /* Check if one-time initialization of the crypto handle is needed.*/
    xSemaphoreTake( xSessionLock, portMAX_DELAY );

    if( 0 == xPkcs11Session )
    {
        /* One-time initialization. */

        /* Ensure that the PKCS#11 module is initialized. We don't keep the
         * scheduler stopped here, since we don't want to make assumptions about hardware
         * requirements for accessing a crypto module. */

        pxCkGetFunctionList = C_GetFunctionList;
        xResult = pxCkGetFunctionList( &pxPkcs11FunctionList );

        if( CKR_OK == xResult )
        {
            xResult = xInitializePkcs11Token();
        }

        /* Get the crypto token slot count. */
        if( CKR_OK == xResult )
        {
            xResult = pxPkcs11FunctionList->C_GetSlotList( CK_TRUE,
                                                           NULL,
                                                           &ulCount );
        }

        /* Allocate memory to store the token slots. */
        if( CKR_OK == xResult )
        {
            pxSlotIds = ( CK_SLOT_ID * ) pvPortMalloc( sizeof( CK_SLOT_ID ) * ulCount );

            if( NULL == pxSlotIds )
            {
                xResult = CKR_HOST_MEMORY;
            }
        }

        /* Get all of the available private key slot identities. */
        if( CKR_OK == xResult )
        {
            xResult = pxPkcs11FunctionList->C_GetSlotList( CK_TRUE,
                                                           pxSlotIds,
                                                           &ulCount );
        }

        /* Start a session with the PKCS#11 module. */
        if( CKR_OK == xResult )
        {
            xResult = pxPkcs11FunctionList->C_OpenSession( pxSlotIds[ 0 ],
                                                           CKF_SERIAL_SESSION,
                                                           NULL,
                                                           NULL,
                                                           &xPkcs11Session );
        }
    }

    *pxSession = xPkcs11Session;
    *ppxFunctionList = pxPkcs11FunctionList;
    xSemaphoreGive( xSessionLock );

    if( NULL != pxSlotIds )
    {
        vPortFree( pxSlotIds );
    }

    return xResult;
}
/*-----------------------------------------------------------*/

/*uint32_t ulRand( void ) __attribute__ ((deprecated)) */
#if 0

/* Why is this function between #if 0? Because the function ulRand()
 * is now reprecated. The function is still shown here for users who
 * are looking for it.
 * It is deprecated because a return value of 0 would mean that the
 * RND module is broken. This was confusing because 0 is also a
 * possible valid random number. */
    uint32_t ulRand( void )
    {
        uint32_t ulNumber = 0uL;
        BaseType_t xResult = xApplicationGetRandomNumber( &( ulNumber ) );

        if( xResult == pdFALSE )
        {
            ulNumber = 0uL;
        }
        else
        {
            /* Function succeeded, a random number will be returned. */
        }

        return ulNumber;
    }
#endif /* 0 */

BaseType_t xApplicationGetRandomNumber( uint32_t * pulNumber )
{
    CK_RV xResult = 0;
    SemaphoreHandle_t xSessionLock = NULL;
    CK_SESSION_HANDLE xPkcs11Session = 0;
    CK_FUNCTION_LIST_PTR pxPkcs11FunctionList = NULL;
    uint32_t ulRandomValue = 0;
    BaseType_t xReturn; /* Return pdTRUE if successful */

    xResult = prvSocketsGetCryptoSession( &xSessionLock,
                                          &xPkcs11Session,
                                          &pxPkcs11FunctionList );

    if( 0 == xResult )
    {
        /* Request a sequence of cryptographically random byte values using
         * PKCS#11. */
        xResult = pxPkcs11FunctionList->C_GenerateRandom( xPkcs11Session,
                                                          ( CK_BYTE_PTR ) &ulRandomValue,
                                                          sizeof( ulRandomValue ) );
    }

    /* Check if any of the API calls failed. */
    if( 0 == xResult )
    {
        xReturn = pdTRUE;
        *( pulNumber ) = ulRandomValue;
    }
    else
    {
        xReturn = pdFALSE;
        *( pulNumber ) = 0uL;
    }

    return xReturn;
}
/*-----------------------------------------------------------*/

/**
 * @brief Generate a TCP Initial Sequence Number that is reasonably difficult
 * to predict, per https://tools.ietf.org/html/rfc6528.
 */
uint32_t ulApplicationGetNextSequenceNumber( uint32_t ulSourceAddress,
                                             uint16_t usSourcePort,
                                             uint32_t ulDestinationAddress,
                                             uint16_t usDestinationPort )
{
    CK_RV xResult = CKR_OK;
    SemaphoreHandle_t xSessionLock = NULL;
    CK_SESSION_HANDLE xPkcs11Session = 0;
    CK_FUNCTION_LIST_PTR pxPkcs11FunctionList = NULL;
    CK_MECHANISM xMechSha256 = { 0 };
    uint8_t ucSha256Result[ cryptoSHA256_DIGEST_BYTES ];
    CK_ULONG ulLength = sizeof( ucSha256Result );
    uint32_t ulNextSequenceNumber = 0;
    static uint64_t ullKey;
    static CK_BBOOL xKeyIsInitialized = CK_FALSE;

    /* Acquire a crypto session handle. */
    xResult = prvSocketsGetCryptoSession( &xSessionLock,
                                          &xPkcs11Session,
                                          &pxPkcs11FunctionList );

    if( CKR_OK == xResult )
    {
        xSemaphoreTake( xSessionLock, portMAX_DELAY );

        if( CK_FALSE == xKeyIsInitialized )
        {
            /* One-time initialization, per boot, of the random seed. */
            xResult = pxPkcs11FunctionList->C_GenerateRandom( xPkcs11Session,
                                                              ( CK_BYTE_PTR ) &ullKey,
                                                              sizeof( ullKey ) );

            if( xResult == CKR_OK )
            {
                xKeyIsInitialized = CK_TRUE;
            }
        }

        xSemaphoreGive( xSessionLock );
    }

    /* Lock the shared crypto session. */
    xSemaphoreTake( xSessionLock, portMAX_DELAY );

    /* Start a hash. */
    if( CKR_OK == xResult )
    {
        xMechSha256.mechanism = CKM_SHA256;
        xResult = pxPkcs11FunctionList->C_DigestInit( xPkcs11Session, &xMechSha256 );
    }

    /* Hash the seed. */
    if( CKR_OK == xResult )
    {
        xResult = pxPkcs11FunctionList->C_DigestUpdate( xPkcs11Session,
                                                        ( CK_BYTE_PTR ) &ullKey,
                                                        sizeof( ullKey ) );
    }

    /* Hash the source address. */
    if( CKR_OK == xResult )
    {
        xResult = pxPkcs11FunctionList->C_DigestUpdate( xPkcs11Session,
                                                        ( CK_BYTE_PTR ) &ulSourceAddress,
                                                        sizeof( ulSourceAddress ) );
    }

    /* Hash the source port. */
    if( CKR_OK == xResult )
    {
        xResult = pxPkcs11FunctionList->C_DigestUpdate( xPkcs11Session,
                                                        ( CK_BYTE_PTR ) &usSourcePort,
                                                        sizeof( usSourcePort ) );
    }

    /* Hash the destination address. */
    if( CKR_OK == xResult )
    {
        xResult = pxPkcs11FunctionList->C_DigestUpdate( xPkcs11Session,
                                                        ( CK_BYTE_PTR ) &ulDestinationAddress,
                                                        sizeof( ulDestinationAddress ) );
    }

    /* Hash the destination port. */
    if( CKR_OK == xResult )
    {
        xResult = pxPkcs11FunctionList->C_DigestUpdate( xPkcs11Session,
                                                        ( CK_BYTE_PTR ) &usDestinationPort,
                                                        sizeof( usDestinationPort ) );
    }

    /* Get the hash. */
    if( CKR_OK == xResult )
    {
        xResult = pxPkcs11FunctionList->C_DigestFinal( xPkcs11Session,
                                                       ucSha256Result,
                                                       &ulLength );
    }

    xSemaphoreGive( xSessionLock );

    /* Use the first four bytes of the hash result as the starting point for
     * all initial sequence numbers for connections based on the input 4-tuple. */
    if( CKR_OK == xResult )
    {
        memcpy( &ulNextSequenceNumber,
                ucSha256Result,
                sizeof( ulNextSequenceNumber ) );

        /* Add the tick count of four-tick intervals. In theory, per the RFC
         * (see above), this approach still allows server equipment to optimize
         * handling of connections from the same device that haven't fully timed out. */
        ulNextSequenceNumber += xTaskGetTickCount() / 4;
    }

    return ulNextSequenceNumber;
}
/*-----------------------------------------------------------*/

