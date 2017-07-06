//
//  STableViewCell.h
//  WindowManagerSample
//
//  Created by Raj Rao on 7/6/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STableViewDelegate <NSObject>

-(void) removeWindow:(NSString *) name;
-(void) bringToForeground:(NSString *) name;
@end

@interface STableViewCell : UITableViewCell

@property (weak,nonatomic) id<STableViewDelegate> cellDelegate;
@property (weak, nonatomic) IBOutlet UILabel *windowName;
- (IBAction)removeWindowAction:(id)sender;
- (IBAction)bringToForegroundAction:(id)sender;

@end
