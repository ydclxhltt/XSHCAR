//
//  CommonHeader.h
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_CommonHeader_h
#define SmallPig_CommonHeader_h

#import "ProductInfoHeader.h"
#import "RequestHeader.h"
#import "DeviceHeader.h"

//导航条高度
#define NAV_HEIGHT                  64.0

//tabbar高度
#define TABBAR_HEIGHT               49.0

//设置字体大小
#define FONT(f)                     [UIFont systemFontOfSize:f]

//设置加粗字体大小
#define BOLD_FONT(f)                [UIFont boldSystemFontOfSize:f]

//设置RGB
#define RBGA(R,G,B,AL)              [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:AL]

#define RGB(R,G,B)                  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//界面背景颜色
#define  BASIC_VIEW_BG_COLOR        RGB(249.0,249.0,249.0)
//主色调
#define  APP_MAIN_COLOR             RGB(27.0,130.0,202.0)
//tabbar背景颜色
#define  TABBAR_BG_COLOR            RGB(12.0,97.0,152.0)
#endif
