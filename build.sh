#
 # Copyright � 2016,  Sultan Qasim Khan <sultanqasim@gmail.com> 	
 # Copyright � 2016,  Zeeshan Hussain <zeeshanhussain12@gmail.com> 	      
 # Copyright � 2016,  Varun Chitre  <varun.chitre15@gmail.com>	
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #

#!/bin/bash
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/zeeshan/uber-5.2/bin/arm-eabi-
export KBUILD_BUILD_USER="zeeshan"
export KBUILD_BUILD_HOST="thunder-prince"
echo -e "$cyan***********************************************"
echo "          Compiling Inazuma kernel          "
echo -e "***********************************************$nocol"
rm -f arch/arm/boot/dts/*.dtb
rm -f arch/arm/boot/dt.img
rm -f cwm_flash_zip/boot.img
echo -e " Initializing defconfig"
make osprey_defconfig
echo -e " Building kernel"
make -j4 zImage
make -j4 dtbs

/home/zeeshan/inazuma-osprey/tools/dtbToolCM -2 -o /home/zeeshan/inazuma-osprey/arch/arm/boot/dt.img -s 2048 -p /home/zeeshan/inazuma-osprey/scripts/dtc/ /home/zeeshan/inazuma-osprey/arch/arm/boot/dts/

make -j4 modules
echo -e " Converting the output into a flashable zip"
rm -rf inazuma_install
mkdir -p inazuma_install
make -j4 modules_install INSTALL_MOD_PATH=inazuma_install INSTALL_MOD_STRIP=1
mkdir -p cwm_flash_zip/system/lib/modules/pronto
find inazuma_install/ -name '*.ko' -type f -exec cp '{}' cwm_flash_zip/system/lib/modules/ \;
mv cwm_flash_zip/system/lib/modules/wlan.ko cwm_flash_zip/system/lib/modules/pronto/pronto_wlan.ko
cp arch/arm/boot/zImage cwm_flash_zip/tools/
cp arch/arm/boot/dt.img cwm_flash_zip/tools/
rm -f /home/zeeshan/afh/squid_kernel.zip
cd cwm_flash_zip
zip -r ../arch/arm/boot/inazuma_kernel.zip ./
mv /home/zeeshan/inazuma-osprey/arch/arm/boot/inazuma_kernel.zip /home/zeeshan/afh
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

