export ARCHS = armv7 arm64

TARGET_CODESIGN_FLAGS = -S$(THEOS_PROJECT_DIR)/entitlements.plist

include theos/makefiles/common.mk

TWEAK_NAME = NotifyMeAgain
NotifyMeAgain_FILES = Tweak.xm
NotifyMeAgain_FRAMEWORKS = UIKit
NotifyMeAgain_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += notifymeagainprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
