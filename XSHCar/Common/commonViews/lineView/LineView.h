//
//  LineView.h
//  XSHCar
//
//  Created by jonz on 14-7-14.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

/**
 huaxian
 @param     titles  标题
 @param     points  坐标点
 @param     flag    日:0,月:1,年:2
 @return
 */

-(void)drawXCoors:(NSMutableArray*)Points title:(NSString*)titles flag:(int)flag;
@end
