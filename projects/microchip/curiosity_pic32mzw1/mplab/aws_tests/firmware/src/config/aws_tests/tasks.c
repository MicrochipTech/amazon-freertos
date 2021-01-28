/*******************************************************************************
 System Tasks File

  File Name:
    tasks.c

  Summary:
    This file contains source code necessary to maintain system's polled tasks.

  Description:
    This file contains source code necessary to maintain system's polled tasks.
    It implements the "SYS_Tasks" function that calls the individual "Tasks"
    functions for all polled MPLAB Harmony modules in the system.

  Remarks:
    This file requires access to the systemObjects global data structure that
    contains the object handles to all MPLAB Harmony module objects executing
    polled in the system.  These handles are passed into the individual module
    "Tasks" functions to identify the instance of the module to maintain.
 *******************************************************************************/

// DOM-IGNORE-BEGIN
/*******************************************************************************
* Copyright (C) 2018 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 *******************************************************************************/
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "configuration.h"
#include "definitions.h"




// *****************************************************************************
// *****************************************************************************
// Section: System "Tasks" Routine
// *****************************************************************************
// *****************************************************************************

void _SYS_CMD_Tasks(  void *pvParameters  )
{
    while(1)
    {
        SYS_CMD_Tasks();
        vTaskDelay(10 / portTICK_PERIOD_MS);
    }
}

/* Handle for the APP_Tasks. */
TaskHandle_t xAPP_Tasks;

void _APP_Tasks(  void *pvParameters  )
{
    while(1)
    {
        APP_Tasks();
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
}

static void _WDRV_PIC32MZW1_Tasks(  void *pvParameters  )
{
    printf("log31\r\n");
    while(1)
    {
        WDRV_PIC32MZW_Tasks(sysObj.drvWifiPIC32MZW1);
        vTaskDelay(1 / portTICK_PERIOD_MS);
    }
}

void _DRV_BA414E_Tasks(  void *pvParameters  )
{
    while(1)
    {
        DRV_BA414E_Tasks(sysObj.ba414e);
    }
}
/*******************************************************************************
  Function:
    void SYS_Tasks ( void )

  Remarks:
    See prototype in system/common/sys_module.h.
*/
void SYS_Tasks ( void )
{
    /* Maintain system services */
#if 1
    //SYS_CMD_Tasks();
    xTaskCreate( _SYS_CMD_Tasks,
        "SYS_CMD_TASKS",
        SYS_CMD_RTOS_STACK_SIZE,
        (void*)NULL,
        SYS_CMD_RTOS_TASK_PRIORITY,
        (TaskHandle_t*)NULL
    );
#endif
    


    /* Maintain Device Drivers */
    //WDRV_PIC32MZW_Tasks(sysObj.drvWifiPIC32MZW1);

    


    /* Maintain Middleware & Other Libraries */
    
    //DRV_BA414E_Tasks(sysObj.ba414e);
    
    /* Maintain Device Drivers */
    xTaskCreate( _WDRV_PIC32MZW1_Tasks,
        "WDRV_PIC32MZW1_Tasks",
        1024,
            //2560,
        (void*)NULL,
        1,
        (TaskHandle_t*)NULL
    );


#if 1
    /* Maintain Middleware & Other Libraries */
    
    xTaskCreate( _DRV_BA414E_Tasks,
        "DRV_BA414E_Tasks",
        DRV_BA414E_RTOS_STACK_SIZE,
        (void*)NULL,
        DRV_BA414E_RTOS_TASK_PRIORITY,
        (TaskHandle_t*)NULL
    );



    /* Maintain the application's state machine. */
        /* Call Application task APP. */
    //APP_Tasks();
    /* Create OS Thread for APP_Tasks. */
    xTaskCreate((TaskFunction_t) _APP_Tasks,
                "APP_Tasks",
                1024,
                NULL,
                1,
                &xAPP_Tasks);
#endif


}

/*******************************************************************************
 End of File
 */

