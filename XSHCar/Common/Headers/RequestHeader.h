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
#define WEB_SERVER_URL      @"http://pcnew.xshcar.com:9988"

//登陆地址
#define LOGIN_URL           [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!login"]

//一键救援地址
#define KEY_RESCUE_URL      [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!keyRescue"]

//精彩活动
#define EXCITING_LIST_URL   [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,@"/carcloud/userlogin!getMessagedetail"]

#endif
