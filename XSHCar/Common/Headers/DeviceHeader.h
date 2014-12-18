//
//  DeviceHeader.h
//  SmallPig
//
//  Created by chenlei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_DeviceHeader_h
#define SmallPig_DeviceHeader_h

//屏幕宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//屏幕高度
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

//设备型号
#define DEVICE_MODEL [[UIDevice currentDevice] model]

//分辨率
#define DEVICE_RESOLUTION  [NSString stringWithFormat:@"%.0f*%.0f", SCREEN_WIDTH * [[UIScreen mainScreen] scale], SCREEN_HEIGHT * [[UIScreen mainScreen] scale]]

//系统版本
#define DEVICE_SYSTEM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]


#endif
