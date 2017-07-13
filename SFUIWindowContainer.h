//
//  SFUIWindowContainer.h
//  ViewControllerPushPop
//
//  Created by Raj Rao on 7/4/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SFRootViewManager

- (void)pushViewController:(UIViewController *)controller;

- (void)popViewController:(UIViewController *)controller;

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)flag completion:(void (^)(void))completion;

- (void)popViewController:(UIViewController *)controller animated:(BOOL)flag completion:(void (^)(void))completion;

@end


@interface SFUIWindowContainer : NSObject<SFRootViewManager>

- (void)bringToFront;

- (void)sendToBack;

- (instancetype)initWithWindow:(UIWindow *) window;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic) UIWindowLevel windowLevel;

@end
