//
//  STableViewCell.m
//  WindowManagerSample
//
//  Created by Raj Rao on 7/6/17.
//  Copyright © 2017 Raj Rao. All rights reserved.
//

#import "STableViewCell.h"

@implementation STableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)removeWindowAction:(id)sender {
    if ([self.cellDelegate respondsToSelector:@selector(removeWindow:)]) {
        [self.cellDelegate removeWindow:self.windowName.text];
    }
}

- (IBAction)bringToForegroundAction:(id)sender {
    if ([self.cellDelegate respondsToSelector:@selector(bringToForeground:)]) {
        [self.cellDelegate bringToForeground:self.windowName.text];
    }
}
@end
