//
//  MetalViewAppDelegate.mm
//  MetalExample
//
//  Created by Brent on 6/1/20.
//  Copyright © 2020 James Hughes. All rights reserved.
//

#import "MetalViewApplication.h"

#import "MetalViewController.h"

#import <Foundation/Foundation.h>

@implementation MetalViewAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  self.window.backgroundColor = [UIColor whiteColor];

  self.window.rootViewController = [[MetalViewController alloc] init];
  [self.window makeKeyAndVisible];

  return YES;
}

@end

int main(int argc, char *argv[])
{
  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([MetalViewAppDelegate class]));
  }
}