//
//  XSH_Application.h
//  XSHCar
//
//  Created by clei on 14/12/19.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSH_Application : NSObject

@property(nonatomic, strong) NSDictionary *loginDic;
@property(nonatomic, assign) int shopID;
@property(nonatomic, assign) int userID;

/*
 *  初始化
 *
 *  @return 单例类
 */
+ (id)shareXshApplication;
@end