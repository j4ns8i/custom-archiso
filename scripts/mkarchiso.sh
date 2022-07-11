set -ex

: ${CUSTOM_ARCHISO_BUILD_DIR:=target/build}
: ${CUSTOM_ARCHISO_WORK_DIR:=target/work}

pacman -Syu --noconfirm archiso

mkdir -p ${CUSTOM_ARCHISO_BUILD_DIR}
cp -r /usr/share/archiso/configs/releng/* ${CUSTOM_ARCHISO_BUILD_DIR}/
cd ${CUSTOM_ARCHISO_BUILD_DIR}

sed -i'' -E 's/^(\s+linux.*)/\1 cow_spacesize=2G nomodeset nouveau.modeset=0/' ${CUSTOM_ARCHISO_BUILD_DIR}/grub/grub.cfg

sed -i'' -E 's/^(options.*)/\1 nomodeset nouveau.modeset=0/' ${CUSTOM_ARCHISO_BUILD_DIR}/efiboot/loader/entries/01-archiso-x86_64-linux.conf
sed -i'' -E 's/^(APPEND.*)/\1 nomodeset nouveau.modeset=0/' ${CUSTOM_ARCHISO_BUILD_DIR}/syslinux/archiso_sys-linux.cfg

mkdir -p ${CUSTOM_ARCHISO_WORK_DIR}
mkarchiso -v -w ${CUSTOM_ARCHISO_WORK_DIR} -o ${CUSTOM_ARCHISO_BUILD_DIR}/out ${CUSTOM_ARCHISO_BUILD_DIR}
