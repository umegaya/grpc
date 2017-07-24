#!/bin/bash

PLATFORM=android-21
if [ ! -z "${ARM64}" ]; then
ARCH=arm64-v8a
PLATFORM_ARCH=arch-arm64
TOOLCHAIN_ARCH=aarch64-linux-android
MARCH="-march=armv8-a"
else
ARCH=armeabi-v7a
PLATFORM_ARCH=arch-arm
TOOLCHAIN_ARCH=arm-linux-androideabi
MARCH="-march=armv7-a"
fi

# for gnu libstdc++
#STL=gnu-libstdc++/4.9
#LIB=gnustl_static
#LIBPATH=gnu-libstdc++/4.9/libs/${ARCH}

STL=llvm-libc++/libcxx
LIB=c++_static
LIBPATH=llvm-libc++/libs/${ARCH}

make clean
make V=1 HAS_PKG_CONFIG=false \
CC=${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-gcc \
CXX=${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-g++ \
LD=${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-ld \
LDXX=${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-ld \
AR="${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-ar crs" \
STRIP=${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-strip \
RANLIB=${ANDROID_NDK}/toolchains/${TOOLCHAIN_ARCH}-4.9/prebuilt/darwin-x86_64/bin/${TOOLCHAIN_ARCH}-ranlib \
PROTOBUF_CONFIG_OPTS="--host=${TOOLCHAIN_ARCH}" \
PROTOBUF_CPPFLAGS_EXTRA="--sysroot=${ANDROID_NDK}/platforms/${PLATFORM}/${PLATFORM_ARCH}" \
LDFLAGS="-L${ANDROID_NDK}/platforms/${PLATFORM}/${PLATFORM_ARCH}/usr/lib \
  -L${ANDROID_NDK}/sources/cxx-stl/${LIBPATH} \
  --sysroot=${ANDROID_NDK}/platforms/${PLATFORM}/${PLATFORM_ARCH} \
  -l${LIB} -latomic" \
MARCH="${MARCH}" \
CPPFLAGS="--sysroot=${ANDROID_NDK}/platforms/${PLATFORM}/${PLATFORM_ARCH} \
  -I${ANDROID_NDK}/platforms/${PLATFORM}/${PLATFORM_ARCH}/usr/include \
  -I${ANDROID_NDK}/sources/cxx-stl/${STL}/include \
  -I${ANDROID_NDK}/sources/android/support/include \
  -I./include -I. -I./third_party/boringssl/include ${MARCH}"

