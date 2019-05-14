#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import UIKit;
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    if(![FIRApp defaultApp]){
        [FIRApp configure];
    }
  return YES;
}

@end
