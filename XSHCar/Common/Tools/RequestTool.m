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
    manager.requestSerializer.timeoutInterval = 10.0;
//    [manager.requestSerializer setValue:@"0001" forHTTPHeaderField:@"t_code"];
//    [manager.requestSerializer setValue:@"1.2.3" forHTTPHeaderField:@"version_code"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    requestOperation = [manager POST:url parameters:paramas
          success:^(AFHTTPRequestOperation *operation,id responeDic)
          {
              NSLog(@"==111==%@",operation.response.allHeaderFields);
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


//发起请求
- (void)requestWithUrl1:(NSString *)url requestParamas:(NSDictionary *)paramas requestType:(RequestType)type requestSucess:(void (^)(AFHTTPRequestOperation *operation,id responseDic))sucess requestFail:(void (^)(AFHTTPRequestOperation *operation,NSError *error))fail
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    //    [manager.requestSerializer setValue:@"0001" forHTTPHeaderField:@"t_code"];
    //    [manager.requestSerializer setValue:@"1.2.3" forHTTPHeaderField:@"version_code"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    requestOperation = [manager POST:url parameters:paramas
                        success:^(AFHTTPRequestOperation *operation,id responeDic)
                        {
                            if (sucess)
                            {
                                sucess(operation,operation.responseString);
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
