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
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[SViewController alloc] initWithWindowName:@"main" andViewName:@"View-1"];
    [[SFSDKWindowManager sharedManager] setMainUIWindow:self.window];
    
//    [self.window makeKeyAndVisible];
    
    //initialize main window
    
//    
//    // initialize our auth view - window
//     SViewController *authController = [[SViewController alloc] initWithWindowName:@"auth" andViewName:@"View-1"];
//
//    SViewController *passcodeController = [[SViewController alloc] initWithWindowName:@"passcode" andViewName:@"View-1"];
    
    _snapshotViewController = [[SnapshotViewController alloc] init];
//
//    [[SFSDKWindowManager sharedManager].mainWindow pushViewController:self.window.rootViewController];
   // [[SFSDKWindowManager sharedManager].authWindow pushViewController:authController];
    //[[SFSDKWindowManager sharedManager].passcodeWindow pushViewController:passcodeController];
    SFSDKWindowContainer *authWindow = [SFSDKWindowManager sharedManager].authWindow;
    SFSDKWindowContainer *passcodeWindow = [SFSDKWindowManager sharedManager].passcodeWindow;
    [[SFSDKWindowManager sharedManager] bringToFront:SFSDKWindowManager.sharedManager.mainWindow];
   // [self.window makeKeyAndVisible];
//
////    [[SFSDKWindowManager sharedManager] pushViewController:authController window:SFSDKWindowManager.sharedManager.authWindow withCompletion:^{
////        [[SFSDKWindowManager sharedManager] pushViewController:passcodeController window:SFSDKWindowManager.sharedManager.passcodeWindow withCompletion:^{
////            [[SFSDKWindowManager sharedManager] bringToFront:SFSDKWindowManager.sharedManager.mainWindow];
////        }];
////    }];
//    
//    
//    //set custom SnapshotView
    
    
   
    
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[SFSDKWindowManager sharedManager] pushViewController:_snapshotViewController window:SFSDKWindowManager.sharedManager.snapshotWindow withCompletion:^{
         self->hasRenderedSnapshot = YES;
    }];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ( self->hasRenderedSnapshot ) {
        [[SFSDKWindowManager sharedManager] popViewController:_snapshotViewController window:SFSDKWindowManager.sharedManager.snapshotWindow withCompletion:^{
            self->hasRenderedSnapshot  = NO;
            [SFSDKWindowManager.sharedManager restorePreviousActiveWindow];
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
