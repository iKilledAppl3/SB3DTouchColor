GO_EASY_ONE_ME = 1
DEBUG = 0
PACKAGE_VERSION = 0.0.1
TARGET = iphone:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SB3DTouchColor
SB3DTouchColor_FILES = Tweak.xm
SB3DTouchColor_FRAMEWORKS = CoreGraphics QuartzCore UIKit
SB3DTouchColor_PRIVATE_FRAMEWORKS = SpringBoardUI
SB3DTouchColor_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = SB3DTouchColorSettings
SB3DTouchColorSettings_FILES = SB3DTouchColorPreferenceController.m NKOColorPickerView.m
SB3DTouchColorSettings_INSTALL_PATH = /Library/PreferenceBundles
SB3DTouchColorSettings_PRIVATE_FRAMEWORKS = Preferences
SB3DTouchColorSettings_FRAMEWORKS = CoreGraphics Social UIKit
SB3DTouchColorSettings_LDFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SB3DTouchColor.plist$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)
