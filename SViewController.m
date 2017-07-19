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
@interface SViewController ()<UITableViewDelegate,UITableViewDataSource,STableViewDelegate> {
    NSString *_windowName;
    NSString *_viewName;
    
}
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nameOfCurrentWindow.text = _windowName;
    self.cnameOfCurrentView.text = _viewName;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated{
    
}
- (void)viewDidAppear:(BOOL)animated {
     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshWindows:(id)sender {
     [self.tableView reloadData];
}

- (IBAction)pushView:(id)sender {
    NSString *nextViewName = [SViewController getNextName:_viewName];
    SFSDKWindowContainer * window=[[SFSDKWindowManager sharedManager] windowWithName:_windowName];
    SViewController *nextController = [[SViewController alloc] initWithWindowName:_windowName andViewName:nextViewName];
    [window pushViewController:nextController animated:NO completion:^{
        
    }];
}

- (IBAction)popView:(id)sender {
    //add protection to avoid removing a rootView
    if (![SViewController isRootView:_viewName]) {
        SFSDKWindowContainer * window= [[SFSDKWindowManager sharedManager] windowWithName:_windowName];
        [window popViewController:self animated:NO completion:^{
            
        }];
    }
}

- (IBAction)newWindow:(id)sender {
    
    NSString *nextWindowName = [SViewController getNextWindowName:_windowName];
    SFSDKWindowContainer *newWindow = [[SFSDKWindowManager sharedManager] createNewNamedWindow:nextWindowName];
    
    SViewController *nextController = [[SViewController alloc] initWithWindowName:nextWindowName andViewName:@"View-1"];
    
    [newWindow pushViewController:nextController animated:NO completion:^{
        
    }];
    [[self tableView] reloadData];
    [[SFSDKWindowManager sharedManager] bringToFront:newWindow];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"MyTableCell";
    STableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"STableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.cellDelegate = self;
    }
    
    cell.windowName.text = [SFSDKWindowManager sharedManager].namedWindows.allKeys[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[SFSDKWindowManager sharedManager].namedWindows.allKeys count];
}

- (void)removeWindow:(NSString *) name {
    NSLog(@"removeWindow  Called: %@",name );
    [[SFSDKWindowManager sharedManager] removeNamedWindow:name];
    [[self tableView] reloadData];
}

- (void)bringToForeground:(NSString *) name {
    NSLog(@"bringToForeground  Called: %@",name );
    SFSDKWindowContainer *window = [[SFSDKWindowManager sharedManager] windowWithName:name];
    [[SFSDKWindowManager sharedManager] bringToFront:window];
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
