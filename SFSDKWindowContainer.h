/*
 SFSDKWindowContainer.h
 SalesforceSDKCore
 
 Created by Raj Rao on 7/4/17.
 
 Copyright (c) 2017-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SFSDKWindowType) {
    SFSDKWindowTypeMain,
    SFSDKWindowTypeAuth,
    SFSDKWindowTypePasscode,
    SFSDKWindowTypeSnapshot,
    SFSDKWindowTypeOther
};
@class SFSDKWindowContainer;

@protocol SFSDKWindowContainerDelegate<NSObject>

@optional

/**
 Called when the window is going to be made key & visible
 @param window The window that is going to be made key & visible
 */
- (void)windowEnable:(SFSDKWindowContainer *_Nonnull)window animated:(BOOL)animated withCompletion:(void (^)(void))completion;

/**
 Called when the window was made key & visible
 @param window The window that was made key & visible
 */
- (void)windowDisable:(SFSDKWindowContainer *_Nonnull)window animated:(BOOL)animated withCompletion:(void (^)(void))completion;


@end

@interface SFSDKWindowContainer : NSObject
/** Underlying Window that is wrapped by this container
 */
@property (nonatomic, strong) UIWindow * _Nullable window;

/** UIWindowLevel for the window
 */
@property (nonatomic, assign) UIWindowLevel windowLevel;

/** SFSDKWindowType for the window
 */
@property (nonatomic, assign) SFSDKWindowType windowType;

/** SFSDKWindowType windowName
 */
@property (nonatomic, copy, readonly) NSString * _Nonnull windowName;

/** UIViewController viewController
 */
@property (nonatomic, strong) UIViewController * _Nullable viewController;

/**
 */
@property (nonatomic, weak) id <SFSDKWindowContainerDelegate> _Nullable windowDelegate;
/**
 Create an instance of a Window
 @param window An instance of UIWindow
 @param windowName key for the UIWindow
 @return SFSDKWindowComtainer
 */
- (instancetype _Nonnull )initWithWindow:(UIWindow *_Nonnull)window name:(NSString *_Nonnull) windowName level:(UIWindowLevel)level;
/**
 * Make window visible
 */
- (void)enable;

- (BOOL)isEnabled;

/**
 * Make window visible
 */
- (void)enable:(BOOL)animated withCompletion:(void (^)(void))completion;


/**
 * Make window visible
 */
- (void)disable:(BOOL)animated withCompletion:(void (^)(void))completion;

/**
 * Make window invisible
 */
- (void)disable;

/** Convenience API returns true if the SFSDKWindowType is main
 * @return YES if this is the main Window
 */
- (BOOL)isMainWindow;

/** Convenience API returns true if the SFSDKWindowType is auth
 * @return YES if this is the auth Window
 */
- (BOOL)isAuthWindow;

/** Convenience API returns true if the SFSDKWindowType is snapshot
 * @return YES if this is the snapshot Window
 */
- (BOOL)isSnapshotWindow;

/** Convenience API returns true if the SFSDKWindowType is passcode
 * @return YES if this is the passcode Window
 */
- (BOOL)isPasscodeWindow;


@end
