#import <UIKit/UIKit.h>

// Implemented in Swift (Sources/LGTestHarness.swift), looked up by name at runtime.
@interface LGTestHarness : NSObject
+ (void)show;
@end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Class harness = NSClassFromString(@"LGTestHarness");
        if (harness) {
            [(id)harness show];
        }
    });
}
%end
