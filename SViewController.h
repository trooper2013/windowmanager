//
//  SViewController.h
//  WindowManagerSample
//
//  Created by Raj Rao on 7/5/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIStepper *zoomControl;
- (IBAction)zoomAction:(id)sender;

- (instancetype)initWithWindowName:(NSString *) windowName andViewName:(NSString *) viewName;

@end
