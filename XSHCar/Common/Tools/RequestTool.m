//
//  RequestTool.m
//  SmallPig
//
//  Created by chenlei on 14/11/25.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "RequestTool.h"

@interface RequestTool()
{
    AFHTTPRequestOperation *requestOperation;
}
@end

@implementation RequestTool

//发起请求
- (void)requestWithUrl:(NSString *)url requestParamas:(NSDictionary *)paramas requestType:(RequestType)type requestSucess:(void (^)(AFHTTPRequestOperation *operation,id responseDic))sucess requestFail:(void (^)(AFHTTPRequestOperation *operation,NSError *error))fail
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:[userinfo valueForKey:kCookie] forHTTPHeaderField:@"cookie"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    requestOperation = [manager POST:url parameters:paramas
          success:^(AFHTTPRequestOperation *operation,id responeDic)
          {
              if (sucess)
              {
                  sucess(operation,responeDic);
              }
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *err)
          {
              if (fail)
              {
                  fail(operation,err);
              }
          }];
    
    if (RequestTypeSynchronous == type)
    {
        [requestOperation waitUntilFinished];
    }
}


//取消请求
- (void)cancelRequest
{
    if (requestOperation)
    {
        [requestOperation cancel];
        requestOperation = nil;
    }
}


@end
