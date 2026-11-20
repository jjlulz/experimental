# Swift runtime ships inside iOS 12.2+, so target 12.2 (the iPod touch 6th gen tops out at 12.5.x).
TARGET := iphone:clang:latest:12.2
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassKit12

LiquidGlassKit12_FILES = Tweak.x $(wildcard Sources/*.swift)
LiquidGlassKit12_CFLAGS = -fobjc-arc
LiquidGlassKit12_SWIFTFLAGS = -swift-version 5
LiquidGlassKit12_FRAMEWORKS = UIKit QuartzCore CoreGraphics CoreVideo Metal MetalKit MetalPerformanceShaders
LiquidGlassKit12_LDFLAGS = -Xlinker -rpath -Xlinker /usr/lib/swift

include $(THEOS_MAKE_PATH)/tweak.mk
