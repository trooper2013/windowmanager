/*
 SFUIWindowManager.m
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
#import "SFSDKWindowManager.h"
#import "SFSDKWindowContainer.h"
#import "SFSDKRootController.h"
//#import "SFApplicationHelper.h"
//#import "SFSecurityLockout.h"
@interface SFSDKWindowManager() {
    SFSDKWindowContainer *_prevActiveWindow;
    SFSDKWindowContainer *_currentWindow;
}
@property (nonatomic, strong) NSHashTable *delegates;

@end

@implementation SFSDKWindowManager

static const CGFloat SFWindowLevelAuthOffset      = 100;
static const CGFloat SFWindowLevelPasscodeOffset  = 120;
static const CGFloat SFWindowLevelSnapshotOffset  = 2000;
static NSString *const kSFMainWindowKey     = @"main";
static NSString *const kSFLoginWindowKey    = @"auth";
static NSString *const kSFSnaphotWindowKey  = @"snapshot";
static NSString *const kSFPasscodeWindowKey = @"passcode";

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _namedWindows = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                              valueOptions:NSMapTableStrongMemory];
        _delegates = [NSHashTable weakObjectsHashTable];

    }
    return self;
    
}

- (SFSDKWindowContainer *)mainWindow {
    if (![self.namedWindows objectForKey:kSFMainWindowKey]) {
        [self setMainUIWindow:[UIApplication sharedApplication].delegate.window];
    }
    return [self.namedWindows objectForKey:kSFMainWindowKey];
}

- (void)setMainUIWindow:(UIWindow *) window {
    SFSDKWindowContainer *container = [[SFSDKWindowContainer alloc] initWithWindow:window name:kSFMainWindowKey level:window.windowLevel];
    container.windowType = SFSDKWindowTypeMain;
    _prevActiveWindow = container;
    _currentWindow = container;
    [self.namedWindows setObject:container forKey:kSFMainWindowKey];
}

- (SFSDKWindowContainer *)authWindow {
    SFSDKWindowContainer *window = [self.namedWindows objectForKey:kSFLoginWindowKey];
    if (!window) {
        window = [self createAuthWindow];
    }
    return window;
}

- (SFSDKWindowContainer *)snapshotWindow {
    SFSDKWindowContainer *window = [self.namedWindows objectForKey:kSFSnaphotWindowKey];
    if (!window) {
        window = [self createSnapshotWindow];
    }
    return window;
}

- (SFSDKWindowContainer *)passcodeWindow {
    SFSDKWindowContainer *window = [self.namedWindows objectForKey:kSFPasscodeWindowKey];
    if (!window) {
        window = [self createPasscodeWindow];
    }
    return window;
}

- (SFSDKWindowContainer *)createNewNamedWindow:(NSString *)windowName {
    SFSDKWindowContainer * container = nil;
    if ( ![self isReservedName:windowName] ) {
        UIWindow *window = [self createDefaultUIWindow];
        container = [[SFSDKWindowContainer alloc] initWithWindow:window name:windowName level:UIWindowLevelNormal];
        container.windowType = SFSDKWindowTypeOther;
        [self.namedWindows setObject:container forKey:windowName];
    }
    return container;
}

- (BOOL)isReservedName:(NSString *) windowName {
    return ([windowName isEqualToString:kSFMainWindowKey] ||
            [windowName isEqualToString:kSFLoginWindowKey] ||
            [windowName isEqualToString:kSFPasscodeWindowKey] ||
            [windowName isEqualToString:kSFSnaphotWindowKey]);
    
}

- (BOOL)removeNamedWindow:(NSString *)windowName {
    BOOL result = NO;
    if (![self isReservedName:windowName]) {
        [self.namedWindows removeObjectForKey:windowName];
        result = YES;
    }
    return result;
}

- (SFSDKWindowContainer *)windowWithName:(NSString *)name {
    return [self.namedWindows objectForKey:name];
}

- (void)addDelegate:(id<SFWindowManagerDelegate>)delegate
{
    @synchronized (self) {
        [_delegates addObject:[NSValue valueWithNonretainedObject:delegate]];
    }
}

- (void)removeDelegate:(id<SFWindowManagerDelegate>)delegate
{
    @synchronized (self) {
        [_delegates removeObject:[NSValue valueWithNonretainedObject:delegate]];
    }
}

- (void)enumerateDelegates:(void (^)(id<SFWindowManagerDelegate> delegate))block
{
    @synchronized(self) {
        [_delegates.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<SFWindowManagerDelegate> delegate = [obj nonretainedObjectValue];
            if (delegate) {
                if (block) block(delegate);
            }
        }];
    }
}

#pragma mark - private methods
- (SFSDKWindowContainer *)createSnapshotWindow {
    UIWindow *window = [self createDefaultUIWindow];
    SFSDKWindowContainer *container = [[SFSDKWindowContainer alloc] initWithWindow:window name:kSFSnaphotWindowKey level:self.mainWindow.windowLevel + SFWindowLevelSnapshotOffset];
    container.windowType = SFSDKWindowTypeSnapshot;
    [self.namedWindows setObject:container forKey:kSFSnaphotWindowKey];
    return container;
}

- (SFSDKWindowContainer *)createAuthWindow {
    UIWindow *window = [self createDefaultUIWindow];
    SFSDKWindowContainer *container = [[SFSDKWindowContainer alloc] initWithWindow:window name:kSFLoginWindowKey level:self.mainWindow.windowLevel + SFWindowLevelAuthOffset];
    container.windowType = SFSDKWindowTypeAuth;
    [self.namedWindows setObject:container forKey:kSFLoginWindowKey];
    return container;
}

- (SFSDKWindowContainer *)createPasscodeWindow {
    UIWindow *window = [self createDefaultUIWindow];
    
    SFSDKWindowContainer *container = [[SFSDKWindowContainer alloc] initWithWindow:window name:kSFPasscodeWindowKey level:self.mainWindow.windowLevel + SFWindowLevelPasscodeOffset];
    container.windowType = SFSDKWindowTypePasscode;

    [self.namedWindows setObject:container forKey:kSFPasscodeWindowKey];
    return container;
}


-(UIWindow *)createDefaultUIWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [window setAlpha:0.0];
    window.rootViewController = [[SFSDKRootController alloc] init];
    return  window;
}

- (void)swapWindow:(SFSDKWindowContainer *)currentWindow withWindow:(SFSDKWindowContainer *)newWindow {
    __weak typeof(self) weakSelf = self;
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 curve:UIViewAnimationCurveEaseInOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf enumerateDelegates:^(id<SFWindowManagerDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(windowManager:willSwapWindwow:withWindow:)]){
                [delegate windowManager:strongSelf willSwapWindwow:currentWindow withWindow:newWindow];
            }
        }];
        
        [currentWindow disable];
        [newWindow enable];
        
        if (![newWindow isSnapshotWindow])
            strongSelf->_prevActiveWindow = newWindow;
        else
            strongSelf->_prevActiveWindow = currentWindow;
        
        [self updateKeyWindow];
        
        [strongSelf enumerateDelegates:^(id<SFWindowManagerDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(windowManager:didSwapWindwow:withWindow:)]){
                [delegate windowManager:strongSelf didSwapWindwow:currentWindow withWindow:newWindow];
            }
        }];
    }];
    [animator startAnimation];
}

- (BOOL)isKeyboard:(UIWindow *) window {
    return ([NSStringFromClass([window class]) hasPrefix:@"UIRemoteKeyboardWindow"]
            || [NSStringFromClass([window class])hasPrefix:@"UITextEffectsWindow"]);
}

- (void)updateKeyWindow {
    for (NSInteger i = [UIApplication sharedApplication].windows.count - 1; i >= 0; i--) {
        UIWindow *win = ([UIApplication sharedApplication].windows)[i];
        if (win.alpha == 0.0 || [self isKeyboard:win])
            continue;
        [win makeKeyWindow];
        break;
    }
}

- (SFSDKWindowContainer *) lastActiveWindow {
    return _prevActiveWindow;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token;
    static SFSDKWindowManager *sharedInstance = nil;
    dispatch_once(&token,^{
        sharedInstance = [[SFSDKWindowManager alloc]init];
    });
    return sharedInstance;
}
@end
