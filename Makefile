ARCHS = arm64 arm64e
TARGET = iphone:clang:14.8.1:13.0
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Pastcuts

Pastcuts_FILES = Tweak.xm
Pastcuts_CFLAGS = -fobjc-arc
Pastcuts_EXTRA_FRAMEWORKS += Cephei
Pastcuts_PRIVATE_FRAMEWORKS += WorkflowKit

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += pastcutsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
