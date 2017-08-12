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
KERNEL_DIR=/home/ubuntu/workspace/HKernel
KERN_IMG=$KERNEL_DIR/arch/arm/boot/zImage
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/ubuntu/workspace/arm-eabi-6.0/bin/arm-eabi-
export KBUILD_BUILD_USER="hk"
export KBUILD_BUILD_HOST="jarvis"
rm -f arch/arm/boot/dts/*.dtb
rm -f arch/arm/boot/dt.img
rm -f /home/ubuntu/workspace/AnyKernel2/zImage

compile_kernel ()
{
  echo -e "$cyan***********************************************"
  echo -e "          Initializing defconfig          "
  echo -e "***********************************************$nocol"
  make merlin_defconfig
  echo -e "$cyan***********************************************"
  echo -e "             Building kernel          "
  echo -e "***********************************************$nocol"
  make -j4
  echo -e "$cyan***********************************************"
  echo -e "         	Building modules          "
  echo -e "***********************************************$nocol"
  make -j4 modules
}

HKernel ()
{
  echo -e "$cyan***********************************************"
  echo "          Compiling HKernel kernel          "
  echo -e "***********************************************$nocol"
  
     
     compile_kernel

echo -e "$cyan***********************************************"
echo -e " Converting the output into a flashable zip"
echo -e "***********************************************$nocol"

find -name '*.ko' -type f -exec cp '{}' /home/ubuntu/workspace/AnyKernel2/modules/ \;
cp arch/arm/boot/zImage /home/ubuntu/workspace/AnyKernel2/
cd /home/ubuntu/workspace/AnyKernel2/
zip -r9 /home/ubuntu/workspace/HKernel-v.zip *
today=$(date +"-%d%m%Y")
}
HKernel
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
