//
//  AppDelegate.h
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
 *  添加登录界面视图
 *
 *  @pram isAnimation 是否有动画
 */
- (void)addLoginViewWithAnimation:(BOOL)isAnimation;

@end
