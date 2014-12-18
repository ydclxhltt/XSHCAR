//
//  RequestTool.h
//  SmallPig
//
//  Created by chenlei on 14/11/25.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSUInteger
{
    RequestTypeSynchronous,
    RequestTypeAsynchronous,
} RequestType;



@interface RequestTool : NSObject


/*
 *  发起请求方法
 *
 *  @pram   url     请求地址
 *  @pram   paramas 请求参数（字典）
 *  @pram   type    请求类型（同步或异步）
 *  @pram   sucess  请求成功block
 *  @pram   fail    请求失败block
 */
- (void)requestWithUrl:(NSString *)url requestParamas:(NSDictionary *)paramas requestType:(RequestType)type requestSucess:(void (^)(AFHTTPRequestOperation *operation,id responseDic))sucess requestFail:(void (^)(AFHTTPRequestOperation *operation,NSError *error))fail;

/*
 *  取消请求方法
 */
- (void)cancelRequest;
@end
