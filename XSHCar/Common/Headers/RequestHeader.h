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
#define WEB_SERVER_URL          @"http://pcnew.xshcar.com:9988"

//登陆地址
#define LOGIN_URL               [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!login"]

//一键救援地址
#define KEY_RESCUE_URL          [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!keyRescue"]

//预约获取个人信息
#define BOOKING_PERSONAL_URL    [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!appponitment"]

//提交预约信息
#define BOOKING_COMMIT_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!addAppointment"]

//精彩活动
#define EXCITING_LIST_URL       [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!getMessagedetail"]

//移动商城
#define MOBILE_STORE_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!shopmall"]

//故障提示
#define TROUBLE_TIPS_URL        [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!troubleTips"]

//车况检查
#define CAR_CHECK_URL           [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/smsInfor!medicalCondition"]

//消息管理状态
#define MESSAGE_MANAGE_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/smsInfor!getUserSetSms"]

//更新消息状态
#define MESSAGE_UPDATE_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/smsInfor!addAndUpdateSms"]

//城市列表
#define CITY_LIST_URL           @"http://www.cheshouye.com/api/weizhang/get_all_config"

//违章查询
#define BREAK_SELECT_URL        @"http://www.cheshouye.com/api/weizhang/query_task?"

//平安亲人信息
#define PEACE_INFO_URL          [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/smsInfor!safeInformation"]

//提交平安亲人信息
#define PEACE_INFO_COMMIT_URL   [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/smsInfor!safeInformationSubmit"]

//定位开关
#define LOCATION_SWITCH_URL     [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/smsInfor!addAndUpdateSms"]

//矫正信息
#define CORRECT_TIP_INFO_URL    [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/cartrackrecording!userDefinedMaintenanceTips"]

//提交矫正信息
#define COMMIT_CORRECT_INFO_URL [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/cartrackrecording!userDefinedMaintenanceTipsSet"]

//通讯设置
#define COMMUNICATION_INFO_URL  [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/cartrackrecording!communicationMode"]

//提交通讯设置信息
#define COMMIT_COMMUNICATION_URL [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/cartrackrecording!communicationModeSet"]

//帮组地址
#define HELP_URL                 @"http://mp.weixin.qq.com/s?__biz=MjM5NDI2NTg3Ng==&mid=200251428&idx=1&sn=287fe13a6b417b0c0c70a9ceca3e71ef&scene=1&from=singlemessage&isappinstalled=0#rd"

#endif
