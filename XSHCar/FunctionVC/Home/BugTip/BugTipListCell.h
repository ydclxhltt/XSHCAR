//
//  BugTipListCell.h
//  XSHCar
//
//  Created by chenlei on 14/12/24.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BugTipListCell : UITableViewCell

/*
 *  设置label数据
 *
 *  @pram title     异常title（smsName）
 *  @pram content   异常title（smsinforContent）
 */
- (void)setLabelTextWithTitle:(NSString *)title contentText:(NSString *)content;

@end
