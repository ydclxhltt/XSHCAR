//
//  BreakCell.h
//  XSHCar
//
//  Created by clei on 14/11/19.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreakCell : UITableViewCell
@property(nonatomic,retain)    UILabel *titleLabel;
@property(nonatomic,retain)    UILabel *descLabel;
- (void)setDescLabelFrame;
@end
