//
//  CheckUpdateTool.h
//  XSHCar
//
//  Created by clei on 14/12/23.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUpdateTool : NSObject

/*
 *  检查更新
 *
 *  @pram isTip 是否显示loading提示
 */
+ (void)checkUpdateWithTip:(BOOL)isTip;

@end
