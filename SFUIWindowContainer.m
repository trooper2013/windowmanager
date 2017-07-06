//
//  SFUIWindowContainer.m
//  ViewControllerPushPop
//
//  Created by Raj Rao on 7/4/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import "SFUIWindowContainer.h"
#import "SFUIWindowManager.h"

@implementation SFUIWindowContainer {
    UIViewController *_modalViewController;
}

@synthesize window = _window;

- (instancetype)initWithWindow:(UIWindow *)window {
    
    self = [super init];
    if (self) {
        _window = window;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)controller {
    [self pushViewController:controller animated:NO completion:nil];
}

- (void)popViewController:(UIViewController *)controller {
    [self popViewController:controller animated:NO completion:nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {

    if (!viewController)
        return;

    UIViewController *currentViewController = self.window.rootViewController;
    while (currentViewController.presentedViewController != nil
            && !currentViewController.presentedViewController.isBeingDismissed) {
        //stop if we find that an alert has been presented
        if ([self alertIsPresented:currentViewController]) {
            [self saveAlert:currentViewController.presentedViewController];
            break;
        }
        currentViewController = currentViewController.presentedViewController;
    }
    if (currentViewController) {
        //invoke delegates and then present
        if (currentViewController!=viewController)
            [currentViewController presentViewController:viewController animated:NO completion:completion];
    }
    else {
        self.window.rootViewController = viewController;
        completion();
    }

}

- (void)popViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
   
    if (!viewController)
        return;
    
    UIViewController *currentViewController = self.window.rootViewController;
    if (currentViewController != viewController) {
        // look for controller
        while (currentViewController && currentViewController.presentedViewController!=viewController) {
            currentViewController = currentViewController.presentedViewController;
        }
        // if controller is found dismiss the view, invoke delegates && restore Alerts if required.
        if (viewController == currentViewController.presentedViewController) {
            [self dismissPresentedViewController:currentViewController dismissViewControllerAnimated:flag completion:completion] ;
        }
    } else {
        self.window.rootViewController = nil;
        completion();
    }

}

- (void)bringToFront {
    self.window.windowLevel = UIWindowLevelAlert  + 1;
    [self.window makeKeyAndVisible];
}

- (void)sendToBack {
    self.window.windowLevel = UIWindowLevelNormal - 1;
}

// private members

- (BOOL)alertWasPresent{
    return self->_modalViewController?YES:NO;
}

- (BOOL)alertIsPresented:(UIViewController *) current {
    return [current.presentedViewController isKindOfClass:[UIAlertController class]];
}

- (void)saveAlert:(UIViewController *) alert {
    self ->_modalViewController = alert;
    [alert dismissViewControllerAnimated:NO completion:nil];
}

- (void)restoreAlert:(UIViewController *) presentingViewController {
    [presentingViewController presentViewController:self->_modalViewController  animated:NO completion:^{
        self ->_modalViewController = nil;
    }];
}

- (void)presentViewController:(UIViewController *)toBePresented using:(UIViewController *)presentingViewController {
    [presentingViewController presentViewController:toBePresented animated:NO completion:nil];
}

- (void)dismissPresentedViewController :(UIViewController *)presentingViewController dismissViewControllerAnimated:(BOOL) animate completion:(void(^)(void)) completion {
    __weak typeof (self) weakSelf = self;
    [presentingViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([strongSelf alertWasPresent]) {
            [strongSelf restoreAlert:presentingViewController];
        }
        completion();
    }];
}

@end
