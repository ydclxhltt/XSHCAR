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

@implementation CheckUpdateTool

+ (void)checkUpdateWithTip:(BOOL)isTip
{
    if (isTip)
    {
        [SVProgressHUD showWithStatus:@"正在检查更新..."];
    }
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"flag":[NSNumber numberWithInt:APPLICATION_PLATFORM]};
    [request requestWithUrl1:CHECK_UPDATE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
        requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"updateResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
         {
             
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
@end
