ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = NotifyMeAgainPrefs
NotifyMeAgainPrefs_FILES = NotifyMeAgainPrefs.mm
NotifyMeAgainPrefs_INSTALL_PATH = /Library/PreferenceBundles
NotifyMeAgainPrefs_FRAMEWORKS = UIKit
NotifyMeAgainPrefs_PRIVATE_FRAMEWORKS = Preferences
NotifyMeAgainPrefs_CFLAGS = -fobjc-arc -w

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotifyMeAgainPrefs.plist$(ECHO_END)
