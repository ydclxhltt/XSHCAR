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

//违章查询
#define APP_KEY                     @"21dce05b4cee5accc6c2b197910a306d"
#define APP_ID                      @"63"

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

//loading默认加载提示
#define LOADING_DEFAULT_TIP         @"加载中..."

//loading默认加载成功提示
#define LOADING_SUCESS_TIP          @"加载成功"

//loading默认加载失败提示
#define LOADING_FAIL_TIP            @"加载失败"

//loading默认服务器异常提示
#define LOADING_WEBERROR_TIP        @"服务器异常"

//车况检查文字
#define CAR_CHECK_TIP               @"该OBD故障码适用于所有汽车制造商\n 新型汽车采用多阶段气囊来调节气囊内的压力。这个压力越大，气囊展开的强度就越大.\nA凸轮轴形面控制性能或卡在关闭位置 （第1排）\n躯干气囊和侧帘式气囊。侧躯干安全气囊从座椅或者门板位置展开，以对乘员的身体躯干提供保护。\n刹车助力器应用发动机进气系统（或者是专门的真空泵）产生的真空来协助制动。\nABS防抱死制动系统中，轮速传感器的作用是将车轮的速度以电信号的形式传送给控制模块.\n动态刹车控制（DBC）系统可以在急刹车情况下加强刹车的效果。。\n热氧传感器加热器控制电路 （第1排，传感器1）\n曲轴的作用是将活塞的的上下运动变成旋转运动。凸轮轴的作用是控制气门的开启和闭合.\n（在喷油嘴被广泛使用的新型汽车中，燃油量调节器已经很少被使用）"

//侧翻文字
#define ROLLOVER_ALARM_TIP          @"       车辆发生侧翻时,系统自动发送侧翻信息通知您的紧急联系人及自定义接收号码。\n\n提示:\n1,车辆侧翻角度大于60度.\n2,事故报告信息完整程度,取决于车型总线数据源.\n3,侧翻报警短信由用户自行承担短信资费.请随时关注您的短信使用情况."

//碰撞文字
#define COLLISION_WARNING_TIP       @"       车辆发生一定程度的碰撞时,系统自动发送碰撞信息通知您的紧急联系人及自定义接收号码.\n\n提示:\n1,车辆碰撞程度必须大于碰撞报警触发的临界程度.\n2,碰撞报告信息完整程度,取决于车型总线数据源.\n3,碰撞报警短信由用户自行承担短信资费.请随时关注您的短信使用情况."

#endif
