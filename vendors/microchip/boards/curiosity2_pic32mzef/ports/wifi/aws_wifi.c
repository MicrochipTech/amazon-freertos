/*******************************************************************************
*  File Name:  aws_wifi.c
*  Copyright 2017 Microchip Technology Incorporated and its subsidiaries.
*
*  Amazon FreeRTOS Wi-Fi for SAMG55 using WINC1500
*  Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
*
*  Permission is hereby granted, free of charge, to any person obtaining a copy of
*  this software and associated documentation files (the "Software"), to deal in
*  the Software without restriction, including without limitation the rights to
*  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
*  of the Software, and to permit persons to whom the Software is furnished to do
*  so, subject to the following conditions:
*  The above copyright notice and this permission notice shall be included in all
*  copies or substantial portions of the Software.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*  SOFTWARE
*******************************************************************************/

#include "FreeRTOS.h"
#include <stdio.h>
#include <string.h>
#include "semphr.h"
#include "event_groups.h"
#include "iot_wifi.h"
#include "iot_pkcs11.h"
#include "m2m_types.h"
#include "m2m_wifi.h"
#include "socket.h"
#include "m2m_periph.h"
#include "m2m_ssl.h"
#include "m2m_socket_host_if.h"
#include "ecc_types.h"
#include "cryptoauthlib.h"
#include "wdrv_winc_client_api.h"
#include "atca_cert_chain.h"
#include "iot_pkcs11_config.h"
#include "iot_wifi.h"
#include "types/iot_network_types.h"
#include "configuration.h"

#ifdef WDRV_WINC_DEVICE_WINC1500
#include "flexible_flash.h"
#endif

extern void DHCP_Up();
static void wifi_update();
static DRV_HANDLE wifi_handle=DRV_HANDLE_INVALID;
void AWS_MCHP_ConnectEvent();
void AWS_MCHP_DisconnectEvent();
uint32_t *get_winc_buffer();
void dns_resolve_cb(uint8_t *hostName, uint32_t hostIp);
WIFIReturnCode_t Wifi_Connect_Ex(DRV_HANDLE handle, const WIFINetworkParams_t * const pxNetworkParams);
static void APP_ExampleConnectNotifyCallback(DRV_HANDLE handle, WDRV_WINC_CONN_STATE currentState, WDRV_WINC_CONN_ERROR errorCode);
int8_t ecc_transfer_certificates(uint8_t * subject_key_id);
extern const atcacert_def_t g_cert_def_0_root ;
#define MAX_TLS_CERT_LENGTH			1024
#define SIGNER_CERT_MAX_LEN 		(g_cert_def_1_signer.cert_template_size + 8) // Need some space in case the cert changes size by a few bytes
#define SIGNER_PUBLIC_KEY_MAX_LEN 	64
#define DEVICE_CERT_MAX_LEN			(g_cert_def_2_device.cert_template_size + 8) // Need some space in case the cert changes size by a few bytes
#define CERT_SN_MAX_LEN				32
#define TLS_SRV_ECDSA_CHAIN_FILE	"ECDSA.lst"
#define INIT_CERT_BUFFER_LEN        (MAX_TLS_CERT_LENGTH*sizeof(uint32_t) - TLS_FILE_NAME_MAX*2 - SIGNER_CERT_MAX_LEN - DEVICE_CERT_MAX_LEN)


/* initialization done timeout. */
#define WIFI_MAC_INIT_TIMEOUT                   ( pdMS_TO_TICKS( 5000 ) )
#define WIFI_MAC_CONNECT_TIMEOUT                ( pdMS_TO_TICKS( 15000 ) )
#define WIFI_MAC_DISCONNECT_TIMEOUT             ( pdMS_TO_TICKS( 3000 ) )
#define WIFI_MAC_PING_TIMEOUT                   ( pdMS_TO_TICKS( 5000 ) )
#define WIFI_MAC_SET_CIPHER_TIMEOUT             ( pdMS_TO_TICKS( 3000 ) )


/*Ping block for a free buffer timeout (ms) */
#define WIFI_PING_WAIT_FOR_BUFF_TIMEOUT        ( 10000 / portTICK_PERIOD_MS )

#define WIFI_MAX_PSK_LEN                       (65)
/*!< Maximum size for the WPA PSK including the NULL termination.
 */

/* Self explanatory */
#define IPV4_ADDRESS_LEN (4)

/*Wi-Fi Listen interval */
#define WIFI_LISTEN_INTERVAL	(1)

/** Using IP address. */
#define IPV4_BYTE(val, index)           ((val >> (index * 8)) & 0xFF)


/* The Wi-Fi/IP stack executes in its own task (although any application task can make
use of its services through the published Wi-Fi/IP API). WIFI_TASK_PRIORITY
sets the priority of the task that executes the WiFi stack.  Consideration needs to be given as to
the priority assigned to the task executing the WiFi/IP stack relative to the
priority assigned to tasks that use the WiFi/IP stack. */
#define WIFI_IP_TASK_PRIORITY			( tskIDLE_PRIORITY+2 )

/* The size, in words (not bytes), of the stack allocated to the WiFi+IP
task.  */
#define WIFI_IP_TASK_STACK_SIZE_WORDS	( configMINIMAL_STACK_SIZE * 20 )


#define HTTPS_PROV_SERVER_DN			"https://prov.winc.microchip.com"
#define HTTP_PROV_SERVER_DN				"http://prov.winc.microchip.com"
#define HTTP_PROV_SERVER_IP_ADDRESS		{192, 168, 1, 1}
#define HTTP_REDIRECT_FLAG				1


#define configREJECT( x )		if( ( x ) == 0 ) return eWiFiFailure


/*Network parameters section in samg flash*/
//const uint8_t __attribute__( ( space( prog ), section( "NETWORK_PARAM_SECTION" ), address( WIFI_NETWORK_PARAM_SECTION_START_ADDRESS ) ) ) __attribute__( ( keep ) ) g_network_param;
uint8_t g_network_param[512];
const uint8_t address=0x8000;
const uint8_t * p_network_param = &g_network_param;

/* device mode */
WIFIDeviceMode_t g_device_mode = eWiFiModeStation;

/* callback function for network state change event*/
IotNetworkStateChangeEventCallback_t g_network_change_cb = NULL;
TaskHandle_t waiting_task;
static TaskHandle_t wifi_task = NULL;

/* Wi-Fi serialization semaphore*/
SemaphoreHandle_t xWiFiSemaphore = NULL;
static StaticSemaphore_t xWiFiSemaphoreBuffer;

static DRV_HANDLE wdrvHandle;
/* Internal network connection parameters*/
static char* wifiSSID[wificonfigMAX_SSID_LEN+1] = {0};
static char* wifiPSK[wificonfigMAX_PASSPHRASE_LEN+1] = {0};

static tenuM2mSecType wincSecurityType = M2M_WIFI_SEC_OPEN;
static tstrM2mWifiWepParams	wepInfo={0};
static tstrM2MAPConfig wifiAPConfig={0};
static WIFIPMMode_t wifiPMModeType = eWiFiPMNormal; //eWiFiPMLowPower;
static tstrM2mLsnInt strM2mLsnInt = {WIFI_LISTEN_INTERVAL,{0}};
	
static uint16_t numBeaconIntervals = 0;
/* Internal variable reflecting wifi connection state*/
static uint8_t wifiConnected = false;
static uint8_t tryReconnect = 5;
static uint8_t disconnectRequested = 0;
static uint8_t setChipherRequested = 0;
static uint8_t wifiIPv4Address[IPV4_ADDRESS_LEN] = {0};
static uint32_t dnsHostIP =0;
static uint32_t pingCount=0;
static uint32_t numScannedAP =0;
static tstrM2mWifiscanResult scanResult = {0};
static uint8_t apIPAddress[]	=	HTTP_PROV_SERVER_IP_ADDRESS;
static char gacHttpProvDomainName[] = HTTPS_PROV_SERVER_DN;

// connected AP context
static WDRV_WINC_AUTH_CONTEXT authCtx;
static WDRV_WINC_BSS_CONTEXT  bssCtx;


typedef struct{
	uint32_t	u32FileSz;
	uint8_t	*pu8FileData;
}tstrFileInfo;


static struct _wifi_context
{
    CK_FUNCTION_LIST_PTR    pkcs11_funcs;
    CK_SESSION_HANDLE       pkcs11_session;
    CK_OBJECT_HANDLE        pkcs11_private_key;
    CK_OBJECT_HANDLE        pkcs11_certs[2];
    tstrFileInfo            cert_info[2];
} wifi_context;


/**
 * @brief Maximum time to wait in ticks for obtaining the WiFi semaphore
 * before failing the operation.
 */
const TickType_t xSemaphoreWaitTicks = pdMS_TO_TICKS( wificonfigMAX_SEMAPHORE_WAIT_TIME_MS );

typedef enum
{
    WDRV_MAC_EVENT_INALID_NONE = 0x000,       /* no event/invalid */
    WDRV_MAC_EVENT_INIT_DONE = 0x001,       /* initialization done event */
    WDRV_MAC_EVENT_CONNECT_DONE = 0x002,    /* Connection done event */
    WDRV_MAC_EVENT_DISCONNECT_DONE = 0x004,    /* Disconnection done event */
    WDRV_MAC_EVENT_DNS_DONE = 0x008,    /* DNS done event */
    WDRV_MAC_EVENT_PING_DONE = 0x010,    /* PING done event */
    WDRV_MAC_EVENT_SCAN_DONE = 0x020,    /* Scan done event */
    WDRV_MAC_EVENT_SET_CIPHER_DONE = 0x040,    /* Scan done event */

} WDRV_MAC_EVENT_TYPE;


typedef enum
{
    WIFI_SCAN_STATE_INIT = 0,
    WIFI_SCAN_STATE_SCANNING,
    WIFI_SCAN_STATE_SCAN_GET_RESULTS,
    WIFI_SCAN_STATE_SCAN_DONE,
    WIFI_SCAN_STATE_ERROR
} WIFI_SCAN_STATE;

extern void socket_cb(SOCKET sock, uint8_t u8Msg, void *pvMsg);

size_t winc_certs_get_total_files_size(const tstrTlsSrvSecHdr* header);

DRV_HANDLE get_wifi_handle()
{
    return wifi_handle;
}
  /**
     * @brief Wi-Fi Add Network profile.
     *
     * Adds Wi-Fi network to network list in non-volatile memory
     *
     * @param[in] pxNetworkProfile - network profile parameters
     * @param[out] pusIndex - network profile index
     *
     * @return Profile stored index on success, or negative error code on failure.
     */
    WIFIReturnCode_t WIFI_NetworkAdd( const WIFINetworkProfile_t * const pxNetworkProfile,
                                    uint16_t * pusIndex )
    { 
	return eWiFiModeNotSupported;

}
    
 
/**
 * @brief Registers application callback for network state change events from WiFi layer.
 *
 * @param[in] xCallback Application callback for network state change events.
 *
 * @return @ref eWiFiSuccess if application callback registration was successful, failure code if otherwise.
 */
/* @[declare_wifi_wifi_registernetworkstatechangeeventcallback] */
WIFIReturnCode_t WIFI_RegisterNetworkStateChangeEventCallback( IotNetworkStateChangeEventCallback_t xCallback )
{
    g_network_change_cb = xCallback;
    return eWiFiSuccess;
}
   

/**
 * @brief Wi-Fi Get Network profile .
 *
 * Gets Wi-Fi network parameters at given index from network list in Non volatile memory
 *
 * @param[out] pxNetworkProfile - pointer to return network profile parameters
 * @param[in] usIndex - Index of the network profile,
 *                       must be between 0 to wificonfigMAX_NETWORK_PROFILES
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_NetworkGet( WIFINetworkProfile_t * pxNetworkProfile,
                                  uint16_t usIndex )
{
	return eWiFiModeNotSupported;

}

/**
 * @brief Wi-Fi Delete Network profile .
 *
 * Deletes Wi-Fi network from network list at given index in Non volatile memory
 *
 * @param[in] usIndex - Index of the network profile, must be between 0 to wificonfigMAX_NETWORK_PROFILES
 *                      wificonfigMAX_NETWORK_PROFILES as index will delete all network profiles
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_NetworkDelete( uint16_t usIndex )
{
	return eWiFiModeNotSupported;

}
/**
 * @brief Perform WiF Scan
 *
 * @param[in] pxBuffer - Buffer for scan results.
 * @param[in] uxNumNetworks - Number of networks in scan result.
 *
 * @return eWiFiSuccess if disconnected, eWiFiFailure otherwise.
 */
WIFIReturnCode_t WIFI_Scan( WIFIScanResult_t * pxBuffer,
                            uint8_t ucNumNetworks )
{
    WDRV_WINC_STATUS status;
    WIFI_SCAN_STATE state;
    int found_num = 0;
    
    configREJECT( pxBuffer != NULL );
    
    if (DRV_HANDLE_INVALID == wifi_handle)
    {
        configPRINTF(("[%s] Driver not yet open ...\r\n", __func__));
        return eWiFiSuccess ;
    }
    
    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
	{

        state = WIFI_SCAN_STATE_INIT;
        while (1)
        {
            switch (state)
            {
                case WIFI_SCAN_STATE_INIT:
                {
                    if (WDRV_WINC_STATUS_OK == WDRV_WINC_BSSFindFirst(wifi_handle, WDRV_WINC_ALL_CHANNELS, true, NULL))
                    {
                        state = WIFI_SCAN_STATE_SCANNING;
                    }
                }
                case WIFI_SCAN_STATE_SCANNING:
                {
                    /* Wait for BSS find operation to complete, then report the number
                     of results found. */

                    if (false == WDRV_WINC_BSSFindInProgress(wifi_handle))
                    {
                        configPRINTF (("Scan complete, %d AP(s) found\r\n", WDRV_WINC_BSSFindGetNumBSSResults(wifi_handle)));
                        state = WIFI_SCAN_STATE_SCAN_GET_RESULTS;
                    }
                    break;
                }
                case WIFI_SCAN_STATE_SCAN_GET_RESULTS:
                {
                    WDRV_WINC_BSS_INFO BSSInfo;

                    /* Request the current BSS find results. */
                    if (WDRV_WINC_STATUS_OK == WDRV_WINC_BSSFindGetInfo(wifi_handle, &BSSInfo))
                    {
                        configPRINTF(("AP found: RSSI: %d %s\r\n", BSSInfo.rssi, BSSInfo.ssid.name));

                        if (found_num >= ucNumNetworks)
                        {
                            xSemaphoreGive(xWiFiSemaphore);
                            return eWiFiSuccess;
                        }
                        memset(&pxBuffer[found_num], 0, sizeof(WIFIScanResult_t));
                        memcpy(pxBuffer[found_num].cSSID,BSSInfo.ssid.name,BSSInfo.ssid.length);
                        memcpy(pxBuffer[found_num].ucBSSID,BSSInfo.bssid,wificonfigMAX_BSSID_LEN);
                        pxBuffer[found_num].cChannel = BSSInfo.channel;
                        pxBuffer[found_num].cRSSI = BSSInfo.rssi;                

                        if (BSSInfo.authType == WDRV_WINC_AUTH_TYPE_OPEN)      
                            pxBuffer[found_num].xSecurity = eWiFiSecurityOpen;
                        else if (BSSInfo.authType == WDRV_WINC_AUTH_TYPE_WEP)      
                            pxBuffer[found_num].xSecurity = eWiFiSecurityWEP;
                        else if (BSSInfo.authType == WDRV_WINC_AUTH_TYPE_WPA_PSK)      
                            pxBuffer[found_num].xSecurity = eWiFiSecurityWPA2 ;
                        else 
                            pxBuffer[found_num].xSecurity = eWiFiSecurityNotSupported ;


                        found_num++;
                        /* Request the next set of BSS find results. */
                        status = WDRV_WINC_BSSFindNext(wifi_handle, NULL);

                        if (WDRV_WINC_STATUS_BSS_FIND_END == status)
                        {   
                            state = WIFI_SCAN_STATE_SCAN_DONE;  
                            xSemaphoreGive(xWiFiSemaphore);
                            return eWiFiSuccess;
                        }
                        else if ((WDRV_WINC_STATUS_NOT_OPEN == status) || (WDRV_WINC_STATUS_INVALID_ARG == status))
                        {
                            /* An error occurred requesting results. */
                            state = WIFI_SCAN_STATE_ERROR;
                        }
                    }
                    break;
                }
                case WIFI_SCAN_STATE_ERROR:
                {
                    xSemaphoreGive(xWiFiSemaphore);
                    return eWiFiFailure;
                    break;
                }
                default:
                {
                    break;
                }
            }

            vTaskDelay(10 / portTICK_PERIOD_MS);
        }

        xSemaphoreGive(xWiFiSemaphore);
    }
    
    
    return eWiFiNotSupported;
}
/*-----------------------------------------------------------*/


/**
 * @brief Sets Wi-Fi mode.
 *
 * @param[in] xDeviceMode - Mode of the device Station / Access Point /P2P.
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_SetMode( WIFIDeviceMode_t xDeviceMode )
{
    configREJECT( xDeviceMode != eWiFiModeNotSupported );
    
    if (xDeviceMode == eWiFiModeP2P)
        return eWiFiNotSupported;
    
    if (xDeviceMode == eWiFiModeAP)
    {
        g_device_mode = eWiFiModeAP;
        WDRV_WINC_BSSDisconnect(wifi_handle);
    }
    else if (xDeviceMode == eWiFiModeStation)
    {
        g_device_mode = eWiFiModeStation;
        WDRV_WINC_APStop(wifi_handle);
    }    
    return eWiFiSuccess;
}

/**
 * @brief Gets Wi-Fi mode.
 *
 * @param[in] pxDeviceMode - return mode Station / Access Point /P2P
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise..
 */
WIFIReturnCode_t WIFI_GetMode( WIFIDeviceMode_t * pxDeviceMode )
{    
    return eWiFiNotSupported;
}

/************************************* Section: worker code ************************************************** */

signed char wifi_winc_crypto_init(void)
{
    CK_RV       xResult = CKR_OK;
    CK_SLOT_ID  slots[2] = {0, 0};
    CK_ULONG    ulCount;
    int         i;

    /* Ensure that the PKCS#11 module is initialized. */
    if (CKR_OK == xResult)
    {
        xResult = C_GetFunctionList(&wifi_context.pkcs11_funcs);
    }

    if (CKR_OK == xResult)
    {
        CK_C_INITIALIZE_ARGS init_args = { NULL, NULL, NULL, NULL, CKF_OS_LOCKING_OK, NULL};
        xResult = wifi_context.pkcs11_funcs->C_Initialize( &init_args );

        if (CKR_CRYPTOKI_ALREADY_INITIALIZED == xResult)
        {
            xResult = CKR_OK;
        }
    }

    /* Get the default private key storage ID. */
    if (CKR_OK == xResult)
    {
        ulCount = sizeof(slots)/sizeof(slots[0]);
        xResult = wifi_context.pkcs11_funcs->C_GetSlotList( CK_TRUE, &slots, &ulCount );
    }

    /* Start a private session with the P#11 module. */
    if (CKR_OK == xResult)
    {
        xResult = wifi_context.pkcs11_funcs->C_OpenSession( slots[0], CKF_SERIAL_SESSION,
                                                            NULL, NULL, &wifi_context.pkcs11_session );
    }

    /* Enumerate the first private key. */
    if (CKR_OK == xResult)
    {
        CK_OBJECT_CLASS xObjClass = CKO_PRIVATE_KEY;
        CK_ATTRIBUTE    xTemplate = { CKA_CLASS, &xObjClass, sizeof( CKA_CLASS )};

        xResult = wifi_context.pkcs11_funcs->C_FindObjectsInit( wifi_context.pkcs11_session, &xTemplate, 1 );
    }

    if (CKR_OK == xResult)
    {
        ulCount = 0;
        xResult = wifi_context.pkcs11_funcs->C_FindObjects( wifi_context.pkcs11_session, &wifi_context.pkcs11_private_key, 1, &ulCount );
    }

    if (CKR_OK == xResult)
    {
        xResult = wifi_context.pkcs11_funcs->C_FindObjectsFinal( wifi_context.pkcs11_session );
    }

    /* Enumerate the client certificate chain */
    if( 0 == xResult )
    {
        CK_OBJECT_CLASS xObjClass = CKO_CERTIFICATE;
        CK_ATTRIBUTE    xTemplate = { CKA_CLASS, &xObjClass, sizeof( CKA_CLASS )};

        xResult = wifi_context.pkcs11_funcs->C_FindObjectsInit( wifi_context.pkcs11_session, &xTemplate, 1 );
    }

    if( 0 == xResult )
    {
        ulCount = 0;
        xResult = wifi_context.pkcs11_funcs->C_FindObjects( wifi_context.pkcs11_session, wifi_context.pkcs11_certs, 
                                                            sizeof(wifi_context.pkcs11_certs)/sizeof(wifi_context.pkcs11_certs[0]), &ulCount );
    }

    if( 0 == xResult )
    {
        xResult = wifi_context.pkcs11_funcs->C_FindObjectsFinal( wifi_context.pkcs11_session );
    }
 
    /* Load Certificate(s) */
    for(i=0; (i < ulCount) && !xResult; i++)
    {
        CK_ATTRIBUTE    xTemplate = { CKA_VALUE, NULL, 0};
        if( 0 == xResult )
        {
            /* Query the certificate size. */
            xResult = wifi_context.pkcs11_funcs->C_GetAttributeValue( wifi_context.pkcs11_session, wifi_context.pkcs11_certs[i], &xTemplate, 1 );
            wifi_context.cert_info[i].u32FileSz = xTemplate.ulValueLen;
        }

        if( 0 == xResult )
        {
            /* Create a buffer for the certificate. */
            wifi_context.cert_info[i].pu8FileData = pvPortMalloc( wifi_context.cert_info[i].u32FileSz ); 

            if( NULL == wifi_context.cert_info[i].pu8FileData )
            {
                xResult = ( BaseType_t ) CKR_HOST_MEMORY;
            }
        }

        if( 0 == xResult )
        {
            /* Export the certificate. */
            xTemplate.pValue = wifi_context.cert_info[i].pu8FileData;
            xTemplate.ulValueLen = wifi_context.cert_info[i].u32FileSz;
            xResult = wifi_context.pkcs11_funcs->C_GetAttributeValue( wifi_context.pkcs11_session, wifi_context.pkcs11_certs[i], &xTemplate, 1 );
            wifi_context.cert_info[i].u32FileSz = xTemplate.ulValueLen;
        }
    }


    if( 0 == xResult )
    {
        xResult = m2m_wifi_download_mode();
    }

    if( 0 == xResult )
    {
        /* Write the TLS ECC based certificates to WINC */
       // xResult = WriteTlsCertificate(NULL, 0, wifi_context.cert_info, ulCount);
        ecc_transfer_certificates(pcPkcs11GetThingName());
    }

    /* Clean up the temporary buffers used for certificate loading */
    for(i=0; i < sizeof(wifi_context.cert_info)/sizeof(wifi_context.cert_info[0]); i++)
    {
        if(wifi_context.cert_info[i].pu8FileData)
        {
            vPortFree(wifi_context.cert_info[i].pu8FileData);
            wifi_context.cert_info[i].pu8FileData = NULL;
        }
    }

    /* Attempt to close the PKCS11 Session */
    if (wifi_context.pkcs11_funcs)
    {
        wifi_context.pkcs11_funcs->C_CloseSession(wifi_context.pkcs11_session);
    }
}

signed char wifi_winc_crypto_deinit(void)
{
    if (wifi_context.pkcs11_funcs)
    {
        (void)wifi_context.pkcs11_funcs->C_CloseSession(wifi_context.pkcs11_session);
    }
    memset(&wifi_context, 0, sizeof(wifi_context));
}

/*-----------------------------------------------------------*/

void AWS_MCHP_ConnectEvent(void)
{
     wifiConnected = true;
	 tryReconnect = 5;
     WDRV_WINC_SystemTimeGetCurrent(wifi_handle, NULL);
     xTaskNotify( waiting_task, WDRV_MAC_EVENT_CONNECT_DONE, eSetBits );
}

void AWS_MCHP_DisconnectEvent(void)
{
     wifiConnected = false;

	/*If the AP disconnected without an explicit request, attempt a reconnection for maximum of 5 times*/
	if((!disconnectRequested) && tryReconnect)
	{
		/* If the AP disconnected without an explicit request, attempt a reconnection */
        WDRV_WINC_BSSConnect(wifi_handle, &bssCtx, &authCtx, &APP_ExampleConnectNotifyCallback);

        //SHAN: TODO
		tryReconnect--;
	}
	/*Don't notify waiting task unless give up with reconnection attempts*/
	else
	{	
        if (disconnectRequested)
            xTaskNotify( waiting_task, WDRV_MAC_EVENT_DISCONNECT_DONE, eSetBits );
	}

	disconnectRequested = 0;
}

static void AWS_MCHP_DNSEvent(void)
{
     xTaskNotify( waiting_task, WDRV_MAC_EVENT_DNS_DONE, eSetBits );
}

static void AWS_MCHP_PingEvent(void)
{
     xTaskNotify( waiting_task, WDRV_MAC_EVENT_PING_DONE, eSetBits );
}

static void AWS_MCHP_ScanEvent(void)
{
     xTaskNotify( waiting_task, WDRV_MAC_EVENT_SCAN_DONE, eSetBits );
}

/*-----------------------------------------------------------*/

/**
 * \brief Callback function of DNS to resolve IP address.
 *
 * \param[in] hostName Domain name.
 * \param[in] hostIp Server IP.
 *
 * \return None.
 */
void dns_resolve_cb(uint8_t *hostName, uint32_t hostIp)
{
	
	configPRINTF(("Host IP is %d.%d.%d.%d\r\n", (int)IPV4_BYTE(hostIp, 0), (int)IPV4_BYTE(hostIp, 1),
			(int)IPV4_BYTE(hostIp, 2), (int)IPV4_BYTE(hostIp, 3)));
	configPRINTF(("Host Name is %s\r\n", hostName));
	dnsHostIP = hostIp;
	AWS_MCHP_DNSEvent();
}

void initialize_wifi()
{
    /* Create a binary semaphore for API mutual execution */
    if (xWiFiSemaphore == NULL){
        xWiFiSemaphore = xSemaphoreCreateBinaryStatic( &xWiFiSemaphoreBuffer );
		
        if (xWiFiSemaphore == NULL){
            /* Init failed. */
            configPRINTF( ( "\r\nfailed to allocate Wi-Fi semaphore\r\n" ) );
            return eWiFiFailure;
        }
    
        if( xSemaphoreGive( xWiFiSemaphore ) != pdTRUE )
        {
             // We would expect this call to not fail to allow one task in
             configPRINTF( ( "\r\nfailed to Give Wi-Fi semaphore\r\n" ) );
             return eWiFiFailure;
        }
    }
}

/*-----------------------------------------------------------*/

void pingCb(DRV_HANDLE handle,uint32_t u32IPAddr, uint32_t u32RTT, WDRV_WINC_ICMP_ECHO_STATUS statusCode)
{
	configPRINTF(("Ping status %u, addr=0x%x\r\n", statusCode, u32IPAddr));
	if (statusCode == PING_ERR_SUCCESS)
	{
		configPRINTF(("Ping Success\n"));
		AWS_MCHP_PingEvent();
	}
}


void ssl_cipher_suit_ctx_cb(DRV_HANDLE handle, WDRV_WINC_CIPHER_SUITE_CONTEXT *pSSLCipherSuiteCtx)
{
     configPRINTF(("[ssl_cipher_suit_ctx_cb] cipherSuites = %d \r\n", pSSLCipherSuiteCtx->ciperSuites));
     if (setChipherRequested)
        xTaskNotify( waiting_task, WDRV_MAC_EVENT_SET_CIPHER_DONE, eSetBits );
}


static signed char ecdh_derive_client_shared_secret(
    WDRV_WINC_EC_Point_Rep *server_public_key,
    uint8_t *ecdh_shared_secret,
    WDRV_WINC_EC_Point_Rep *client_public_Key
)
{
	signed char status = M2M_ERR_FAIL;

    configPRINTF(("ecdh_derive_client_shared_secret called\r\n"));

    if (ATCA_SUCCESS == atcab_genkey(GENKEY_PRIVATE_TO_TEMPKEY, client_public_Key->x))
    {
        client_public_Key->size = 32;
        if (ATCA_SUCCESS == atcab_ecdh_tempkey(server_public_key->x, ecdh_shared_secret))
        {
            status = M2M_SUCCESS;
        }
    }
	return status;
}

static signed char ecdh_derive_key_pair(tstrECPoint *server_public_key)
{
	signed char status = M2M_ERR_FAIL;
	
    configPRINTF(("ecdh_derive_key_pair called\r\n"));

	return status;
}

static signed char ecdsa_process_sign_verify_request(uint32_t number_of_signatures)
{
	WDRV_WINC_EC_Point_Rep	Key;
	uint32_t index = 0;
	uint8_t signature[80];
	uint8_t hash[80] = {0};
	uint16_t curve_type = 0;
	signed char status = M2M_ERR_FAIL;

	for(index = 0; index < number_of_signatures; index++)
	{
		status = WDRV_WINC_SSLRetrieveCert(&curve_type, hash, signature, &Key);
		if (status != WDRV_WINC_STATUS_OK)
		{
			configPRINTF(("m2m_ssl_retrieve_cert() failed with ret=%d", status));
			return status;
		}

		if(curve_type == EC_SECP256R1)
		{
			bool is_verified = false;
			status = atcab_verify_extern(hash, signature, Key.x, &is_verified);
			status = M2M_SUCCESS;
			break;
			if(status == ATCA_SUCCESS)
			{
				status = (is_verified == true) ? M2M_SUCCESS : M2M_ERR_FAIL;
				if(is_verified == false)
				{
					configPRINTF(("ECDSA SigVerif FAILED\n"));
				}
			}
			else
			{
				status = M2M_ERR_FAIL;
			}
			
			if(status != M2M_SUCCESS)
			{
				WDRV_WINC_SSLStopRetrieveCert();
				break;
			}
		}
	}
	return status;
}

static signed char ecdsa_process_sign_gen_request(tstrEcdsaSignReqInfo *sign_request,
uint8_t *signature,
uint16_t *signature_size)
{
    CK_RV xResult = CKR_OK;
	CK_MECHANISM xMech = { CKM_SHA256, NULL, 0 };
    CK_ULONG ulSigSize;
    uint8_t hash[32];
    CK_SLOT_ID  slots[2] = {0, 0};
    CK_ULONG    ulCount;

    configPRINTF(("ecdsa_process_sign_gen_request called\r\n"));
    
    xResult = WDRV_WINC_SSLRetrieveHash(hash, sign_request->u16HashSz);
    if (WDRV_WINC_STATUS_OK != xResult)
    {
        M2M_ERR("m2m_ssl_retrieve_hash() failed with ret=%d", xResult);
        return xResult;
    }

    /* Get the default private key storage ID. */
    if (CKR_OK == xResult)
    {
        ulCount = sizeof(slots)/sizeof(slots[0]);
        xResult = wifi_context.pkcs11_funcs->C_GetSlotList( CK_TRUE, &slots, &ulCount );
    }

    /* Start a private session with the P#11 module. */
    if (CKR_OK == xResult)
    {
        xResult = wifi_context.pkcs11_funcs->C_OpenSession( slots[0], CKF_SERIAL_SESSION,
                                                            NULL, NULL, &wifi_context.pkcs11_session );
    }

   	/* Use the PKCS#11 module to sign. */
	xResult =  wifi_context.pkcs11_funcs->C_SignInit(wifi_context.pkcs11_session, &xMech, 
                                                    wifi_context.pkcs11_private_key);

    /* Perform the signature */
    if (CKR_OK == xResult)
    {
        ulSigSize = 64;
        xResult =  wifi_context.pkcs11_funcs->C_Sign(wifi_context.pkcs11_session, hash, 
                                                    sizeof(hash), signature, &ulSigSize);
        *signature_size = ulSigSize;
    }

    /* Attempt to close the PKCS11 Session */
    if (wifi_context.pkcs11_funcs)
    {
        wifi_context.pkcs11_funcs->C_CloseSession(wifi_context.pkcs11_session);
    }

    return xResult;
}

static signed char ecdh_derive_server_shared_secret(uint16_t private_key_id,
WDRV_WINC_EC_Point_Rep *client_public_key,
uint8_t *ecdh_shared_secret)
{
	signed char status = M2M_ERR_FAIL;

    configPRINTF(("ecdh_derive_server_shared_secret called\r\n"));

    if (ATCA_SUCCESS == atcab_ecdh_tempkey(client_public_key->x, ecdh_shared_secret))
    {
		status = M2M_SUCCESS;
	}
	
	return status;
}
void ssl_req_ecc_cb(DRV_HANDLE handle, WDRV_WINC_ECC_REQ_INFO ecc_request, void *pParams )
{
    configPRINTF(("[%s] In\r\n", __func__));
    
    WDRV_WINC_ECC_RSP_INFO ecc_response;
    
    
	uint8_t signature[80];
	uint16_t response_data_size = 0;
	uint8_t *response_data_buffer = NULL;
	
	ecc_response.status = 1;

	switch (ecc_request.reqCmd)
	{
		case ECC_REQ_CLIENT_ECDH:
        {
            WDRV_WINC_ECDH_REQ_INFO *pEcdhReqInfo;
            pEcdhReqInfo = (WDRV_WINC_ECDH_REQ_INFO *) pParams;
            
            ecc_response.status = ecdh_derive_client_shared_secret(&(pEcdhReqInfo->pubKey),
            ecc_response.ecdhRspInfo.key,
            &ecc_response.ecdhRspInfo.pubKey);
            break;
        }

		case ECC_REQ_GEN_KEY:   
        {
            ecc_response.status = ecdh_derive_key_pair(&ecc_response.ecdhRspInfo.pubKey);
            break;
        }
		case ECC_REQ_SERVER_ECDH:
        {
            WDRV_WINC_ECDH_REQ_INFO *pEcdhReqInfo;
            pEcdhReqInfo = (WDRV_WINC_ECDH_REQ_INFO *) pParams;    
            
            ecc_response.status = ecdh_derive_server_shared_secret(pEcdhReqInfo->pubKey.privKeyID,
            &(pEcdhReqInfo->pubKey),
            ecc_response.ecdhRspInfo.key);
            break;
		}
		case ECC_REQ_SIGN_VERIFY:
        {
            WDRV_WINC_ECDSA_VERIFY_REQ_INFO *pEcdsaVerifyReqInfo;
            pEcdsaVerifyReqInfo = (WDRV_WINC_ECDSA_VERIFY_REQ_INFO *) pParams;
            
            ecc_response.status = ecdsa_process_sign_verify_request(pEcdsaVerifyReqInfo->nSig);

            break;
        }
		
		case ECC_REQ_SIGN_GEN:
        {
            WDRV_WINC_ECDSA_SIGN_REQ_INFO *pEcdsaSignReqInfo;
            pEcdsaSignReqInfo = (WDRV_WINC_ECDSA_SIGN_REQ_INFO *) pParams; 
            ecc_response.status = ecdsa_process_sign_gen_request(pEcdsaSignReqInfo, signature,
            &response_data_size);
            response_data_buffer = signature;
            break;
		}
		default:
		// Do nothing
		break;
	}
	
	ecc_response.reqCmd  = ecc_request.reqCmd;
	ecc_response.userData = ecc_request.userData;
	ecc_response.seqNo   = ecc_request.seqNo;

	WDRV_WINC_SSLECCHandShakeRsp(ecc_response, response_data_buffer, response_data_size);
}

/*-----------------------------------------------------------*/

/**
 * @brief Initializes the Wi-Fi module.
 *
 * This function must be called exactly once before any other
 * Wi-Fi functions (including socket functions) can be used.
 *
 * @return eWiFiSuccess if everything succeeds, eWiFiFailure otherwise.
 */
WIFIReturnCode_t WIFI_On( void )
{
     int8_t ret;
     EventBits_t evBits;
    tstrWifiInitParam param;
  	WDRV_WINC_CIPHER_SUITE_CONTEXT cipher_ctx;
    //Read Here first!!!.
    
    uint16_t cipherSuite[2] = {WDRV_WINC_TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, \
        WDRV_WINC_TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256};

    configPRINTF( ( "\r\nturning Wi-Fi On\r\n" ) );
    
    if (wifi_handle != DRV_HANDLE_INVALID)
        return eWiFiSuccess;
        
	if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
	{
  	/* Initialize the crypto system and copy certificates if required */

        while (SYS_STATUS_READY != WDRV_WINC_Status(sysObj.drvWifiWinc))
         {
            vTaskDelay(100);
         }
        
        wifi_handle = WDRV_WINC_Open(0, (int)NULL);

        if (DRV_HANDLE_INVALID == wifi_handle)
        {
            configPRINTF( ( "\r\nturning Wi-Fi On Failure\r\n" ) ); 
            xSemaphoreGive(xWiFiSemaphore);
            return eWiFiFailure;
        }
        wifi_update();
        
        /* set DNS/IP callbacks */
        registerSocketCallback( socket_cb, dns_resolve_cb);

        waiting_task = xTaskGetCurrentTaskHandle();
        
        
        WDRV_WINC_SSLCTXCipherSuitesSet(&cipher_ctx, cipherSuite, 2);
        ret = WDRV_WINC_SSLActiveCipherSuitesSet(wifi_handle, &cipher_ctx, &ssl_cipher_suit_ctx_cb, &ssl_req_ecc_cb);
		if (ret == WDRV_WINC_STATUS_OK)
            configPRINTF( ( "\r\n Setting Cipher Success\r\n" ) );
        else
            configPRINTF( ( "\r\n Setting Cipher Fail\r\n" ) );

        setChipherRequested = 1;
        xTaskNotifyWait( WDRV_MAC_EVENT_SET_CIPHER_DONE, WDRV_MAC_EVENT_SET_CIPHER_DONE, &evBits, WIFI_MAC_SET_CIPHER_TIMEOUT );

        if( ( evBits & WDRV_MAC_EVENT_SET_CIPHER_DONE ) == 0 )
        {
            /* Timed out. */
            configPRINTF( ( "Set Cipher timeout\r\n" ) );
            setChipherRequested = 0;
	     	xSemaphoreGive(xWiFiSemaphore);

            return eWiFiTimeout;
        }
        
        setChipherRequested = 0;
		xSemaphoreGive(xWiFiSemaphore);
        configPRINTF( ( "Set Cipher success 1\r\n" ) );
	
	}
	else
	    return eWiFiTimeout;
	    

	
    return eWiFiSuccess;
}

/*-----------------------------------------------------------*/

static void wifi_update()
{
    
        	    // Update the TLS cert chain on the WINC.
        if (m2m_ssl_send_certs_to_winc((uint8_t *)get_winc_buffer(),
			(uint32_t)winc_certs_get_total_files_size((tstrTlsSrvSecHdr*)get_winc_buffer())) != M2M_SUCCESS)
        {
            return ;
        }
}


/**
 * @brief Turns off the Wi-Fi module.
 *
 * This function turns off Wi-Fi module.
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_Off( void )
{
#ifdef WDRV_WINC_DEVICE_WINC1500
    return eWiFiSuccess;
#endif
    
    if (DRV_HANDLE_INVALID == wifi_handle)
    {
        configPRINTF(("[%s] Driver not yet open ...\r\n", __func__));
        return eWiFiSuccess ;
    }
    
    socketDeinit();
    
    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {   
	 configPRINTF(("Powering Down WINC1500\r\n"));
     if(wifi_handle != DRV_HANDLE_INVALID)
        WDRV_WINC_Close(wifi_handle);
     wifi_handle=DRV_HANDLE_INVALID;
    }
    else
        return eWiFiTimeout;
    
    xSemaphoreGive(xWiFiSemaphore);

    return eWiFiSuccess;
}


/*-----------------------------------------------------------*/

/**
 * @brief Connects to Access Point.
 *
 * @param[in] pxNetworkParams Configuration to join AP.
 *
 * @return eWiFiSuccess if connection is successful, failure code otherwise.
 */
WIFIReturnCode_t WIFI_ConnectAP( const WIFINetworkParams_t * const pxNetworkParams )
{
    EventBits_t evBits;
    uint8_t ret =0;
	uint8_t channelNum;

    configREJECT( pxNetworkParams != NULL );
    configREJECT( pxNetworkParams->pcSSID != NULL );
    
    channelNum = pxNetworkParams->cChannel;
    
    if ( g_device_mode != eWiFiModeStation )
        return eWiFiFailure;

    if  (( pxNetworkParams->xSecurity == eWiFiSecurityNotSupported )||
        ( pxNetworkParams->ucSSIDLength > wificonfigMAX_SSID_LEN )||
        ( pxNetworkParams->pcSSID == NULL )||
        ( pxNetworkParams->ucSSIDLength == 0 )||
        ( pxNetworkParams->ucPasswordLength > wificonfigMAX_PASSPHRASE_LEN ))
    {
        return eWiFiFailure;
    }

    if ( pxNetworkParams->xSecurity != eWiFiSecurityOpen )
    {
    	configREJECT(pxNetworkParams->pcPassword);
    	configREJECT(pxNetworkParams->ucPasswordLength);
    }

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {

	if(wifiConnected)
	{
			xSemaphoreGive(xWiFiSemaphore);
			WIFI_Disconnect();
			xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks );
	}
	
    waiting_task = xTaskGetCurrentTaskHandle();

    memcpy(wifiSSID , pxNetworkParams->pcSSID, strlen(pxNetworkParams->pcSSID));
    wifiSSID[ strlen(pxNetworkParams->pcSSID) ] = '\0';
    
    /*Set the AP security. */
    if (eWiFiSecurityOpen == pxNetworkParams->xSecurity)
    {
        wincSecurityType = M2M_WIFI_SEC_OPEN;
    }
	else if(eWiFiSecurityWEP == pxNetworkParams->xSecurity)
	{
	     wincSecurityType = M2M_WIFI_SEC_WEP;
	     wepInfo.u8KeyIndx = M2M_WIFI_WEP_KEY_INDEX_1; //assume index = 1
	     wepInfo.u8KeySz = pxNetworkParams->ucPasswordLength; 
	     memcpy( wepInfo.au8WepKey , pxNetworkParams->pcPassword, strlen(pxNetworkParams->pcPassword));
		 wepInfo.au8WepKey[ strlen(pxNetworkParams->pcPassword) ] = '\0';
	}
	else if((eWiFiSecurityWPA == pxNetworkParams->xSecurity)||
		(eWiFiSecurityWPA2 == pxNetworkParams->xSecurity))
	{
	     wincSecurityType = M2M_WIFI_SEC_WPA_PSK;
	     memcpy( wifiPSK, pxNetworkParams->pcPassword, strlen(pxNetworkParams->pcPassword));
		 wifiPSK[ strlen(pxNetworkParams->pcPassword) ] = '\0';
	}
	else
	{
	    xSemaphoreGive(xWiFiSemaphore);
		return eWiFiNotSupported;
	}

	if((pxNetworkParams->cChannel < 1) || (pxNetworkParams->cChannel > 14))
		channelNum = M2M_WIFI_CH_ALL;
	
        configPRINTF( ( "Start Wi-Fi Connection... SSID: %s\r\n" , wifiSSID) );

        if( ret != M2M_SUCCESS )
        {
            /* Connection failed miserably. */
	        xSemaphoreGive(xWiFiSemaphore);
            return eWiFiFailure;
        }
        
        if (Wifi_Connect_Ex(wifi_handle,pxNetworkParams) !=eWiFiSuccess)
        {
            xSemaphoreGive(xWiFiSemaphore);  
            return eWiFiFailure;
        }
        
        
        xTaskNotifyWait( WDRV_MAC_EVENT_CONNECT_DONE, WDRV_MAC_EVENT_CONNECT_DONE, &evBits, WIFI_MAC_CONNECT_TIMEOUT );

        if( ( evBits & WDRV_MAC_EVENT_CONNECT_DONE ) == 0 )
        {
            /* Timed out. */
            configPRINTF( ( "Connection timeout\r\n" ) );
            tryReconnect = 0;
	     	xSemaphoreGive(xWiFiSemaphore);
             
            return eWiFiTimeout;
        }
        
         xSemaphoreGive(xWiFiSemaphore);      
         vTaskDelay(5000);// WIFI wait for DHCP
        return eWiFiSuccess;

    }
    else
        return eWiFiTimeout;
    
}

/*-----------------------------------------------------------*/

/**
 * @brief Disconnects from Access Point.
 *
 * @param[in] None.
 *
 * @return eWiFiSuccess if disconnected, failure code otherwise.
 */
WIFIReturnCode_t WIFI_Disconnect( void )
{
    EventBits_t evBits;
    WDRV_WINC_STATUS results;

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {

	    if (!wifiConnected)
	    {
	        xSemaphoreGive(xWiFiSemaphore);
	        return eWiFiSuccess;
	    }

    	 disconnectRequested = 1;
		 
        results = WDRV_WINC_BSSDisconnect(wifi_handle);

        configPRINTF( ( "WDRV_WINC_BSSDisconnect, results=%d \r\n", results ) );
           
	    waiting_task = xTaskGetCurrentTaskHandle();
	
        /* Wait for Wi-Fi disconnection to complete. */
        xTaskNotifyWait( WDRV_MAC_EVENT_DISCONNECT_DONE, WDRV_MAC_EVENT_DISCONNECT_DONE, &evBits, WIFI_MAC_DISCONNECT_TIMEOUT );

        if( ( evBits & WDRV_MAC_EVENT_DISCONNECT_DONE ) == 0 )
        {
            /* Timed out. */
            configPRINTF( ( "Disconnection timeout\r\n" ) );
            disconnectRequested = 0;
	     	xSemaphoreGive(xWiFiSemaphore);           
            return eWiFiTimeout;
        }
    }
    else
    {
        return eWiFiTimeout;
    }
    
    xSemaphoreGive(xWiFiSemaphore);
    disconnectRequested = 0;
    configPRINTF( ( "Disconnection done\r\n" ) );

    return eWiFiSuccess;
}

/*-----------------------------------------------------------*/

/**
 * @brief Resets the WiFi Module.
 *
 * @param[in] None.
 *
 * @return eWiFiSuccess if disconnected, failure code otherwise.
 */
WIFIReturnCode_t WIFI_Reset( void )
{
    WIFIReturnCode_t ret = eWiFiSuccess;


    ret = WIFI_Off();

    if( ret != eWiFiSuccess )
    {
        configPRINTF( ( "Failed to turn off WiFi module\n" ) );

        return ret;
    }

    ret = WIFI_On();

    if( ret != eWiFiSuccess )
    {
        configPRINTF( ( "Failed to turn on WiFi module\n" ) );

        return ret;
    }

    return ret;
}

/*-----------------------------------------------------------*/

/**
 * @brief Retrieves host IP address from URL using DNS
 *
 * @param[in] pcHost - Host URL.
 * @param[in] pucIPAddr - IP Address buffer.
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 *
 */
WIFIReturnCode_t WIFI_GetHostIP( char * pcHost,
                                 uint8_t * pucIPAddr )
{
    WIFIReturnCode_t xStatus = eWiFiSuccess;
    EventBits_t evBits;

    configREJECT( pcHost != NULL );
    configREJECT( pucIPAddr != NULL );



    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {   
  		xStatus = gethostbyname(pcHost);
		if(xStatus != eWiFiSuccess)
		{
			xSemaphoreGive(xWiFiSemaphore);
			return eWiFiFailure;
		}
			
		waiting_task = xTaskGetCurrentTaskHandle();

		xSemaphoreGive(xWiFiSemaphore);

		/* Wait for resolve DNS to complete. */
		xTaskNotifyWait( WDRV_MAC_EVENT_DNS_DONE, WDRV_MAC_EVENT_DNS_DONE, &evBits, WIFI_MAC_CONNECT_TIMEOUT );

		if( ( evBits & WDRV_MAC_EVENT_DNS_DONE ) == 0 )
		{
			/* Timed out. */
			configPRINTF( ( "DNS resolve timeout\r\n" ) );
			return eWiFiTimeout;
		}
		else if(dnsHostIP == 0)
		{
			xSemaphoreGive(xWiFiSemaphore);
			return eWiFiFailure;
		}
		else
		{
			memcpy(pucIPAddr, &dnsHostIP, sizeof(uint32_t));
		}
    }
    else
        return eWiFiTimeout;
    
    return xStatus;
}

/*-----------------------------------------------------------*/


/**
 * @brief Retrieves the Wi-Fi interface's IP address.
 *
 * @param[in] pucIPAddr - IP Address buffer.
 * unsigned long ulIPAddress = 0;
 * WIFI_GetIP(&ulIPAddress);
 *
 * @return eWiFiSuccess if disconnected, eWiFiFailure otherwise.
 */
WIFIReturnCode_t WIFI_GetIP( uint8_t * pucIPAddr )
{
    configREJECT( pucIPAddr != NULL );
    memcpy(pucIPAddr, wifiIPv4Address, IPV4_ADDRESS_LEN);
    return eWiFiSuccess;
}

/*-----------------------------------------------------------*/

/**
 * @brief Configure SoftAP
 *
 * @param[in] pxNetworkParams - Network params to configure and start soft AP.
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_ConfigureAP( const WIFINetworkParams_t * const pxNetworkParams )
{
    configREJECT( pxNetworkParams != NULL );
    configREJECT( pxNetworkParams->pcSSID != NULL );

    if( pxNetworkParams->xSecurity != eWiFiSecurityOpen )
    {
        configREJECT( pxNetworkParams->pcPassword != NULL );
    }
	
    if( pxNetworkParams->ucSSIDLength > wificonfigMAX_SSID_LEN )
    {
        return eWiFiFailure;
    }
	
    if( pxNetworkParams->ucPasswordLength > wificonfigMAX_PASSPHRASE_LEN )
    {
        return eWiFiFailure;
    }

    /*clear AP paramters */
    memset(&wifiAPConfig, 0, sizeof(wifiAPConfig));
	
    /* Set the AP channel. */
    wifiAPConfig.u8ListenChannel = pxNetworkParams->cChannel;

    /*Set the AP SSID. */
    memcpy(wifiAPConfig.au8SSID, pxNetworkParams->pcSSID, pxNetworkParams->ucSSIDLength);
	wifiAPConfig.au8SSID[ pxNetworkParams->ucSSIDLength ] = '\0';

    /*Set the AP security. */
    wifiAPConfig.u8KeyIndx = 1;
    wifiAPConfig.u8KeySz = pxNetworkParams->ucPasswordLength;

	if (eWiFiSecurityOpen == pxNetworkParams->xSecurity)
        {
            wifiAPConfig.u8SecType = M2M_WIFI_SEC_OPEN;
        }
	else if(eWiFiSecurityWEP == pxNetworkParams->xSecurity)
	{
	     wifiAPConfig.u8SecType = M2M_WIFI_SEC_WEP;
	     memcpy( wifiAPConfig.au8WepKey , pxNetworkParams->pcPassword, pxNetworkParams->ucPasswordLength);
		 wifiAPConfig.au8WepKey[ pxNetworkParams->ucPasswordLength ] = '\0';
	}
	else if((eWiFiSecurityWPA == pxNetworkParams->xSecurity)||
		(eWiFiSecurityWPA2 == pxNetworkParams->xSecurity))
	{
	     wifiAPConfig.u8SecType = M2M_WIFI_SEC_WPA_PSK;
	     //memcpy( wifiAPConfig.au8Key, pxNetworkParams->pcPassword, pxNetworkParams->ucPasswordLength);
		 //wifiAPConfig.au8Key[ pxNetworkParams->ucPasswordLength ] = '\0';
	}
	else
	{
		return eWiFiNotSupported;
	}

    /*Set the AP IP address. */
    memcpy(wifiAPConfig.au8DHCPServerIP, apIPAddress, IPV4_ADDRESS_LEN);
		
    return eWiFiSuccess;
}


/*-----------------------------------------------------------*/

/**
 * @brief start provisioning operation.
 *
 * @param[in] None
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_StartProvisioning( void )
{
    EventBits_t evBits;

     if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
     {
        if( m2m_wifi_start_provision_mode(&wifiAPConfig, gacHttpProvDomainName , 1) != M2M_SUCCESS )
        {
            /* Connection failed miserably. */
            xSemaphoreGive(xWiFiSemaphore);
            return eWiFiFailure;
        }
		
        xSemaphoreGive(xWiFiSemaphore);

        waiting_task = xTaskGetCurrentTaskHandle();

        /* Wait for Wi-Fi connection to complete. */
        xTaskNotifyWait( WDRV_MAC_EVENT_CONNECT_DONE, WDRV_MAC_EVENT_CONNECT_DONE, &evBits, WIFI_MAC_CONNECT_TIMEOUT );

        if( ( evBits & WDRV_MAC_EVENT_CONNECT_DONE ) == 0 )
        {
            /* Timed out. */
            return eWiFiTimeout;
        }
        
        
        return eWiFiSuccess;
     }
    else
        return eWiFiTimeout;
    

}

/*-----------------------------------------------------------*/

/**
 * @brief start SoftAP operation.
 *
 * @param[in] None
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_StartAP( void )
{
    EventBits_t evBits;
    
    configPRINTF(("WIFI_StartAP\r\n"));
    
    if ( g_device_mode != eWiFiModeAP )
        return eWiFiFailure;
    
    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {

       if (WDRV_WINC_STATUS_OK != WDRV_WINC_BSSCtxSetDefaults(&bssCtx))
       {
           return eWiFiFailure;
       }

       /* Update BSS context with target SSID for connection. */

       if (WDRV_WINC_STATUS_OK != WDRV_WINC_BSSCtxSetSSID(&bssCtx, (uint8_t*)wifiAPConfig.au8SSID, strlen(wifiAPConfig.au8SSID)))
       {
           return eWiFiFailure;
       }
       if (WDRV_WINC_STATUS_OK != WDRV_WINC_BSSCtxSetChannel(&bssCtx, 1))
       {
           return eWiFiFailure;
       }

       switch (wifiAPConfig.u8SecType)
       {
           case WDRV_WINC_AUTH_TYPE_OPEN:
           {
               if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetOpen(&authCtx))
               {
                   return eWiFiFailure;
               }
               break;
           }

           case WDRV_WINC_AUTH_TYPE_WEP: 
           {
               if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetWEP(&authCtx, 1, (uint8_t*)wifiAPConfig.au8WepKey, wifiAPConfig.u8KeySz))
               {
                   configPRINTF(("Set WEP fail, password len = %d\r\n ", wifiAPConfig.u8KeySz));
                   return eWiFiFailure;
               }
               configPRINTF( ( "Set WEP success\r\n " ) );
               break;
           }
           case WDRV_WINC_AUTH_TYPE_WPA_PSK:
           {
               /*
               if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetWPA(&authCtx, (uint8_t*)pxNetworkParams->pcPassword, pxNetworkParams->ucPasswordLength))
               {
                   return eWiFiFailure;
               }
                */
               return eWiFiNotSupported;
               break;
           }
           default:
               return eWiFiNotSupported;
               break;
       }
   
        WDRV_WINC_STATUS ret;
        ret = WDRV_WINC_APStart(wifi_handle, &bssCtx, &authCtx, NULL, &APP_ExampleConnectNotifyCallback);
        configPRINTF(("WIFI_StartAP, ret = %d\r\n", ret));
        
        xSemaphoreGive(xWiFiSemaphore);
        waiting_task = xTaskGetCurrentTaskHandle();
     
        if (ret == WDRV_WINC_STATUS_OK)
            return eWiFiSuccess;
        else
            return eWiFiFailure;
     }
    else
        return eWiFiTimeout;
  }

/*-----------------------------------------------------------*/

/**
 * @brief Stop SoftAP operation.
 *
 * @param[in] None
 *
 * @return eWiFiSuccess if disconnected, failure code otherwise.
 */
WIFIReturnCode_t WIFI_StopAP( void )
{
    uint8_t ret =0; 

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {   
	    ret = m2m_wifi_disable_ap();
    }
    else
        return eWiFiTimeout;
    
    xSemaphoreGive(xWiFiSemaphore);
	
    if (ret == M2M_SUCCESS)
	return eWiFiSuccess;
    else
	return eWiFiFailure;
}

/*-----------------------------------------------------------*/

/**
 * @brief Set power management mode
 *
 * @param[in] usPMModeType - Low power mode type.
 *
 * @param[in] pvOptionValue - A buffer containing the value of the option to set
 *                            depends on the mode type
 *				   WINC1500: This buffer should contain the listen interval in station mode.
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_SetPMMode( WIFIPMMode_t xPMModeType,
                                 const void * pvOptionValue )
{
    WIFIReturnCode_t ret = eWiFiSuccess;

    configREJECT( pvOptionValue != NULL );

   wifiPMModeType = xPMModeType;
   memcpy(&numBeaconIntervals, pvOptionValue, sizeof(numBeaconIntervals));
  
   
   if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
   {
        switch (wifiPMModeType)
        {
            case eWiFiPMLowPower:
            {           
                if (WDRV_WINC_STATUS_OK !=  WDRV_WINC_PowerSaveSetBeaconInterval(wifi_handle, 1))
                {
                    configPRINTF( ( "PS set beacon fail...\n" ) );
                    ret = eWiFiFailure;
                    break;
                }

                if (WDRV_WINC_STATUS_OK != WDRV_WINC_PowerSaveSetMode(wifi_handle, WDRV_WINC_PS_MODE_AUTO_LOW_POWER ))
                {
                    configPRINTF( ( "PS configure fail...\n" ) );
                    ret = eWiFiFailure;
                    break;
                }
                
                ret = eWiFiSuccess;
                break;
            }
            case eWiFiPMNormal:
            {
               if (WDRV_WINC_STATUS_OK != WDRV_WINC_PowerSaveSetMode(wifi_handle, WDRV_WINC_PS_MODE_OFF ))
                {
                    configPRINTF( ( "PS configure fail...\n" ) );
                    ret = eWiFiFailure;
                    break;
                }
                ret = eWiFiSuccess;
                break;
            }
            default:
            {
                ret = eWiFiNotSupported;
                break;
            }
        }
    }
    else
        return eWiFiTimeout;
    
    xSemaphoreGive(xWiFiSemaphore);
       
    return ret;
}

/*-----------------------------------------------------------*/

/**
 * @brief Get power management mode
 *
 * @param[out] xPMModeType - pointer to get current power mode set.
 *
 * @param[out] pvOptionValue - optional value
 *
 * @return eWiFiSuccess if everything succeeds, failure code otherwise.
 */
WIFIReturnCode_t WIFI_GetPMMode( WIFIPMMode_t * pxPMModeType,
                                 void * pvOptionValue )
{
    configREJECT( pxPMModeType != NULL );
    configREJECT( pvOptionValue != NULL );
    
    *pxPMModeType = wifiPMModeType;
    memcpy(pvOptionValue, &numBeaconIntervals, sizeof(numBeaconIntervals));
    return eWiFiSuccess;
}

/*-----------------------------------------------------------*/

/**
 * @brief Retrieves the Wi-Fi interface's MAC address.
 *
 * @param[out] MAC Address buffer.
 *
 * @return eWiFiSuccess if disconnected, eWiFiFailure otherwise.
 */
WIFIReturnCode_t WIFI_GetMAC( uint8_t * pucMac )
{
    WIFIReturnCode_t xReturnStatus = eWiFiFailure;

    configREJECT( pucMac != NULL );

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {   
        if (WDRV_WINC_InfoDeviceMACAddressGet(wifi_handle, false, pucMac) == WDRV_WINC_STATUS_OK)
        {    
	        xReturnStatus = eWiFiSuccess;
	    }
    }
    else
        return eWiFiTimeout;
    
    xSemaphoreGive(xWiFiSemaphore);
	
    return xReturnStatus;
}


/*-----------------------------------------------------------*/

/**
 * @brief Ping an IP address in the network.
 *
 * @param[in] IP Address to ping.
 * @param[in] Number of times to ping
 * @param[in] Interval in mili seconds for ping operation
 *
 * @return eWiFiSuccess if disconnected, failure code otherwise.
 */
WIFIReturnCode_t WIFI_Ping( uint8_t * pucIPAddr,
                            uint16_t usCount,
                            uint32_t ulIntervalMS )
{
    EventBits_t evBits;

    if( ( NULL == pucIPAddr ) || ( 0 == usCount ) )
    {
        return eWiFiFailure;
    }

    if( xSemaphoreTake( xWiFiSemaphore, xSemaphoreWaitTicks ) == pdTRUE )
    {   
        pingCount = usCount;
        
        
        uint32_t ipAddr = pucIPAddr[3]<<24 | pucIPAddr[2]<<16 | pucIPAddr[1]<<8 | pucIPAddr[0];
        
        for (int i = 0; i < usCount; i++)
        {
            
            if (WDRV_WINC_STATUS_OK != WDRV_WINC_ICMPEchoRequest(wifi_handle, ipAddr, 0, pingCb))
            {
                configPRINTF( ( "WDRV_WINC_ICMPEchoRequest fail...\r\n" ) );
                xSemaphoreGive(xWiFiSemaphore);
                return eWiFiFailure;
            }
            waiting_task = xTaskGetCurrentTaskHandle();
           /* Wait for resolve DNS to complete. */
            xTaskNotifyWait( WDRV_MAC_EVENT_PING_DONE, WDRV_MAC_EVENT_PING_DONE, &evBits, WIFI_MAC_PING_TIMEOUT );

            if( ( evBits & WDRV_MAC_EVENT_PING_DONE ) == 0 )
            {
                /* Timed out. */
                configPRINTF( ( "PING timeout\r\n" ) );
                xSemaphoreGive(xWiFiSemaphore);
                return eWiFiTimeout;
            }
            vTaskDelay( pdMS_TO_TICKS( ulIntervalMS ));
        }
		
    }
    else
        return eWiFiTimeout;
    
    xSemaphoreGive(xWiFiSemaphore);

		
    return eWiFiSuccess;
}

/**
 * @brief Check if the Wi-Fi is connected.
 *
 * @return pdTRUE if the link is up, pdFalse otherwise.
 */
BaseType_t WIFI_IsConnected( void )
{
    BaseType_t xIsConnected = pdFALSE;

    if( wifiConnected )
    {
        xIsConnected = pdTRUE;
    }

    return xIsConnected;
}

static void APP_ExampleDHCPAddressEventCallback(DRV_HANDLE handle, uint32_t ipAddress)
{
    char s[20];
    
    memcpy(wifiIPv4Address, &ipAddress, sizeof(wifiIPv4Address));
    configPRINTF(("IP address is %s\r\n", inet_ntop(AF_INET, &ipAddress, s, sizeof(s))));
    
    AWS_MCHP_ConnectEvent();
    if (g_network_change_cb != NULL)
        g_network_change_cb(AWSIOT_NETWORK_TYPE_WIFI, eNetworkStateEnabled);
}
 


 void eccProcessREQ(tstrEccReqInfo *ecc_request)
{
	tstrEccReqInfo ecc_response;
	uint8_t signature[80];
	uint16_t response_data_size = 0;
	uint8_t *response_data_buffer = NULL;
	
	ecc_response.u16Status = 1;

	switch (ecc_request->u16REQ)
	{
		case ECC_REQ_CLIENT_ECDH:
		ecc_response.u16Status = ecdh_derive_client_shared_secret(&(ecc_request->strEcdhREQ.strPubKey),
		ecc_response.strEcdhREQ.au8Key,
		&ecc_response.strEcdhREQ.strPubKey);
		break;

		case ECC_REQ_GEN_KEY:
		ecc_response.u16Status = ecdh_derive_key_pair(&ecc_response.strEcdhREQ.strPubKey);
		break;

		case ECC_REQ_SERVER_ECDH:
		ecc_response.u16Status = ecdh_derive_server_shared_secret(ecc_request->strEcdhREQ.strPubKey.u16PrivKeyID,
		&(ecc_request->strEcdhREQ.strPubKey),
		ecc_response.strEcdhREQ.au8Key);
		break;
		
		case ECC_REQ_SIGN_VERIFY:
		ecc_response.u16Status = ecdsa_process_sign_verify_request(ecc_request->strEcdsaVerifyREQ.u32nSig);
		break;
		
		case ECC_REQ_SIGN_GEN:
		ecc_response.u16Status = ecdsa_process_sign_gen_request(&(ecc_request->strEcdsaSignREQ), signature,
		&response_data_size);
		response_data_buffer = signature;
		break;
		
		default:
		// Do nothing
		break;
	}
	
	ecc_response.u16REQ      = ecc_request->u16REQ;
	ecc_response.u32UserData = ecc_request->u32UserData;
	ecc_response.u32SeqNo    = ecc_request->u32SeqNo;

	m2m_ssl_ecc_process_done();
	m2m_ssl_handshake_rsp(&ecc_response, response_data_buffer, response_data_size);
}

 static void APP_ExampleConnectNotifyCallback(DRV_HANDLE handle, WDRV_WINC_CONN_STATE currentState, WDRV_WINC_CONN_ERROR errorCode)
{
    if (WDRV_WINC_CONN_STATE_CONNECTED == currentState)
    {
        configPRINTF(("[%s] AP Connected\r\n", __func__));
        
       
    }
    else if (WDRV_WINC_CONN_STATE_DISCONNECTED == currentState)
    {
        configPRINTF(("[%s] AP Disconnect\r\n", __func__));
        AWS_MCHP_DisconnectEvent();
        if (g_network_change_cb != NULL)
            g_network_change_cb(AWSIOT_NETWORK_TYPE_WIFI, eNetworkStateDisabled);

    }
}
 
 WIFIReturnCode_t Wifi_Connect_Ex(DRV_HANDLE handle, const WIFINetworkParams_t * const pxNetworkParams)
{
     uint8_t dev_id[32];
     
    extern ATCAIfaceCfg atecc608a_0_init_data;
    /* Enable use of DHCP for network configuration, DHCP is the default
     but this also registers the callback for notifications. */
    WDRV_WINC_IPUseDHCPSet(handle, &APP_ExampleDHCPAddressEventCallback);
    WDRV_WINC_SocketRegisterResolverCallback(handle, &dns_resolve_cb);
    /* Preset the error state incase any following operations fail. */


    do
    {
    /* Initialize the BSS context to use default values. */

    if (WDRV_WINC_STATUS_OK != WDRV_WINC_BSSCtxSetDefaults(&bssCtx))
    {
        return eWiFiFailure;
    }

    /* Update BSS context with target SSID for connection. */

    if (WDRV_WINC_STATUS_OK != WDRV_WINC_BSSCtxSetSSID(&bssCtx, (uint8_t*)pxNetworkParams->pcSSID, strlen(pxNetworkParams->pcSSID)))
    {
        return eWiFiFailure;
    }

    switch (pxNetworkParams->xSecurity)
    {
        case eWiFiSecurityOpen:
        {
            if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetOpen(&authCtx))
            {
                return eWiFiFailure;
            }
            break;
        }

        case eWiFiSecurityWEP: 
        {
            if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetWEP(&authCtx, 1, (uint8_t*)pxNetworkParams->pcPassword, strlen(pxNetworkParams->pcPassword)))
            {
                configPRINTF(("Set WEP fail, password len = %d\r\n ", strlen(pxNetworkParams->pcPassword)));
                return eWiFiFailure;
            }
            break;
        }
        case eWiFiSecurityWPA:
        case eWiFiSecurityWPA2:
        {
            if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetWPA(&authCtx, (uint8_t*)pxNetworkParams->pcPassword, strlen(pxNetworkParams->pcPassword)))
            {
                return eWiFiFailure;
            }
            break;
        }
        case eWiFiSecurityNotSupported:
            break;
    }
#if 0            
#if defined(WLAN_AUTH_OPEN)
            /* Initialize the authentication context for open mode. */

            if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetOpen(&authCtx))
            {
                return ;
            }
#elif defined(WLAN_AUTH_WPA_PSK)
            /* Initialize the authentication context for WPA. */

            if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetWPA(&authCtx, (uint8_t*)pxNetworkParams->pcPassword, pxNetworkParams->ucPasswordLength))
            {
                return eWiFiFailure;
            }
#else
            if (WDRV_WINC_STATUS_OK != WDRV_WINC_AuthCtxSetWEP(&authCtx, WLAN_WEP_KEY_INDEX, (uint8_t*)WLAN_WEP_KEY_40, strlen(WLAN_WEP_KEY_40)))
            {
                return eWiFiFailure;
            }
#endif
#endif
            /* Connect to the target BSS with the chosen authentication. */
           if(WDRV_WINC_STATUS_OK == WDRV_WINC_BSSConnect(handle, &bssCtx, &authCtx, &APP_ExampleConnectNotifyCallback))
            {
               return eWiFiSuccess;
               
            }
 }while(1);
            return eWiFiFailure;

}
 
size_t winc_certs_get_total_files_size(const tstrTlsSrvSecHdr* header)
{
    uint8_t *pBuffer = (uint8_t*) header;
    uint16_t count = 0;

    while ((*pBuffer) == 0xFF)
    {
        
        if(count == INIT_CERT_BUFFER_LEN)
        break;
        count++;
        pBuffer++;
    }

    if(count == INIT_CERT_BUFFER_LEN)
    return sizeof(*header); // Buffer is empty, no files
    
    return header->u32NextWriteAddr;
}
 
 int8_t winc_certs_append_file_buf(uint32_t* buffer32, uint32_t buffer_size, 
                                        const char* file_name, uint32_t file_size, 
                                        const uint8_t* file_data)
{
    tstrTlsSrvSecHdr* header = (tstrTlsSrvSecHdr*)buffer32;
    tstrTlsSrvSecFileEntry* file_entry = NULL;
    uint16_t str_size = (uint8_t)strlen((char*)file_name) + 1;
    uint16_t count = 0;
    uint8_t *pBuffer = (uint8_t*)buffer32;

    while ((*pBuffer) == 0xFF)
    {
        
        if(count == INIT_CERT_BUFFER_LEN)
        break;
        count++;
        pBuffer++;
    }

    if(count == INIT_CERT_BUFFER_LEN)
    {
        // The WINC will need to add the reference start pattern to the header
        header->u32nEntries = 0; // No certs
        // The WINC will need to add the offset of the flash were the certificates are stored to this address
        header->u32NextWriteAddr = sizeof(*header); // Next cert will be written after the header
    }
    
    if (header->u32nEntries >= sizeof(header->astrEntries)/sizeof(header->astrEntries[0]))
    return M2M_ERR_FAIL; // Already at max number of files
    
    if ((header->u32NextWriteAddr + file_size) > buffer_size)
    return M2M_ERR_FAIL; // Not enough space in buffer for new file
    
    file_entry = &header->astrEntries[header->u32nEntries];
    header->u32nEntries++;
    
    if (str_size > sizeof(file_entry->acFileName))
    return M2M_ERR_FAIL; // File name too long
    memcpy((uint8_t*)file_entry->acFileName, (uint8_t*)file_name, str_size);
    
    file_entry->u32FileSize = file_size;
    file_entry->u32FileAddr = header->u32NextWriteAddr;
    header->u32NextWriteAddr += file_size;
    
    // Use memmove to accommodate optimizations where the file data is temporarily stored
    // in buffer32
    memmove(((uint8_t*)buffer32) + (file_entry->u32FileAddr), (uint8_t*)file_data, file_size);
    
    return M2M_SUCCESS;
}
 
 static char* ts_bin2hex(const unsigned char *old, const size_t oldlen)
{
    char *result = (char*) pvPortMalloc(oldlen * 2 + 1);
    size_t i, j;
    int b = 0;

    for (i = j = 0; i < oldlen; i++) {
        b = old[i] >> 4;
        result[j++] = (char) (87 + b + (((b - 10) >> 31) & -39));
        b = old[i] & 0xf;
        result[j++] = (char) (87 + b + (((b - 10) >> 31) & -39));
    }
    result[j] = '\0';
    return result;

}

static uint32_t sectior_buffer_winc[MAX_TLS_CERT_LENGTH];
static	uint8_t signer_public_key[SIGNER_PUBLIC_KEY_MAX_LEN];
static	uint8_t cert_sn[CERT_SN_MAX_LEN];
static	char pem_cert[1024];
static int bECCInstance=0;



uint32_t *get_winc_buffer()
{
    if(!bECCInstance) return NULL;
    return sectior_buffer_winc;
}
    
 int8_t ecc_transfer_certificates(uint8_t *subject_key_id)
{
	int atca_status = ATCACERT_E_SUCCESS;
	uint8_t *signer_cert = NULL;
	size_t signer_cert_size;
	uint8_t *device_cert = NULL;
	size_t device_cert_size;
	size_t cert_sn_size;
	uint8_t *file_list = NULL;
	char *device_cert_filename = NULL;
	char *signer_cert_filename = NULL;
	size_t pem_cert_size;

    if(bECCInstance) return ATCACERT_E_ERROR;
    bECCInstance = !bECCInstance;
    
    do 
    {
	    // Clear cert chain buffer
	    memset(sectior_buffer_winc, 0xFF, sizeof(sectior_buffer_winc));

	    // Use the end of the sector buffer to temporarily hold the data to save RAM
	    file_list   = ((uint8_t*)sectior_buffer_winc) + (sizeof(sectior_buffer_winc) - TLS_FILE_NAME_MAX*2);
	    signer_cert = file_list - SIGNER_CERT_MAX_LEN;
	    device_cert = signer_cert - DEVICE_CERT_MAX_LEN;

	    // Init the file list
	    memset(file_list, 0, TLS_FILE_NAME_MAX*2);
	    device_cert_filename = (char*)&file_list[0];
	    signer_cert_filename = (char*)&file_list[TLS_FILE_NAME_MAX];

	    // Uncompress the signer certificate from the ATECCx08A device
        signer_cert_size = SIGNER_CERT_MAX_LEN;
	    atca_status = atcacert_read_cert(&g_cert_def_1_signer, g_cert_ca_public_key_1_signer, 
			signer_cert, &signer_cert_size);
	    if (atca_status != ATCACERT_E_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
		pem_cert_size = sizeof(pem_cert);
		atcacert_encode_pem_cert(signer_cert, signer_cert_size, pem_cert, &pem_cert_size);
		configPRINTF(("Signer Cert : \r\n%s\r\n", pem_cert));

	    // Get the signer's public key from its certificate
	    atca_status = atcacert_get_subj_public_key(&g_cert_def_1_signer, signer_cert, 
			signer_cert_size, signer_public_key);
	    if (atca_status != ATCACERT_E_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
	
	    // Uncompress the device certificate from the ATECCx08A device.
	    device_cert_size = DEVICE_CERT_MAX_LEN;
	    atca_status = atcacert_read_cert(&g_cert_def_2_device, signer_public_key, 
			device_cert, &device_cert_size);
	    if (atca_status != ATCACERT_E_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
		pem_cert_size = sizeof(pem_cert);
		atcacert_encode_pem_cert(device_cert, device_cert_size, pem_cert, &pem_cert_size);
		configPRINTF(("Device Cert : \r\n%s\r\n", pem_cert));

        if (subject_key_id)
        {
            atca_status = atcacert_get_subj_key_id(&g_cert_def_2_device, device_cert, 
				device_cert_size, subject_key_id); 
            if (atca_status != ATCACERT_E_SUCCESS)
            {
                // Break the do/while loop
                break;
            }
        }
	
	    // Get the device certificate SN for the filename
	    cert_sn_size = sizeof(cert_sn);
	    atca_status = atcacert_get_cert_sn(&g_cert_def_2_device, device_cert, 
			device_cert_size, cert_sn, &cert_sn_size);
	    if (atca_status != ATCACERT_E_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
	
	    // Build the device certificate filename
	    strcpy(device_cert_filename, "CERT_");
	    strcat(device_cert_filename, ts_bin2hex(cert_sn, cert_sn_size));

	    // Add the DER device certificate the TLS certs buffer
	    atca_status = winc_certs_append_file_buf(sectior_buffer_winc, sizeof(sectior_buffer_winc), 
			device_cert_filename, device_cert_size, device_cert);
	    if (atca_status != M2M_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
	
	    device_cert = NULL; // Make sure we don't use this now that it has moved
	
	    // Get the signer certificate SN for the filename
	    cert_sn_size = sizeof(cert_sn);
	    atca_status = atcacert_get_cert_sn(&g_cert_def_1_signer, signer_cert, 
			signer_cert_size, cert_sn, &cert_sn_size);
	    if (atca_status != ATCACERT_E_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
        
	
	    // Build the signer certificate filename
	    strcpy(signer_cert_filename, "CERT_");
	    strcat(signer_cert_filename, ts_bin2hex(cert_sn, cert_sn_size));
	    // Add the DER signer certificate the TLS certs buffer
	    atca_status = winc_certs_append_file_buf(sectior_buffer_winc, sizeof(sectior_buffer_winc), 
			signer_cert_filename, signer_cert_size, signer_cert);
	    if (atca_status != M2M_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
	
	    // Add the cert chain list file to the TLS certs buffer
	    atca_status = winc_certs_append_file_buf(sectior_buffer_winc, sizeof(sectior_buffer_winc), 
			TLS_SRV_ECDSA_CHAIN_FILE, TLS_FILE_NAME_MAX*2, file_list);
	    if (atca_status != M2M_SUCCESS)
        {
            // Break the do/while loop
            break;
        }        

	    file_list = NULL;
	    signer_cert_filename = NULL;
	    device_cert_filename = NULL;

#if 0
	    // Update the TLS cert chain on the WINC.
	    atca_status = m2m_ssl_send_certs_to_winc((uint8_t *)sectior_buffer_winc,
			(uint32_t)winc_certs_get_total_files_size((tstrTlsSrvSecHdr*)sectior_buffer_winc));
        if (atca_status != M2M_SUCCESS)
        {
            // Break the do/while loop
            break;
        }
#endif        
    } while (false);

	if (atca_status)
	{
    	M2M_ERR("eccSendCertsToWINC() failed with ret=%d", atca_status);
    	atca_status =  M2M_ERR_FAIL;
	}
	return atca_status;
}