//
//  AdvView.h
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ADV_HEIGHT 150.0

@interface AdvView : UIView

@property(nonatomic,retain)NSMutableArray *advarray;

-(void)setAdvData:(id)advdata ;
@end
