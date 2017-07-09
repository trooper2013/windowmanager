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

@synthesize foregroundWindow = _foregroundWindow;
@synthesize snapshotWindow = _snapshotWindow;

- (instancetype) init {
    _namedWindows = [NSMutableDictionary new];
    //create a foregroundWindow
    SFUIWindowContainer *window = [[SFUIWindowContainer alloc] init];
    [_namedWindows setObject:window forKey:@"foreground"];
    
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

- (SFUIWindowContainer *)foregroundWindow {
    SFUIWindowContainer *window = [self.namedWindows objectForKey:@"foreground"];
    return window;
}

- (SFUIWindowContainer *)snapshotWindow {
    SFUIWindowContainer *window =[self.namedWindows objectForKey:@"snapshot"];
    if (!window) {
        return self.foregroundWindow;
    }
    return window;
}

- (void)setSnapshotWindow:(UIWindow *) window {
    SFUIWindowContainer *container = [[SFUIWindowContainer alloc] initWithWindow:window];
    [_namedWindows setValue:container forKey:@"snapshot"];
}

- (SFUIWindowContainer *)createNewNamedWindow:(NSString *)windowName {
    SFUIWindowContainer *window = [[SFUIWindowContainer alloc] init];
    if (![windowName isEqualToString:@"main"] && ![windowName isEqualToString:@"foreground"]) {
        [_namedWindows setValue:window forKey:windowName];
    }
    return window;
}


- (BOOL)removeNamedWindow:(NSString *)windowName {
    BOOL result = NO;
    if (![windowName isEqualToString:@"main"] && ![windowName isEqualToString:@"foreground"]) {
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
