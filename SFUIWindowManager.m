//
//  SFUIWindowManager.m
//  ViewControllerPushPop
//
//  Created by Raj Rao on 7/4/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import "SFUIWindowManager.h"
#import "SFUIWindowContainer.h"
@interface SFUIWindowManager() {
    NSMutableDictionary<NSString *,SFUIWindowContainer *> *_namedWindows;
}

@end

@implementation SFUIWindowManager

static  CGFloat SFWindowLevelAuth = 10000;
static  CGFloat SFWindowLevelPasscode = 10001;
static  CGFloat SFWindowLevelSnapshot = 10002;

@synthesize authWindow = _authWindow;
@synthesize snapshotWindow = _snapshotWindow;
@synthesize passcodeWindow = _passcodeWindow;


- (instancetype) init {
    _namedWindows = [NSMutableDictionary new];
    
    // these can be lazily created
    [self createAuthWindow];
    [self createPasscodeWindow];
    [self createSnapshotWindow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackground) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleForeground) name:UIApplicationDidBecomeActiveNotification object:nil];

       
    return self;
}

- (SFUIWindowContainer *)mainApplicationWindow {
    return [self.namedWindows objectForKey:@"main"];
}

- (void)setMainApplicationWindow:(UIWindow *) window {
    SFUIWindowContainer *container = [[SFUIWindowContainer alloc] initWithWindow:window];
    [_namedWindows setValue:container forKey:@"main"];
}

- (SFUIWindowContainer *)authWindow {
    SFUIWindowContainer *window = [self.namedWindows objectForKey:@"auth"];
    if (!window) {
        window = [self createAuthWindow];
    }
    return window;
}

- (SFUIWindowContainer *)snapshotWindow {
    SFUIWindowContainer *window =[self.namedWindows objectForKey:@"snapshot"];
    if (!window) {
        window = [self createSnapshotWindow];
    }
    return window;
}

- (SFUIWindowContainer *)createSnapshotWindow{
    SFUIWindowContainer *container = [[SFUIWindowContainer alloc] init];
    container.windowLevel = SFWindowLevelSnapshot;
    [_namedWindows setValue:container forKey:@"snapshot"];
    return container;
}

- (SFUIWindowContainer *)passcodeWindow {
    SFUIWindowContainer *window =[self.namedWindows objectForKey:@"passcode"];
    if (!window) {
        window = [self createPasscodeWindow];
    }
    return window;
}

- (SFUIWindowContainer *)createAuthWindow{
    SFUIWindowContainer *container = [[SFUIWindowContainer alloc] init];
    container.windowLevel = SFWindowLevelAuth;
    [_namedWindows setValue:container forKey:@"auth"];
    return container;
}

- (SFUIWindowContainer *)createPasscodeWindow{
    SFUIWindowContainer *container = [[SFUIWindowContainer alloc] init];
    container.windowLevel = SFWindowLevelPasscode;
    [_namedWindows setValue:container forKey:@"passcode"];
    return container;
}

- (SFUIWindowContainer *)createNewNamedWindow:(NSString *)windowName {
    SFUIWindowContainer *window = [[SFUIWindowContainer alloc] init];
    if (![windowName isEqualToString:@"main"] && ![windowName isEqualToString:@"auth"]) {
        [_namedWindows setValue:window forKey:windowName];
    }
    return window;
}

- (BOOL)removeNamedWindow:(NSString *)windowName {
    BOOL result = NO;
    if (![windowName isEqualToString:@"main"] && ![windowName isEqualToString:@"auth"]) {
        [_namedWindows removeObjectForKey:windowName];
        result = YES;
    }
    return result;
}

- (NSDictionary<NSString *, SFUIWindowContainer *> *)namedWindows {
    if (!_namedWindows) {
        _namedWindows  = [[NSMutableDictionary alloc] init];
    }
    return _namedWindows;
}

- (SFUIWindowContainer *)windowWithName:(NSString *) name {
    return [_namedWindows objectForKey:name];
}

- (void)bringToFront:(NSString *) windowName {
    NSDictionary<NSString *, SFUIWindowContainer *> *windows = [self namedWindows];
    for ( NSString *wName in windows.allKeys ) {
        SFUIWindowContainer *wContainer = [windows valueForKey:wName];
        if ( [wName isEqualToString:windowName] ) {
            [wContainer bringToFront];
        } else {
            [wContainer sendToBack];
        }
    }
}

- (void) handleBackground {
    [[SFUIWindowManager sharedInstance].snapshotWindow  bringToFront];
    [[SFUIWindowManager sharedInstance].snapshotWindow pushViewController:self.snapshotViewController animated:YES completion:^{
    }];
}

- (void) handleForeground {
    if (self.snapshotViewController) {
        [[SFUIWindowManager sharedInstance].snapshotWindow popViewController:self.snapshotViewController animated:YES completion:^{
            [[SFUIWindowManager sharedInstance].mainApplicationWindow bringToFront];
        }];
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t token;
    static SFUIWindowManager *sharedInstance = nil;
    dispatch_once(&token,^{
        sharedInstance = [[SFUIWindowManager alloc]init];
    });
    return sharedInstance;
}
@end
