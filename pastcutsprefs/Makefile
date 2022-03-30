ARCHS = arm64 arm64e
TARGET = iphone:clang:14.8.1:13.0
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PastcutsPrefs

PastcutsPrefs_FILES = ZLTCRootListController.m
PastcutsPrefs_FRAMEWORKS = UIKit
PastcutsPrefs_PRIVATE_FRAMEWORKS = Preferences
PastcutsPrefs_INSTALL_PATH = /Library/PreferenceBundles
PastcutsPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
