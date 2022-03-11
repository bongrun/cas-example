#import "CasPlugin.h"
#if __has_include(<cas/cas-Swift.h>)
#import <cas/cas-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cas-Swift.h"
#endif

@implementation CasPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCasPlugin registerWithRegistrar:registrar];
}
@end
