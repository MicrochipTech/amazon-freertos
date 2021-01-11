#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-same54_xpro.mk)" "nbproject/Makefile-local-same54_xpro.mk"
include nbproject/Makefile-local-same54_xpro.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=same54_xpro
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/asn1utility.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/aws_boot_crypto.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_flash.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_nvm.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_partition.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_loader.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_pal.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/source/app.c ../src/config/same54_xpro/bsp/bsp.c ../src/config/same54_xpro/peripheral/clock/plib_clock.c ../src/config/same54_xpro/peripheral/cmcc/plib_cmcc.c ../src/config/same54_xpro/peripheral/evsys/plib_evsys.c ../src/config/same54_xpro/peripheral/nvic/plib_nvic.c ../src/config/same54_xpro/peripheral/nvmctrl/plib_nvmctrl.c ../src/config/same54_xpro/peripheral/port/plib_port.c ../src/config/same54_xpro/peripheral/sercom/usart/plib_sercom2_usart.c ../src/config/same54_xpro/peripheral/wdt/plib_wdt.c ../src/config/same54_xpro/stdio/xc32_monitor.c ../src/config/same54_xpro/initialization.c ../src/config/same54_xpro/interrupts.c ../src/config/same54_xpro/exceptions.c ../src/config/same54_xpro/startup_xc32.c ../src/config/same54_xpro/libc_syscalls.c ../../../../../../../libraries/3rdparty/tinycrypt/asn1/asn1parse.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_decrypt.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_encrypt.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cbc_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ccm_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cmac_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_prng.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dh.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dsa.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_platform_specific.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac_prng.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/sha256.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/utils.c ../src/main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/2097892688/asn1utility.o ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o ${OBJECTDIR}/_ext/619668485/app.o ${OBJECTDIR}/_ext/288800588/bsp.o ${OBJECTDIR}/_ext/425478706/plib_clock.o ${OBJECTDIR}/_ext/13724534/plib_cmcc.o ${OBJECTDIR}/_ext/423329220/plib_evsys.o ${OBJECTDIR}/_ext/13387998/plib_nvic.o ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o ${OBJECTDIR}/_ext/13334847/plib_port.o ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o ${OBJECTDIR}/_ext/970255097/plib_wdt.o ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o ${OBJECTDIR}/_ext/1510338148/initialization.o ${OBJECTDIR}/_ext/1510338148/interrupts.o ${OBJECTDIR}/_ext/1510338148/exceptions.o ${OBJECTDIR}/_ext/1510338148/startup_xc32.o ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o ${OBJECTDIR}/_ext/1214204543/asn1parse.o ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o ${OBJECTDIR}/_ext/1193839791/cbc_mode.o ${OBJECTDIR}/_ext/1193839791/ccm_mode.o ${OBJECTDIR}/_ext/1193839791/cmac_mode.o ${OBJECTDIR}/_ext/1193839791/ctr_mode.o ${OBJECTDIR}/_ext/1193839791/ctr_prng.o ${OBJECTDIR}/_ext/1193839791/ecc.o ${OBJECTDIR}/_ext/1193839791/ecc_dh.o ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o ${OBJECTDIR}/_ext/1193839791/hmac.o ${OBJECTDIR}/_ext/1193839791/hmac_prng.o ${OBJECTDIR}/_ext/1193839791/sha256.o ${OBJECTDIR}/_ext/1193839791/utils.o ${OBJECTDIR}/_ext/1360937237/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/2097892688/asn1utility.o.d ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o.d ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o.d ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o.d ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o.d ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o.d ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o.d ${OBJECTDIR}/_ext/619668485/app.o.d ${OBJECTDIR}/_ext/288800588/bsp.o.d ${OBJECTDIR}/_ext/425478706/plib_clock.o.d ${OBJECTDIR}/_ext/13724534/plib_cmcc.o.d ${OBJECTDIR}/_ext/423329220/plib_evsys.o.d ${OBJECTDIR}/_ext/13387998/plib_nvic.o.d ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o.d ${OBJECTDIR}/_ext/13334847/plib_port.o.d ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o.d ${OBJECTDIR}/_ext/970255097/plib_wdt.o.d ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o.d ${OBJECTDIR}/_ext/1510338148/initialization.o.d ${OBJECTDIR}/_ext/1510338148/interrupts.o.d ${OBJECTDIR}/_ext/1510338148/exceptions.o.d ${OBJECTDIR}/_ext/1510338148/startup_xc32.o.d ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o.d ${OBJECTDIR}/_ext/1214204543/asn1parse.o.d ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o.d ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o.d ${OBJECTDIR}/_ext/1193839791/cbc_mode.o.d ${OBJECTDIR}/_ext/1193839791/ccm_mode.o.d ${OBJECTDIR}/_ext/1193839791/cmac_mode.o.d ${OBJECTDIR}/_ext/1193839791/ctr_mode.o.d ${OBJECTDIR}/_ext/1193839791/ctr_prng.o.d ${OBJECTDIR}/_ext/1193839791/ecc.o.d ${OBJECTDIR}/_ext/1193839791/ecc_dh.o.d ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o.d ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o.d ${OBJECTDIR}/_ext/1193839791/hmac.o.d ${OBJECTDIR}/_ext/1193839791/hmac_prng.o.d ${OBJECTDIR}/_ext/1193839791/sha256.o.d ${OBJECTDIR}/_ext/1193839791/utils.o.d ${OBJECTDIR}/_ext/1360937237/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/2097892688/asn1utility.o ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o ${OBJECTDIR}/_ext/619668485/app.o ${OBJECTDIR}/_ext/288800588/bsp.o ${OBJECTDIR}/_ext/425478706/plib_clock.o ${OBJECTDIR}/_ext/13724534/plib_cmcc.o ${OBJECTDIR}/_ext/423329220/plib_evsys.o ${OBJECTDIR}/_ext/13387998/plib_nvic.o ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o ${OBJECTDIR}/_ext/13334847/plib_port.o ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o ${OBJECTDIR}/_ext/970255097/plib_wdt.o ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o ${OBJECTDIR}/_ext/1510338148/initialization.o ${OBJECTDIR}/_ext/1510338148/interrupts.o ${OBJECTDIR}/_ext/1510338148/exceptions.o ${OBJECTDIR}/_ext/1510338148/startup_xc32.o ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o ${OBJECTDIR}/_ext/1214204543/asn1parse.o ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o ${OBJECTDIR}/_ext/1193839791/cbc_mode.o ${OBJECTDIR}/_ext/1193839791/ccm_mode.o ${OBJECTDIR}/_ext/1193839791/cmac_mode.o ${OBJECTDIR}/_ext/1193839791/ctr_mode.o ${OBJECTDIR}/_ext/1193839791/ctr_prng.o ${OBJECTDIR}/_ext/1193839791/ecc.o ${OBJECTDIR}/_ext/1193839791/ecc_dh.o ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o ${OBJECTDIR}/_ext/1193839791/hmac.o ${OBJECTDIR}/_ext/1193839791/hmac_prng.o ${OBJECTDIR}/_ext/1193839791/sha256.o ${OBJECTDIR}/_ext/1193839791/utils.o ${OBJECTDIR}/_ext/1360937237/main.o

# Source Files
SOURCEFILES=../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/asn1utility.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/aws_boot_crypto.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_flash.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_nvm.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_partition.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_loader.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_pal.c ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/source/app.c ../src/config/same54_xpro/bsp/bsp.c ../src/config/same54_xpro/peripheral/clock/plib_clock.c ../src/config/same54_xpro/peripheral/cmcc/plib_cmcc.c ../src/config/same54_xpro/peripheral/evsys/plib_evsys.c ../src/config/same54_xpro/peripheral/nvic/plib_nvic.c ../src/config/same54_xpro/peripheral/nvmctrl/plib_nvmctrl.c ../src/config/same54_xpro/peripheral/port/plib_port.c ../src/config/same54_xpro/peripheral/sercom/usart/plib_sercom2_usart.c ../src/config/same54_xpro/peripheral/wdt/plib_wdt.c ../src/config/same54_xpro/stdio/xc32_monitor.c ../src/config/same54_xpro/initialization.c ../src/config/same54_xpro/interrupts.c ../src/config/same54_xpro/exceptions.c ../src/config/same54_xpro/startup_xc32.c ../src/config/same54_xpro/libc_syscalls.c ../../../../../../../libraries/3rdparty/tinycrypt/asn1/asn1parse.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_decrypt.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_encrypt.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cbc_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ccm_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cmac_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_mode.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_prng.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dh.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dsa.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_platform_specific.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac_prng.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/sha256.c ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/utils.c ../src/main.c

# Pack Options 
PACK_COMMON_OPTIONS=-I "${CMSIS_DIR}/CMSIS/Core/Include"



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

# The following macros may be used in the pre and post step lines
Device=ATSAME54P20A
ProjectDir="D:\AWSTEST\amazon-freertos\projects\microchip\same54_xpro\mplab\bootloader\firmware\bootloader.X"
ProjectName=bootloader
ConfName=same54_xpro
ImagePath="dist\same54_xpro\${IMAGE_TYPE}\bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ImageDir="dist\same54_xpro\${IMAGE_TYPE}"
ImageName="bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}"
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IsDebug="true"
else
IsDebug="false"
endif

.build-conf:  .pre ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-same54_xpro.mk dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
	@echo "--------------------------------------"
	@echo "User defined post-build step: [cp "${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.hex" ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/utility]"
	@cp "${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.hex" ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/utility
	@echo "--------------------------------------"

MP_PROCESSOR_OPTION=ATSAME54P20A
MP_LINKER_FILE_OPTION=,--script="..\src\config\same54_xpro\ATSAME54P20A.ld"
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/2097892688/asn1utility.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/asn1utility.c  .generated_files/bea58f0cf568568b2fbdc81d4d03cdbd87cb5edf.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/2097892688" 
	@${RM} ${OBJECTDIR}/_ext/2097892688/asn1utility.o.d 
	@${RM} ${OBJECTDIR}/_ext/2097892688/asn1utility.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/2097892688/asn1utility.o.d" -o ${OBJECTDIR}/_ext/2097892688/asn1utility.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/asn1utility.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/aws_boot_crypto.c  .generated_files/5f2c12f196172e696f28539965e3b412a5c407ea.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/2097892688" 
	@${RM} ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o.d 
	@${RM} ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o.d" -o ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/aws_boot_crypto.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/93820448/aws_boot_flash.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_flash.c  .generated_files/8c1ba99e8dced3982ad78df0a95707dadaddd8f4.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/93820448" 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/93820448/aws_boot_flash.o.d" -o ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_flash.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_nvm.c  .generated_files/e9a8da34e3b797a7d93bc4896348c9630c7fd561.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/93820448" 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o.d 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o.d" -o ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_nvm.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/93820448/aws_boot_partition.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_partition.c  .generated_files/1266469b660469177ee28f4c4b238673298894bc.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/93820448" 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o.d 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/93820448/aws_boot_partition.o.d" -o ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_partition.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_loader.c  .generated_files/42905ef89181fa8b0162b9f06fb34f1c0d54de83.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1561064483" 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o.d 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o.d" -o ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_loader.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_pal.c  .generated_files/f397bc5625961f68a75c8c40904f3a02c7894446.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1561064483" 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o.d 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o.d" -o ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_pal.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/619668485/app.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/source/app.c  .generated_files/46370f1035dc6f74488f589093b4b11dc699200a.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/619668485" 
	@${RM} ${OBJECTDIR}/_ext/619668485/app.o.d 
	@${RM} ${OBJECTDIR}/_ext/619668485/app.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/619668485/app.o.d" -o ${OBJECTDIR}/_ext/619668485/app.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/source/app.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/288800588/bsp.o: ../src/config/same54_xpro/bsp/bsp.c  .generated_files/c2bb0fd617efea86daaaa60b54b8be3b032f8d2d.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/288800588" 
	@${RM} ${OBJECTDIR}/_ext/288800588/bsp.o.d 
	@${RM} ${OBJECTDIR}/_ext/288800588/bsp.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/288800588/bsp.o.d" -o ${OBJECTDIR}/_ext/288800588/bsp.o ../src/config/same54_xpro/bsp/bsp.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/425478706/plib_clock.o: ../src/config/same54_xpro/peripheral/clock/plib_clock.c  .generated_files/beca032d59c04b35fb799569b43b2754d233e8d5.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/425478706" 
	@${RM} ${OBJECTDIR}/_ext/425478706/plib_clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/425478706/plib_clock.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/425478706/plib_clock.o.d" -o ${OBJECTDIR}/_ext/425478706/plib_clock.o ../src/config/same54_xpro/peripheral/clock/plib_clock.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/13724534/plib_cmcc.o: ../src/config/same54_xpro/peripheral/cmcc/plib_cmcc.c  .generated_files/7fe2c9ff38f3a4613caccc81fb7deb575679f38d.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/13724534" 
	@${RM} ${OBJECTDIR}/_ext/13724534/plib_cmcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/13724534/plib_cmcc.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/13724534/plib_cmcc.o.d" -o ${OBJECTDIR}/_ext/13724534/plib_cmcc.o ../src/config/same54_xpro/peripheral/cmcc/plib_cmcc.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/423329220/plib_evsys.o: ../src/config/same54_xpro/peripheral/evsys/plib_evsys.c  .generated_files/a556cf74e6bf1a74a584c7c932fb70cf53120aa.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/423329220" 
	@${RM} ${OBJECTDIR}/_ext/423329220/plib_evsys.o.d 
	@${RM} ${OBJECTDIR}/_ext/423329220/plib_evsys.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/423329220/plib_evsys.o.d" -o ${OBJECTDIR}/_ext/423329220/plib_evsys.o ../src/config/same54_xpro/peripheral/evsys/plib_evsys.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/13387998/plib_nvic.o: ../src/config/same54_xpro/peripheral/nvic/plib_nvic.c  .generated_files/17d0e39f561395a3c05bb121050a595748e7f1bb.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/13387998" 
	@${RM} ${OBJECTDIR}/_ext/13387998/plib_nvic.o.d 
	@${RM} ${OBJECTDIR}/_ext/13387998/plib_nvic.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/13387998/plib_nvic.o.d" -o ${OBJECTDIR}/_ext/13387998/plib_nvic.o ../src/config/same54_xpro/peripheral/nvic/plib_nvic.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o: ../src/config/same54_xpro/peripheral/nvmctrl/plib_nvmctrl.c  .generated_files/2a628674b5c5afa3d1cf7a0214e73dd958665a57.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/593919312" 
	@${RM} ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o.d" -o ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o ../src/config/same54_xpro/peripheral/nvmctrl/plib_nvmctrl.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/13334847/plib_port.o: ../src/config/same54_xpro/peripheral/port/plib_port.c  .generated_files/424ceac998962ea5a1557a9cfc0bf31905239023.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/13334847" 
	@${RM} ${OBJECTDIR}/_ext/13334847/plib_port.o.d 
	@${RM} ${OBJECTDIR}/_ext/13334847/plib_port.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/13334847/plib_port.o.d" -o ${OBJECTDIR}/_ext/13334847/plib_port.o ../src/config/same54_xpro/peripheral/port/plib_port.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o: ../src/config/same54_xpro/peripheral/sercom/usart/plib_sercom2_usart.c  .generated_files/d594a7f59b58184156b9161111b79c410e013828.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/2047131351" 
	@${RM} ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o.d 
	@${RM} ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o.d" -o ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o ../src/config/same54_xpro/peripheral/sercom/usart/plib_sercom2_usart.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/970255097/plib_wdt.o: ../src/config/same54_xpro/peripheral/wdt/plib_wdt.c  .generated_files/8cf04313739ce37c2a5974421ee9e52fd2160f6d.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/970255097" 
	@${RM} ${OBJECTDIR}/_ext/970255097/plib_wdt.o.d 
	@${RM} ${OBJECTDIR}/_ext/970255097/plib_wdt.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/970255097/plib_wdt.o.d" -o ${OBJECTDIR}/_ext/970255097/plib_wdt.o ../src/config/same54_xpro/peripheral/wdt/plib_wdt.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1619787690/xc32_monitor.o: ../src/config/same54_xpro/stdio/xc32_monitor.c  .generated_files/7162ae39a799ba3018c0fc8e0f13b2b934fa3ce4.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1619787690" 
	@${RM} ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1619787690/xc32_monitor.o.d" -o ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o ../src/config/same54_xpro/stdio/xc32_monitor.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/initialization.o: ../src/config/same54_xpro/initialization.c  .generated_files/db2bd13c6f28626de8ac96fdbfb8568ab7709874.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/initialization.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/initialization.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/initialization.o.d" -o ${OBJECTDIR}/_ext/1510338148/initialization.o ../src/config/same54_xpro/initialization.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/interrupts.o: ../src/config/same54_xpro/interrupts.c  .generated_files/ec00448fc06b0cef7113ac830c36287a31466a4b.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/interrupts.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/interrupts.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/interrupts.o.d" -o ${OBJECTDIR}/_ext/1510338148/interrupts.o ../src/config/same54_xpro/interrupts.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/exceptions.o: ../src/config/same54_xpro/exceptions.c  .generated_files/e33c6cd5526f1e35b00d0bc77c7736614942f096.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/exceptions.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/exceptions.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/exceptions.o.d" -o ${OBJECTDIR}/_ext/1510338148/exceptions.o ../src/config/same54_xpro/exceptions.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/startup_xc32.o: ../src/config/same54_xpro/startup_xc32.c  .generated_files/2d8be04b7353a8fc3da544bbd0c4e223018091e7.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/startup_xc32.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/startup_xc32.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/startup_xc32.o.d" -o ${OBJECTDIR}/_ext/1510338148/startup_xc32.o ../src/config/same54_xpro/startup_xc32.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/libc_syscalls.o: ../src/config/same54_xpro/libc_syscalls.c  .generated_files/b9e18bce2799ec1c07d35a479ce21b9e8591ce3d.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/libc_syscalls.o.d" -o ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o ../src/config/same54_xpro/libc_syscalls.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1214204543/asn1parse.o: ../../../../../../../libraries/3rdparty/tinycrypt/asn1/asn1parse.c  .generated_files/684ab427d838091c1e40e8be23dc333668cc245c.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1214204543" 
	@${RM} ${OBJECTDIR}/_ext/1214204543/asn1parse.o.d 
	@${RM} ${OBJECTDIR}/_ext/1214204543/asn1parse.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1214204543/asn1parse.o.d" -o ${OBJECTDIR}/_ext/1214204543/asn1parse.o ../../../../../../../libraries/3rdparty/tinycrypt/asn1/asn1parse.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/aes_decrypt.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_decrypt.c  .generated_files/320b375df6628101bd6ccb309530b73ba37bc902.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/aes_decrypt.o.d" -o ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_decrypt.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/aes_encrypt.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_encrypt.c  .generated_files/d68f08dd1b115e87fe8a1b36c96382fc5754ceb7.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/aes_encrypt.o.d" -o ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_encrypt.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/cbc_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cbc_mode.c  .generated_files/8401a3fa1d9b93de39f149513fe63302b438a9d9.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cbc_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cbc_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/cbc_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/cbc_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cbc_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ccm_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ccm_mode.c  .generated_files/3ed712cbd50635a5909a87a40daece75cfa87b4a.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ccm_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ccm_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ccm_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/ccm_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ccm_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/cmac_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cmac_mode.c  .generated_files/bbd0941a1a5cf9bca1212f03b76ebce04b5188dd.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cmac_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cmac_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/cmac_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/cmac_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cmac_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ctr_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_mode.c  .generated_files/ab5881c9080b3c7c6f1a9519d61ec61490ed0dd7.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ctr_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/ctr_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ctr_prng.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_prng.c  .generated_files/293991b50c8de91ffb1186b30fc3aacb246b48a.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_prng.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_prng.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ctr_prng.o.d" -o ${OBJECTDIR}/_ext/1193839791/ctr_prng.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_prng.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc.c  .generated_files/396564e8e914ff41edb5a2b0a6296d410af7f8eb.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc_dh.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dh.c  .generated_files/ad8d1f3632997e3ff934cc90243e76ce34f9e265.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dh.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dh.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc_dh.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc_dh.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dh.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc_dsa.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dsa.c  .generated_files/7ac3219241ec283532853c237926e3a1fa1948f9.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc_dsa.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dsa.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_platform_specific.c  .generated_files/f5d505a191040a97b289551aaeab9bd30defff83.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_platform_specific.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/hmac.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac.c  .generated_files/b75dd732d97b535ed3eecd74a7bd97a87b4e1f90.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/hmac.o.d" -o ${OBJECTDIR}/_ext/1193839791/hmac.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/hmac_prng.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac_prng.c  .generated_files/f354fef5fafe89c92f4e2acda9a144dd2412dc58.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac_prng.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac_prng.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/hmac_prng.o.d" -o ${OBJECTDIR}/_ext/1193839791/hmac_prng.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac_prng.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/sha256.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/sha256.c  .generated_files/7eea7e5fc55d395b9056bdb843e335c6e893295f.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/sha256.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/sha256.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/sha256.o.d" -o ${OBJECTDIR}/_ext/1193839791/sha256.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/sha256.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/utils.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/utils.c  .generated_files/3ecc8f4637734000430f11487c5ae36b90a73b8b.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/utils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/utils.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/utils.o.d" -o ${OBJECTDIR}/_ext/1193839791/utils.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/utils.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1360937237/main.o: ../src/main.c  .generated_files/b55ca47d6a3c1e7f460b5685d644d24ea6b528cc.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1360937237/main.o.d" -o ${OBJECTDIR}/_ext/1360937237/main.o ../src/main.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
else
${OBJECTDIR}/_ext/2097892688/asn1utility.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/asn1utility.c  .generated_files/36b6e3841e36064d6835b0d6f88af8aa50213899.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/2097892688" 
	@${RM} ${OBJECTDIR}/_ext/2097892688/asn1utility.o.d 
	@${RM} ${OBJECTDIR}/_ext/2097892688/asn1utility.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/2097892688/asn1utility.o.d" -o ${OBJECTDIR}/_ext/2097892688/asn1utility.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/asn1utility.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/aws_boot_crypto.c  .generated_files/92984378d240766dbbe38b87bdfe91ca59df70a1.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/2097892688" 
	@${RM} ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o.d 
	@${RM} ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o.d" -o ${OBJECTDIR}/_ext/2097892688/aws_boot_crypto.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/crypto/tinycrypt/aws_boot_crypto.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/93820448/aws_boot_flash.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_flash.c  .generated_files/eb19383521e6d5f3b758fc608aa495a1e7c91ef1.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/93820448" 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o.d 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/93820448/aws_boot_flash.o.d" -o ${OBJECTDIR}/_ext/93820448/aws_boot_flash.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_flash.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_nvm.c  .generated_files/dafc29dae9fb06a2889f3e07fdb9fcc3515eff42.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/93820448" 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o.d 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o.d" -o ${OBJECTDIR}/_ext/93820448/aws_boot_nvm.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_nvm.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/93820448/aws_boot_partition.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_partition.c  .generated_files/1a728fcf8a1d04d53e6bb6703d82837c3510caff.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/93820448" 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o.d 
	@${RM} ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/93820448/aws_boot_partition.o.d" -o ${OBJECTDIR}/_ext/93820448/aws_boot_partition.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash/aws_boot_partition.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_loader.c  .generated_files/63cfac7fe3b64b3db61bc7da4fd1dea7f67c38e7.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1561064483" 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o.d 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o.d" -o ${OBJECTDIR}/_ext/1561064483/aws_boot_loader.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_loader.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_pal.c  .generated_files/a6627d12f9e992baf49e96a2e54da7f50eac31af.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1561064483" 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o.d 
	@${RM} ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o.d" -o ${OBJECTDIR}/_ext/1561064483/aws_boot_pal.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/loader/aws_boot_pal.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/619668485/app.o: ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/source/app.c  .generated_files/91df317cf30f7f5a59b68b0918e1382b59608660.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/619668485" 
	@${RM} ${OBJECTDIR}/_ext/619668485/app.o.d 
	@${RM} ${OBJECTDIR}/_ext/619668485/app.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/619668485/app.o.d" -o ${OBJECTDIR}/_ext/619668485/app.o ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/source/app.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/288800588/bsp.o: ../src/config/same54_xpro/bsp/bsp.c  .generated_files/928fab5915319a824515b9a56ece9dc5d7829e70.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/288800588" 
	@${RM} ${OBJECTDIR}/_ext/288800588/bsp.o.d 
	@${RM} ${OBJECTDIR}/_ext/288800588/bsp.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/288800588/bsp.o.d" -o ${OBJECTDIR}/_ext/288800588/bsp.o ../src/config/same54_xpro/bsp/bsp.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/425478706/plib_clock.o: ../src/config/same54_xpro/peripheral/clock/plib_clock.c  .generated_files/42d2608a891776737c7abaa72113c44487ca3265.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/425478706" 
	@${RM} ${OBJECTDIR}/_ext/425478706/plib_clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/425478706/plib_clock.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/425478706/plib_clock.o.d" -o ${OBJECTDIR}/_ext/425478706/plib_clock.o ../src/config/same54_xpro/peripheral/clock/plib_clock.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/13724534/plib_cmcc.o: ../src/config/same54_xpro/peripheral/cmcc/plib_cmcc.c  .generated_files/218005ff0f6a420c6ba834cb21187afc1a9df69a.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/13724534" 
	@${RM} ${OBJECTDIR}/_ext/13724534/plib_cmcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/13724534/plib_cmcc.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/13724534/plib_cmcc.o.d" -o ${OBJECTDIR}/_ext/13724534/plib_cmcc.o ../src/config/same54_xpro/peripheral/cmcc/plib_cmcc.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/423329220/plib_evsys.o: ../src/config/same54_xpro/peripheral/evsys/plib_evsys.c  .generated_files/4f1b11ae7293096418a71acfa3dfaa66cac7d429.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/423329220" 
	@${RM} ${OBJECTDIR}/_ext/423329220/plib_evsys.o.d 
	@${RM} ${OBJECTDIR}/_ext/423329220/plib_evsys.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/423329220/plib_evsys.o.d" -o ${OBJECTDIR}/_ext/423329220/plib_evsys.o ../src/config/same54_xpro/peripheral/evsys/plib_evsys.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/13387998/plib_nvic.o: ../src/config/same54_xpro/peripheral/nvic/plib_nvic.c  .generated_files/972ee6c031ceba7abfa2bc83fddac2ff84f255ec.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/13387998" 
	@${RM} ${OBJECTDIR}/_ext/13387998/plib_nvic.o.d 
	@${RM} ${OBJECTDIR}/_ext/13387998/plib_nvic.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/13387998/plib_nvic.o.d" -o ${OBJECTDIR}/_ext/13387998/plib_nvic.o ../src/config/same54_xpro/peripheral/nvic/plib_nvic.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o: ../src/config/same54_xpro/peripheral/nvmctrl/plib_nvmctrl.c  .generated_files/f2c6c0f5b09b746505c3faa7c0eb9cba13b3ba4c.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/593919312" 
	@${RM} ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o.d 
	@${RM} ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o.d" -o ${OBJECTDIR}/_ext/593919312/plib_nvmctrl.o ../src/config/same54_xpro/peripheral/nvmctrl/plib_nvmctrl.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/13334847/plib_port.o: ../src/config/same54_xpro/peripheral/port/plib_port.c  .generated_files/b1d1cc6870f22c0432df2aec527b9f58afc09074.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/13334847" 
	@${RM} ${OBJECTDIR}/_ext/13334847/plib_port.o.d 
	@${RM} ${OBJECTDIR}/_ext/13334847/plib_port.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/13334847/plib_port.o.d" -o ${OBJECTDIR}/_ext/13334847/plib_port.o ../src/config/same54_xpro/peripheral/port/plib_port.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o: ../src/config/same54_xpro/peripheral/sercom/usart/plib_sercom2_usart.c  .generated_files/616f900fad691daec0b1643f21ed082a7771680a.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/2047131351" 
	@${RM} ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o.d 
	@${RM} ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o.d" -o ${OBJECTDIR}/_ext/2047131351/plib_sercom2_usart.o ../src/config/same54_xpro/peripheral/sercom/usart/plib_sercom2_usart.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/970255097/plib_wdt.o: ../src/config/same54_xpro/peripheral/wdt/plib_wdt.c  .generated_files/6bd1fe41e9dfe1277acc47116859e970d02f64fa.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/970255097" 
	@${RM} ${OBJECTDIR}/_ext/970255097/plib_wdt.o.d 
	@${RM} ${OBJECTDIR}/_ext/970255097/plib_wdt.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/970255097/plib_wdt.o.d" -o ${OBJECTDIR}/_ext/970255097/plib_wdt.o ../src/config/same54_xpro/peripheral/wdt/plib_wdt.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1619787690/xc32_monitor.o: ../src/config/same54_xpro/stdio/xc32_monitor.c  .generated_files/5026213b05e179798b707f330ce47a5ee4035760.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1619787690" 
	@${RM} ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o.d 
	@${RM} ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1619787690/xc32_monitor.o.d" -o ${OBJECTDIR}/_ext/1619787690/xc32_monitor.o ../src/config/same54_xpro/stdio/xc32_monitor.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/initialization.o: ../src/config/same54_xpro/initialization.c  .generated_files/9dd5e9d3a6f2a9da07111546ae595469f0770287.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/initialization.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/initialization.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/initialization.o.d" -o ${OBJECTDIR}/_ext/1510338148/initialization.o ../src/config/same54_xpro/initialization.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/interrupts.o: ../src/config/same54_xpro/interrupts.c  .generated_files/8a56aedb75d8d3a9f8bb5d495a9bcc7de798b7b3.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/interrupts.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/interrupts.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/interrupts.o.d" -o ${OBJECTDIR}/_ext/1510338148/interrupts.o ../src/config/same54_xpro/interrupts.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/exceptions.o: ../src/config/same54_xpro/exceptions.c  .generated_files/f23c919058e6119ce76c96dd5c1144e046ba5de4.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/exceptions.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/exceptions.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/exceptions.o.d" -o ${OBJECTDIR}/_ext/1510338148/exceptions.o ../src/config/same54_xpro/exceptions.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/startup_xc32.o: ../src/config/same54_xpro/startup_xc32.c  .generated_files/d09f47c0822bd1bd98f78c378ad600c7f70f94d9.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/startup_xc32.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/startup_xc32.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/startup_xc32.o.d" -o ${OBJECTDIR}/_ext/1510338148/startup_xc32.o ../src/config/same54_xpro/startup_xc32.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1510338148/libc_syscalls.o: ../src/config/same54_xpro/libc_syscalls.c  .generated_files/7b7db28fd8a150fa48f6979800ff5299bb526ce.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1510338148" 
	@${RM} ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o.d 
	@${RM} ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1510338148/libc_syscalls.o.d" -o ${OBJECTDIR}/_ext/1510338148/libc_syscalls.o ../src/config/same54_xpro/libc_syscalls.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1214204543/asn1parse.o: ../../../../../../../libraries/3rdparty/tinycrypt/asn1/asn1parse.c  .generated_files/4308312e634df69113079bf3bdb97c133b6e3a9e.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1214204543" 
	@${RM} ${OBJECTDIR}/_ext/1214204543/asn1parse.o.d 
	@${RM} ${OBJECTDIR}/_ext/1214204543/asn1parse.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1214204543/asn1parse.o.d" -o ${OBJECTDIR}/_ext/1214204543/asn1parse.o ../../../../../../../libraries/3rdparty/tinycrypt/asn1/asn1parse.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/aes_decrypt.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_decrypt.c  .generated_files/90fc43c4fecbffe198db7cfc101b11278d1065eb.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/aes_decrypt.o.d" -o ${OBJECTDIR}/_ext/1193839791/aes_decrypt.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_decrypt.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/aes_encrypt.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_encrypt.c  .generated_files/a424ea14d5cfbefb0a2a38d89bcc35c95a9ebe21.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/aes_encrypt.o.d" -o ${OBJECTDIR}/_ext/1193839791/aes_encrypt.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/aes_encrypt.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/cbc_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cbc_mode.c  .generated_files/c3cdb32f231713657df972e9d84adb7967dea0bc.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cbc_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cbc_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/cbc_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/cbc_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cbc_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ccm_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ccm_mode.c  .generated_files/70f1d48e8b4dffcae97795ca5e362c40913f3937.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ccm_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ccm_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ccm_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/ccm_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ccm_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/cmac_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cmac_mode.c  .generated_files/ea4a835da8282d7059d30a5b6559dce02a544b4e.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cmac_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/cmac_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/cmac_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/cmac_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/cmac_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ctr_mode.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_mode.c  .generated_files/45d4abfb9ad1e6fa4d1ddcd292858f794ca548db.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_mode.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_mode.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ctr_mode.o.d" -o ${OBJECTDIR}/_ext/1193839791/ctr_mode.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_mode.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ctr_prng.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_prng.c  .generated_files/c8977517a1fb633f4369541436dc9780a939c24b.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_prng.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ctr_prng.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ctr_prng.o.d" -o ${OBJECTDIR}/_ext/1193839791/ctr_prng.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ctr_prng.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc.c  .generated_files/2d6be1840ea5f6bd50caeceb960543f94feea433.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc_dh.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dh.c  .generated_files/6bb508b1276ecf70786401c656314ec67877199d.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dh.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dh.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc_dh.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc_dh.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dh.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc_dsa.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dsa.c  .generated_files/34156d5584fc9f20211f2d2393aed518e896c8e5.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc_dsa.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc_dsa.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_dsa.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_platform_specific.c  .generated_files/9a0aa43d768cd38e82dc7943763c94dcc73176c6.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o.d" -o ${OBJECTDIR}/_ext/1193839791/ecc_platform_specific.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/ecc_platform_specific.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/hmac.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac.c  .generated_files/f34660b49ac83c4d2a702e0169b6adc070d50f2.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/hmac.o.d" -o ${OBJECTDIR}/_ext/1193839791/hmac.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/hmac_prng.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac_prng.c  .generated_files/2b4a6d6bf64c625f080b915ad48b8710d0e34b04.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac_prng.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/hmac_prng.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/hmac_prng.o.d" -o ${OBJECTDIR}/_ext/1193839791/hmac_prng.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/hmac_prng.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/sha256.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/sha256.c  .generated_files/92e916f5a975277161bcb854353baa805951f88c.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/sha256.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/sha256.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/sha256.o.d" -o ${OBJECTDIR}/_ext/1193839791/sha256.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/sha256.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1193839791/utils.o: ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/utils.c  .generated_files/287d2afc2f9a29cb2a45a08282b811c07ea67ea0.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1193839791" 
	@${RM} ${OBJECTDIR}/_ext/1193839791/utils.o.d 
	@${RM} ${OBJECTDIR}/_ext/1193839791/utils.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1193839791/utils.o.d" -o ${OBJECTDIR}/_ext/1193839791/utils.o ../../../../../../../libraries/3rdparty/tinycrypt/lib/source/utils.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
${OBJECTDIR}/_ext/1360937237/main.o: ../src/main.c  .generated_files/c8838bb0b79acfb62ccb080cda83e690fe43e85.flag .generated_files/266bf8b248d573397354279739be16fd942da08.flag
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/main.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -ffunction-sections -fdata-sections -O1 -I"../src" -I"../src/config/same54_xpro" -I"../src/packs/ATSAME54P20A_DFP" -I"../src/packs/CMSIS/CMSIS/Core/Include" -I"../src/packs/CMSIS/" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/config_files" -I"../../../../../../../libraries/3rdparty/tinycrypt/lib/include" -I"../../../../../../../libraries/3rdparty/tinycrypt/asn1" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/flash" -I"../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/common/include" -Wall -MP -MMD -MF "${OBJECTDIR}/_ext/1360937237/main.o.d" -o ${OBJECTDIR}/_ext/1360937237/main.o ../src/main.c    -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}" ${PACK_COMMON_OPTIONS} 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compileCPP
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    ../src/config/same54_xpro/ATSAME54P20A.ld
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -g   -mprocessor=$(MP_PROCESSOR_OPTION) -nostartfiles -nostartfiles -mno-device-startup-code -o dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D=__DEBUG_D,--defsym=_min_heap_size=512,--gc-sections,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,-DROM_LENGTH=0x10000,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -mdfp="${DFP_DIR}"
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   ../src/config/same54_xpro/ATSAME54P20A.ld
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mprocessor=$(MP_PROCESSOR_OPTION) -nostartfiles -nostartfiles -mno-device-startup-code -o dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -DXPRJ_same54_xpro=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=_min_heap_size=512,--gc-sections,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,-DROM_LENGTH=0x10000,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -mdfp="${DFP_DIR}"
	${MP_CC_DIR}\\xc32-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} 
endif

.pre:
	@echo "--------------------------------------"
	@echo "User defined pre-build step: [python ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/utility/codesigner_cert_utility/codesigner_cert_utility.py ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/utility/codesigner_cert_utility/ecdsasigner.crt ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include/aws_boot_codesigner_public_key.h]"
	@python ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/utility/codesigner_cert_utility/codesigner_cert_utility.py ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/utility/codesigner_cert_utility/ecdsasigner.crt ../../../../../../../vendors/microchip/boards/same54_xpro/bootloader/bootloader/include/aws_boot_codesigner_public_key.h
	@echo "--------------------------------------"

# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/same54_xpro
	${RM} -r dist/same54_xpro

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
