//
//  AppDelegate.m
//  WindowManagerSample
//
//  Created by Raj Rao on 7/5/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import "AppDelegate.h"
#import "SViewController.h"
#import "SFSDKWindowManager.h"
#import "SnapshotViewController.h"
@interface AppDelegate () {
    SnapshotViewController *_snapshotViewController;
    BOOL hasRenderedSnapshot;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    hasRenderedSnapshot = NO;
    [self setupAllWindows];
    [[SFSDKWindowManager sharedManager].mainWindow enable];
    return YES;
}

- (void) setupAllWindows {
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [[SFSDKWindowManager sharedManager] mainWindow].viewController = [[SViewController alloc] initWithWindowName:@"main" andViewName:@"View-1"];
    
    _snapshotViewController = [[SnapshotViewController alloc] init];
    [SFSDKWindowManager sharedManager].snapshotWindow.viewController  = _snapshotViewController;
    
    
    SViewController *authController = [[SViewController alloc] initWithWindowName:@"auth" andViewName:@"View-1"];
    SViewController *passcodeController = [[SViewController alloc] initWithWindowName:@"passcode" andViewName:@"View-1"];
    [SFSDKWindowManager sharedManager].passcodeWindow.viewController = passcodeController;
    [SFSDKWindowManager sharedManager].authWindow.viewController = authController;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    self->hasRenderedSnapshot = YES;
    [[SFSDKWindowManager sharedManager].snapshotWindow enable];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ( self->hasRenderedSnapshot ) {
          self->hasRenderedSnapshot = NO;
        [[SFSDKWindowManager sharedManager].snapshotWindow disable];
    }
}
@end
