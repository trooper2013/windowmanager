/*
 SFUIWindowManager.h
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
#import "SFSDKWindowContainer.h"
@class SFSDKWindowManager;
/**
 Delegate of the SFSDKWindowManager
 */
@protocol SFWindowManagerDelegate <NSObject>

@optional
/**
 Called when the window is going to be brought to the front
 @param windowManager The window manager making this call
 @param window The window that is going to be brought to the front
 */
- (void)windowManager:(SFSDKWindowManager *_Nonnull)windowManager
      willSwapWindwow:(SFSDKWindowContainer *_Nonnull)window withWindow:(SFSDKWindowContainer *_Nonnull)window;

/**
 Called when the window is going to be brought to the front
 @param windowManager The window manager making this call
 @param window The window that is going to be brought to the front
 */
- (void)windowManager:(SFSDKWindowManager *_Nonnull)windowManager
      didSwapWindwow:(SFSDKWindowContainer *_Nonnull)window withWindow:(SFSDKWindowContainer *_Nonnull)window;
@end

@interface SFSDKWindowManager : NSObject

/** SDK uses this window to present the login flow.
 */
@property (readonly,nonatomic,strong) SFSDKWindowContainer * _Nonnull authWindow;

/** SDK uses this window to present the snapshot View.
 */
@property (readonly,nonatomic,strong) SFSDKWindowContainer * _Nonnull snapshotWindow;

/** SDK uses this window to present the passocde View.
 */
@property (readonly,nonatomic,strong) SFSDKWindowContainer * _Nonnull passcodeWindow;

/** Returns the SFSDKWindowContainer window representing the mainWindow that has been set
 */
@property (readonly,nonatomic,strong) SFSDKWindowContainer * _Nonnull mainWindow;

/** List all managed Windows
 */
@property (nonatomic, strong,readonly) NSMapTable<NSString *,SFSDKWindowContainer *> * _Nonnull namedWindows;

/** Used to setup the main application window.
 */
- (void)setMainUIWindow:(UIWindow *_Nonnull)window;

/** Used to create a new Window keyed by a  specified name
 */
- (SFSDKWindowContainer *_Nonnull)createNewNamedWindow:(NSString *_Nonnull)windowName;

/** Used to remove a  Window by a  specified name
 */
- (BOOL)removeNamedWindow:(NSString *_Nonnull)windowName;

/** Used to retrieve a Window by a  specified name
 */
- (SFSDKWindowContainer *_Nullable)windowWithName:(NSString *_Nonnull)name;

/** Swap out one window with another
 */
- (void)swapWindow:(SFSDKWindowContainer *_Nonnull)currentWindow withWindow:(SFSDKWindowContainer *_Nonnull)newWindow;

/** Get previously active window
 */
 - (SFSDKWindowContainer *_Nullable)lastActiveWindow;

/** Add a Window Manager Delegate
 */
- (void)addDelegate:(id<SFWindowManagerDelegate>_Nonnull)delegate;

/** Remove a Window Manager Delegate
 */
- (void)removeDelegate:(id<SFWindowManagerDelegate>_Nonnull)delegate;

+ (instancetype _Nonnull )sharedManager;

@end
