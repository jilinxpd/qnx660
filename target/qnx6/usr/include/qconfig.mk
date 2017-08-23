#
# Linux qconfig.mk file
#
ifndef BUILDENV
BUILDENV := qss
endif

LINUX_HOST_CPU	:= $(shell cd / && uname -m)

LINUX_DEFS 		:= -D__LINUX__ -D__X86__ -D__LITTLEENDIAN__
ifeq (x86_64,$(LINUX_HOST_CPU))
	LINUX_CPU_DEFS := -m32
endif

#
# The base directories for the installation trees.
#
INSTALL_ROOT_nto	:= $(QNX_TARGET)
INSTALL_ROOT_linux	:=

#
# The base directories for accessing headers/libraries for various OS's.
#
USE_ROOT_nto		:= $(QNX_TARGET)
USE_ROOT_linux		:=

#
# QNX Recursive Make files
#
MKFILES_ROOT 		:= $(QNX_TARGET)/usr/include/mk

#
# The MG_HOST utilty is to "mark generated" any file that you'd normally
# consider a source file (something with a .c, .s, etc. extension),
# but is actually generated by a program. E.g., the kernel call
# source files in libc. It's purely for documentation purposes. 
#
MG_HOST = /bin/true
#
# Copy a space separated list of files (possibly with wildcards) to an
# installation directory.  Linux cp does not support creating any
# target directories, so call a simple script that tests first, and
# creates the target path as needed.
#
CP_HOST = $(QNX_HOST)/usr/bin/qnx_cp -fpc $(CP_HOST_OPTIONS)
#
# Create a symbolic link.  
#
LN_HOST = /bin/ln -sf $(LN_HOST_OPTIONS)
#
# Delete a space separated list of files (possibly with wildcards).
#
RM_HOST = /bin/rm -f $(RM_HOST_OPTIONS)
#
# Create an empty file
#
TOUCH_HOST = /bin/touch
#
# Print the full path of the current working directory to standard output.
# Due to differences in the outputs of shell builtin and binary pwd, we
# override PWD to be the binary output.
#
PWD_HOST = /bin/pwd
PWD := $(shell $(PWD_HOST))
#
# Generate a space separated list of files in a directory tree, ignoring
# anything in a CVS or RCS directory.
#
FL_HOST = $(MKFILES_ROOT)/flist-unix
#
# Generate an assembler definition file from an object file.
#
MKASMOFF_HOST = $(QNX_HOST)/usr/bin/mkasmoff 
#
# Mark something as a privledged executable (setuid)
#
MP_HOST = $(MKFILES_ROOT)/makepriv-unix

ECHO_HOST = /bin/echo
DATE_HOST = /bin/date +%Y/%m/%d-%T-%Z
USER_HOST := $(firstword $(filter /%, $(shell which -a id))) -un
HOST_HOST = /bin/hostname

#
# CL_*  Compile and link
# CC_*  Compile C/C++ source to an object file
# AS_*  Assemble something to an object file
# AR_*  Generate an object file library (archive)
# LR_*  Link a list of objects/libraries to a relocatable object file
# LD_*  Link a list of objects/libraries to a executable/shared object
# UM_*  Add a usage message to an executable
# PB_*	Add PhAB resources to an executable using "phabbind"
#

#
# host system
#
CL_HOST = gcc $(LINUX_CPU_DEFS) $(LINUX_DEFS)
CC_HOST = gcc -c $(LINUX_CPU_DEFS) $(LINUX_DEFS)
AS_HOST = gcc -c $(LINUX_CPU_DEFS)
AR_HOST = ar -r
LD_HOST = gcc $(LINUX_CPU_DEFS)
UM_HOST	= $(QNX_HOST)/usr/bin/usemsg
PB_HOST	= $(QNX_HOST)/usr/bin/phabbind

CD_nto_x86_gcc = qcc
CD_nto_x86_icc = qcc
CD_nto_ppc_gcc = qcc
CD_nto_mips_gcc = qcc
CD_nto_sh_gcc = qcc
CD_nto_arm_gcc = qcc
CD_win32_x86_gcc = qcc
COMPILER_DRIVER = $(CD_$(OS)_$(CPU)_$(COMPILER_TYPE))

dash:=-
comma:=,
gcc_ver_suffix=$(if $(GCC_VERSION),$(dash)$(GCC_VERSION))
gcc_ver_string=$(if $(GCC_VERSION),$(GCC_VERSION)$(comma))

#
# NTO X86 target 
#
CC_nto_x86_gcc = $(QNX_HOST)/usr/bin/ntox86-gcc$(gcc_ver_suffix) 
AS_nto_x86_gcc = $(QNX_HOST)/usr/bin/ntox86-gcc$(gcc_ver_suffix) 
AR_nto_x86_gcc = $(QNX_HOST)/usr/bin/ntox86-ar
LR_nto_x86_gcc = $(QNX_HOST)/usr/bin/ntox86-gcc$(gcc_ver_suffix) -r
LD_nto_x86_gcc = $(QNX_HOST)/usr/bin/ntox86-gcc$(gcc_ver_suffix) 
UM_nto_x86_gcc = $(UM_HOST) -s __USAGENTO -s __USAGE
OC_nto_x86_gcc = $(QNX_HOST)/usr/bin/ntox86-objcopy 
LDBOOTSTRAP_nto_x86_gcc = $(QNX_HOST)/usr/bin/ldbootstrap -Bstatic -u_start
LDBOOTSTRAPPOST_nto_x86_gcc = -L$(USE_ROOT_nto)/x86/lib -lc $(shell $(CC_nto_x86_gcc) -print-libgcc-file-name)

CC_nto_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntox86 -c
AS_nto_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntox86 -c
LR_nto_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntox86 -r
LD_nto_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntox86
AR_nto_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntox86 -a
UM_nto_x86_gcc_qcc = $(UM_nto_x86_gcc)
OC_nto_x86_gcc_qcc = $(OC_nto_x86_gcc)
LDBOOTSTRAP_nto_x86_gcc_qcc = $(LDBOOTSTRAP_nto_x86_gcc)
LDBOOTSTRAPPOST_nto_x86_gcc_qcc = $(LDBOOTSTRAPPOST_nto_x86_gcc)

CC_nto_x86_icc = icc -c
AS_nto_x86_icc = icc -c
LR_nto_x86_icc = icc -r
LD_nto_x86_icc = icc
AR_nto_x86_icc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)icc_ntox86 -a
UM_nto_x86_icc = $(UM_nto_x86_gcc)
OC_nto_x86_icc = $(OC_nto_x86_gcc)
LDBOOTSTRAP_nto_x86_icc = $(LDBOOTSTRAP_nto_x86_gcc)
LDBOOTSTRAPPOST_nto_x86_icc = $(LDBOOTSTRAPPOST_nto_x86_gcc)

CC_nto_x86_icc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)icc_ntox86 -c
AS_nto_x86_icc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)icc_ntox86 -c
LR_nto_x86_icc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)icc_ntox86 -r
LD_nto_x86_icc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)icc_ntox86
AR_nto_x86_icc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)icc_ntox86 -a
UM_nto_x86_icc_qcc = $(UM_nto_x86_gcc)
OC_nto_x86_icc_qcc = $(OC_nto_x86_gcc)
LDBOOTSTRAP_nto_x86_icc_qcc = $(LDBOOTSTRAP_nto_x86_gcc)
LDBOOTSTRAPPOST_nto_x86_icc_qcc = $(LDBOOTSTRAPPOST_nto_x86_gcc)

#
# NTO PPC target 
#
CC_nto_ppc_gcc = $(QNX_HOST)/usr/bin/ntoppc-gcc$(gcc_ver_suffix) -c
AS_nto_ppc_gcc = $(QNX_HOST)/usr/bin/ntoppc-gcc$(gcc_ver_suffix) -c
AR_nto_ppc_gcc = $(QNX_HOST)/usr/bin/ntoppc-ar
LR_nto_ppc_gcc = $(QNX_HOST)/usr/bin/ntoppc-gcc$(gcc_ver_suffix) -r
LD_nto_ppc_gcc = $(QNX_HOST)/usr/bin/ntoppc-gcc$(gcc_ver_suffix) 
UM_nto_ppc_gcc = $(UM_HOST) -s __USAGENTO -s __USAGE
OC_nto_ppc_gcc = $(QNX_HOST)/usr/ntoppc-objcopy

CC_nto_ppc_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoppc -c
AS_nto_ppc_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoppc -c
LR_nto_ppc_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoppc -r
LD_nto_ppc_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoppc
AR_nto_ppc_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoppc -a
UM_nto_ppc_gcc_qcc = $(UM_nto_ppc_gcc)
OC_nto_ppc_gcc_qcc = $(OC_nto_ppc_gcc)

#
# NTO MIPS target
#
CC_nto_mips_gcc = $(QNX_HOST)/usr/bin/ntomips-gcc$(gcc_ver_suffix) -c
AS_nto_mips_gcc = $(QNX_HOST)/usr/bin/ntomips-gcc$(gcc_ver_suffix) -c
AR_nto_mips_gcc = $(QNX_HOST)/usr/bin/ntomips-ar
LR_nto_mips_gcc = $(QNX_HOST)/usr/bin/ntomips-gcc$(gcc_ver_suffix) -r
LD_nto_mips_gcc = $(QNX_HOST)/usr/bin/ntomips-gcc$(gcc_ver_suffix) 
UM_nto_mips_gcc = $(UM_HOST) -s __USAGENTO -s __USAGE
OC_nto_mips_gcc = $(QNX_HOST)/usr/bin/ntomips-objcopy

CC_nto_mips_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntomips -c
AS_nto_mips_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntomips -c
LR_nto_mips_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntomips -r
LD_nto_mips_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntomips
AR_nto_mips_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntomips -a
UM_nto_mips_gcc_qcc = $(UM_nto_mips_gcc)
OC_nto_mips_gcc_qcc = $(OC_nto_mips_gcc)

#
# NTO ARM target
#
CC_nto_arm_gcc = $(QNX_HOST)/usr/bin/ntoarm-gcc$(gcc_ver_suffix) -c
AS_nto_arm_gcc = $(QNX_HOST)/usr/bin/ntoarm-gcc$(gcc_ver_suffix) -c
AR_nto_arm_gcc = $(QNX_HOST)/usr/bin/ntoarm-ar
LR_nto_arm_gcc = $(QNX_HOST)/usr/bin/ntoarm-gcc$(gcc_ver_suffix) -r
LD_nto_arm_gcc = $(QNX_HOST)/usr/bin/ntoarm-gcc$(gcc_ver_suffix) 
UM_nto_arm_gcc = $(UM_HOST) -s __USAGENTO -s __USAGE
OC_nto_arm_gcc = $(QNX_HOST)/usr/bin/ntoarm-objcopy 

CC_nto_arm_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarm -c
AS_nto_arm_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarm -c
LR_nto_arm_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarm -r
LD_nto_arm_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarm
AR_nto_arm_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarm -a
UM_nto_arm_gcc_qcc = $(UM_nto_arm_gcc)
OC_nto_arm_gcc_qcc = $(OC_nto_arm_gcc)

#
# NTO ARMv7 target
#
CC_nto_arm_gcc_v7 = $(QNX_HOST)/usr/bin/ntoarmv7-gcc$(gcc_ver_suffix) -c
AS_nto_arm_gcc_v7 = $(QNX_HOST)/usr/bin/ntoarmv7-gcc$(gcc_ver_suffix) -c
AR_nto_arm_gcc_v7 = $(QNX_HOST)/usr/bin/ntoarmv7-ar
LR_nto_arm_gcc_v7 = $(QNX_HOST)/usr/bin/ntoarmv7-gcc$(gcc_ver_suffix) -r
LD_nto_arm_gcc_v7 = $(QNX_HOST)/usr/bin/ntoarmv7-gcc$(gcc_ver_suffix) 
UM_nto_arm_gcc_v7 = $(UM_HOST) -s __USAGENTO -s __USAGE
OC_nto_arm_gcc_v7 = $(QNX_HOST)/usr/bin/ntoarmv7-objcopy 

CC_nto_arm_gcc_qcc_v7 = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarmv7 -c
AS_nto_arm_gcc_qcc_v7 = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarmv7 -c
LR_nto_arm_gcc_qcc_v7 = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarmv7 -r
LD_nto_arm_gcc_qcc_v7 = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarmv7
AR_nto_arm_gcc_qcc_v7 = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntoarmv7 -a
UM_nto_arm_gcc_qcc_v7 = $(UM_nto_arm_gcc_v7)
OC_nto_arm_gcc_qcc_v7 = $(OC_nto_arm_gcc_v7)

#
# NTO SH target
#
CC_nto_sh_gcc = $(QNX_HOST)/usr/bin/ntosh-gcc$(gcc_ver_suffix) -c
AS_nto_sh_gcc = $(QNX_HOST)/usr/bin/ntosh-gcc$(gcc_ver_suffix) -c
AR_nto_sh_gcc = $(QNX_HOST)/usr/bin/ntosh-ar
LR_nto_sh_gcc = $(QNX_HOST)/usr/bin/ntosh-gcc$(gcc_ver_suffix) -r
LD_nto_sh_gcc = $(QNX_HOST)/usr/bin/ntosh-gcc$(gcc_ver_suffix) 
UM_nto_sh_gcc = $(UM_HOST) -s __USAGENTO -s __USAGE
OC_nto_sh_gcc = $(QNX_HOST)/usr/bin/ntosh-objcopy

CC_nto_sh_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntosh -c
AS_nto_sh_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntosh -c
LR_nto_sh_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntosh -r
LD_nto_sh_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntosh
AR_nto_sh_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_ntosh -a
UM_nto_sh_gcc_qcc = $(UM_nto_sh_gcc)
OC_nto_sh_gcc_qcc = $(OC_nto_sh_gcc)

#
# Linux x86 target
#
CC_linux_x86_gcc = gcc -c $(LINUX_DEFS) $(LINUX_CPU_DEFS)
AS_linux_x86_gcc = gcc -c $(LINUX_CPU_DEFS)
AR_linux_x86_gcc = ar -r
LR_linux_x86_gcc = gcc -r $(LINUX_CPU_DEFS)
LD_linux_x86_gcc = gcc $(LINUX_CPU_DEFS)
OC_linux_x86_gcc = objcopy 

CC_linux_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_linuxx86 -c
AS_linux_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_linuxx86 -c
LR_linux_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_linuxx86 -r
LD_linux_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_linuxx86
AR_linux_x86_gcc_qcc = $(AR_linux_x86_gcc)
OC_linux_x86_gcc_qcc = $(OC_linux_x86_gcc)

#
# Win32 x86 target
#

CC_win32_x86_gcc_gcc = i386-mingw32msvc-gcc -c
AS_win32_x86_gcc_gcc = i386-mingw32msvc-gcc -c
LR_win32_x86_gcc_gcc = i386-mingw32msvc-gcc -r
LD_win32_x86_gcc_gcc = i386-mingw32msvc-gcc
AR_win32_x86_gcc_gcc = i386-mingw32msvc-ar -r

CC_win32_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -c
AS_win32_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -c
LR_win32_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -r
LD_win32_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc
AR_win32_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -a

#
# Darwin x86 target
#

CC_darwin_x86_gcc = x86_64-apple-darwin-gcc -c
AS_darwin_x86_gcc = x86_64-apple-darwin-gcc -c
LR_darwin_x86_gcc = x86_64-apple-darwin-gcc -r
LD_darwin_x86_gcc = x86_64-apple-darwin-gcc
AR_darwin_x86_gcc = x86_64-apple-darwin-ar -r

CC_darwin_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_darwin -c
AS_darwin_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_darwin -c
LR_darwin_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_darwin -r
LD_darwin_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_darwin
AR_darwin_x86_gcc_qcc = $(QNX_HOST)/usr/bin/qcc -V$(gcc_ver_string)gcc_darwin -a

ifndef QCONF_OVERRIDE

CWD := $(shell $(PWD_HOST))
roots:=$(filter $(ROOT_DIR) cvs src qssl, $(subst /, ,$(CWD)))
ifneq ($(roots),)
root:=$(word $(words $(roots)), $(roots))
src_root := $(patsubst %/,%,$(subst !,/,$(dir $(subst !$(root)!,!$(root)/, $(subst /,!, $(CWD))))))
QCONF_OVERRIDE=$(src_root)/qconf-override.mk
endif
endif
ifneq ($(QCONF_OVERRIDE),)
-include $(QCONF_OVERRIDE)
endif