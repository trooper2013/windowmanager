//
//  SFUIWindowManager.h
//  ViewControllerPushPop
//
//  Created by Raj Rao on 7/4/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SFUIWindowContainer.h"

@interface SFUIWindowManager : NSObject

@property(readonly,strong) SFUIWindowContainer *authWindow;

@property(readonly,nonatomic,strong) SFUIWindowContainer *snapshotWindow;

@property(readonly,nonatomic,strong) SFUIWindowContainer *passcodeWindow;

@property(nonatomic,strong) UIViewController *snapshotViewController;

- (SFUIWindowContainer *)mainApplicationWindow;
- (void)setMainApplicationWindow:(UIWindow *) window;

- (SFUIWindowContainer *)createNewNamedWindow:(NSString *) windowName;
- (BOOL)removeNamedWindow:(NSString *) windowName;
- (SFUIWindowContainer *)windowWithName:(NSString *) name;

- (NSDictionary<NSString *,SFUIWindowContainer *> *)namedWindows;

- (void)bringToFront:(NSString *) windowName;



+ (instancetype)sharedInstance;

@end
