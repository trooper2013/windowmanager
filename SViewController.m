//
//  SViewController.m
//  WindowManagerSample
//
//  Created by Raj Rao on 7/5/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import "SViewController.h"
#import "STableViewCell.h"
#import "SFSDKWindowManager.h"
@interface SViewController ()<UITableViewDelegate,UITableViewDataSource,STableViewDelegate,UITextViewDelegate>{
    NSString *_windowName;
    NSString *_viewName;
    NSMutableArray *_windowList;
}
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic)IBOutlet UILabel *nameOfCurrentWindow;
@property (weak, nonatomic)IBOutlet UILabel *cnameOfCurrentView;
@property (weak, nonatomic)IBOutlet UITableView *tableView;

- (IBAction)refreshWindows:(id)sender;

- (IBAction)pushView:(id)sender;
- (IBAction)popView:(id)sender;
- (IBAction)newWindow:(id)sender;
@end

@implementation SViewController

- (instancetype)initWithWindowName:(NSString *) windowName andViewName:(NSString *) viewName {
    self = [super initWithNibName:@"SViewController" bundle:nil];
    
    if (self) {
        _windowName = windowName;
        _viewName = viewName;
     
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nameOfCurrentWindow.text = _windowName;
    self.cnameOfCurrentView.text = _viewName;
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated {
     [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshWindows:(id)sender {
     [self reloadData];
}

-(UIViewController *)topViewController:(UIViewController *) controller
{
    UIViewController *topViewController = controller;
    while (topViewController.presentedViewController != nil
           && !topViewController.presentedViewController.isBeingDismissed) {
        //stop if we find that an alert has been presented
        if ([topViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            break;
        }
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}


- (IBAction)pushView:(id)sender {
    NSString *nextViewName = [SViewController getNextName:_viewName];
    SFSDKWindowContainer * window=[[SFSDKWindowManager sharedManager] windowWithName:_windowName];
    SViewController *nextController = [[SViewController alloc] initWithWindowName:_windowName andViewName:nextViewName];
    
    UIViewController *topViewController = [self topViewController:window.viewController];
    [topViewController presentViewController:nextController animated:NO completion:nil];
}

- (IBAction)popView:(id)sender {
    //add protection to avoid removing a rootView
    if (![SViewController isRootView:_viewName]) {
        SFSDKWindowContainer * window= [[SFSDKWindowManager sharedManager] windowWithName:_windowName];
         UIViewController *topViewController = [self topViewController:window.viewController];
         [topViewController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (IBAction)newWindow:(id)sender {
    
    NSString *nextWindowName = [SViewController getNextWindowName:_windowName];
    SFSDKWindowContainer *currentWindow = [[SFSDKWindowManager sharedManager] windowWithName:_windowName];
    SFSDKWindowContainer *newWindow = [[SFSDKWindowManager sharedManager] createNewNamedWindow:nextWindowName];
    [self reloadData];
    SViewController *nextController = [[SViewController alloc] initWithWindowName:nextWindowName andViewName:@"View-1"];
    newWindow.viewController = nextController;
    [[SFSDKWindowManager sharedManager] swapWindow:currentWindow withWindow:newWindow];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"MyTableCell";
    STableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"STableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.cellDelegate = self;
    }
    cell.windowName.text = [_windowList objectAtIndex:indexPath.row];
    if ( [cell.windowName.text isEqualToString:@"auth"] || [cell.windowName.text isEqualToString:@"passcode"]) {
        cell.removeButton.enabled = NO;
    } else  if ([cell.windowName.text isEqualToString:@"snapshot"]) {
         cell.foregroundButton.enabled = NO;
         cell.removeButton.enabled = NO;
    } else {
         cell.removeButton.enabled = YES;
         cell.foregroundButton.enabled = YES;
    }
                
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_windowList count];
}

- (void)reloadData {
    _windowList = [NSMutableArray new];
   [[[SFSDKWindowManager sharedManager].namedWindows.keyEnumerator allObjects] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [_windowList addObject:obj];
   }];
   [[self tableView] reloadData];
}

- (void)removeWindow:(NSString *) name {
    NSLog(@"removeWindow  Called: %@",name );
    [[SFSDKWindowManager sharedManager] removeNamedWindow:name];
    [self reloadData];
}

- (void)bringToForeground:(NSString *) name {
    NSLog(@"bringToForeground  Called: %@",name );
    SFSDKWindowContainer *window = [[SFSDKWindowManager sharedManager] windowWithName:name];
    SFSDKWindowContainer *currentWindow = [[SFSDKWindowManager sharedManager] windowWithName:_windowName];
    [[SFSDKWindowManager sharedManager] swapWindow:currentWindow withWindow:window];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing  Called:" );
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"textViewDidEndEditing  Called:" );
}

+ (NSString *)getNextName :(NSString *) name {
    NSUInteger index = [name rangeOfString:@"-"].location;
    NSUInteger value = [name substringFromIndex:index +1].integerValue;
    NSMutableString *result = [NSMutableString new];
    [result appendFormat:@"%@-%lu", [name substringToIndex:index], value + 1 ];
    return result;
}

+ (BOOL)isRootView :(NSString *) name {
    NSUInteger index = [name rangeOfString:@"-"].location;
    NSUInteger value = [name substringFromIndex:index +1].integerValue;
    return value <= 1;
}

+(NSString *) getNextWindowName:(NSString *) name {
    NSString *nextWindowName = @"Window";
    NSUInteger count = [[SFSDKWindowManager sharedManager] namedWindows].count;
    NSMutableString *result = [NSMutableString new];
    [result appendFormat:@"%@-%lu", nextWindowName, count + 1 ];
    return result;
}


@end
