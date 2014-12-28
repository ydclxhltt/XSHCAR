//
//  CityListViewController.h
//  XSHCar
//
//  Created by clei on 14/11/19.
//  Copyright (c) 2014年 john. All rights reserved.
//

typedef enum : NSUInteger
{
    CityScourceFromThird,
    CityScourceFromXSH,
} CityScource;

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface CityListViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, assign) CityScource cityScource;
@property(nonatomic, assign) int smsID;
@property(nonatomic, assign) int ussID;
@end
