//
//  RequestHeader.h
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_RequestHeader_h
#define SmallPig_RequestHeader_h

//服务器地址
#define WEB_SERVER_URL           @"http://pcnew.xshcar.com:9988/"

//图片地址
#define IMAGE_SERVER_URL         @"http://pcnew.xshcar.com:9988/carcloud/image/icon/"
//#define IMAGE_SERVER_URL1       @"http://pcnew.xshcar.com:9988/carcloud/image/icon"

//登陆地址
#define LOGIN_URL               [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!login"]

//获取验证码
#define GET_CODE_URL            [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!getValidateCode"]

//忘记密码
#define COMMIT_PASSWORD_URL     [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!updatePwd"]

//更新地址
#define CHECK_UPDATE_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!getVersion"]

//注册
#define REGISTER_URL            [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!userAdd"]

//获取4S
#define GET_4S_SHOP_URL         [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!getCarShop"]

//一键救援地址
#define KEY_RESCUE_URL          [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!keyRescue"]

//预约获取个人信息
#define BOOKING_PERSONAL_URL    [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!appponitment"]

//提交预约信息
#define BOOKING_COMMIT_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!addAppointment"]

//精彩活动
#define EXCITING_LIST_URL       [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!getMessagedetail"]

//移动商城
#define MOBILE_STORE_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!shopmall"]

//故障提示
#define TROUBLE_TIPS_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!troubleTips"]

//车况检查
#define CAR_CHECK_URL           [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!medicalCondition"]

//消息管理状态
#define MESSAGE_MANAGE_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!getUserSetSms"]

//更新消息状态
#define MESSAGE_UPDATE_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!addAndUpdateSms"]

//城市列表
#define CITY_LIST_URL           @"http://www.cheshouye.com/api/weizhang/get_all_config"

//驾驶习惯
#define DRIVING_HABITS_URL       [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!myDrivingHabits"]

//违章查询
#define BREAK_SELECT_URL        @"http://www.cheshouye.com/api/weizhang/query_task?"

//平安亲人信息
#define PEACE_INFO_URL          [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!safeInformation"]

//提交平安亲人信息
#define PEACE_INFO_COMMIT_URL   [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!safeInformationSubmit"]

//定位信息
#define SETTING_URL             [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!SetCenter"]


//矫正信息
#define CORRECT_TIP_INFO_URL    [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!userDefinedMaintenanceTips"]

//提交矫正信息
#define COMMIT_CORRECT_INFO_URL [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!userDefinedMaintenanceTipsSet"]

//通讯设置
#define COMMUNICATION_INFO_URL  [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!communicationMode"]

//提交通讯设置信息
#define COMMIT_COMMUNICATION_URL [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!communicationModeSet"]

//帮组地址
#define HELP_URL                 @"http://mp.weixin.qq.com/s?__biz=MjM5NDI2NTg3Ng==&mid=200251428&idx=1&sn=287fe13a6b417b0c0c70a9ceca3e71ef&scene=1&from=singlemessage&isappinstalled=0#rd"

//历史行程
#define HISTORY_LIST_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!getHistoryCarRunningTrack"]

//行程轨迹详情
#define HISTORY_DETAIL_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!getDetailCarRunningTrack"]

//获取围栏信息
#define GET_FENCE_DATA_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!electronicFenceSet"]

//提交围栏信息
#define COMMIT_FENCE_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/smsInfor!electronicFenceSetSubmit"]

//4s服务消息
#define GET_4S_DATA_URL         [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/userlogin!getAllMessage"]

//油耗获取
#define FULEMILEAGE_URL         [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!gettotalCarTrackRecord"]

//获取仪表盘数据
#define GET_CLOCK_URL           [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!getCarTrackRecording"]

//仪表盘获取驾驶习惯
#define CLOCK_DRIVING_HABITS    [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!drivingHabits"]

//汽车行驶轨迹
#define CAR_TRACK_URL           [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"carcloud/cartrackrecording!getCarRunningTrack"]


#endif
