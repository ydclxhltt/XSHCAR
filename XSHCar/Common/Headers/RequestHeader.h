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


#endif
