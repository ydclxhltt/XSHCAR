//
//  CheckUpdateTool.m
//  XSHCar
//
//  Created by clei on 14/12/23.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CheckUpdateTool.h"
#import "CommonHeader.h"
#import "RequestTool.h"
#import "SVProgressHUD.h"
#import "CommonTool.h"

@interface CheckUpdateTool()<UIAlertViewDelegate>
{
    id delegate;
}

@end

@implementation CheckUpdateTool

- (void)checkUpdateWithTip:(BOOL)isTip alertViewDelegate:(id)alertDelegate
{
    if (isTip)
    {
        [SVProgressHUD showWithStatus:@"正在检查更新..."];
    }
    delegate = alertDelegate;
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"flag":[NSNumber numberWithInt:APPLICATION_PLATFORM]};
    [request requestWithUrl:CHECK_UPDATE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
        requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"updateResponseDic===%@",responseDic);
         if ([responseDic  isKindOfClass:[NSDictionary class]] || [responseDic  isKindOfClass:[NSMutableDictionary class]])
         {
             if (isTip)
                 [SVProgressHUD showSuccessWithStatus:@"检查成功" duration:.1];
             NSString *serverVersion = [responseDic objectForKey:@"VVersionId"];
             serverVersion  = (serverVersion) ? serverVersion : @"";
             int version = [[serverVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
             int appVersion = INT_VERSION;
             if (appVersion < version)
             {
                 //有更新
                 NSString *message = [responseDic objectForKey:@"VVersioncontent"];
                 message = (message) ? message : @"发现新版本";
                 [self addAlertTip:message];
             }
             else
             {
                 [CommonTool addAlertTipWithMessage:@"已经是最新版本"];
             }

         }
         else
         {
             if (isTip)
                 [SVProgressHUD showSuccessWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         if (isTip)
             [SVProgressHUD showErrorWithStatus:@"检查更新失败"];
         NSLog(@"error===%@",error);
     }];
}

- (void)addAlertTip:(NSString *)tipText
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"升级提示" message:tipText delegate:delegate cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
    [alertView show];
}





@end
