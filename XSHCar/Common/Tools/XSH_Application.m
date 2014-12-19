//
//  XSH_Application.m
//  XSHCar
//
//  Created by clei on 14/12/19.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "XSH_Application.h"


@implementation XSH_Application

static XSH_Application *xsh = nil;

//初始化
+ (XSH_Application *)shareXshApplication
{
    if (!xsh)
    {
        xsh = [[XSH_Application alloc] init];
    }
    return xsh;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


@end
