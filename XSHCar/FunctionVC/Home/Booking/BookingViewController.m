//
//  BookingViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BookingViewController.h"

@interface BookingViewController ()
@property(nonatomic, retain) NSDictionary *bookingInfoDic;
@end

@implementation BookingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //添加右边item
    [self setNavBarItemWithTitle:@"   提交" navItemType:rightItem selectorName:@"commitButtonPressed:"];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    //获取预约信息
    [self getBookingInfo];
}

#pragma mark 获取预约信息
- (void)getBookingInfo
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:BOOKING_PERSONAL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"excitingResponseDic===%@",responseDic);
        if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableArray class]])
        {
            weakSelf.bookingInfoDic = responseDic;
        }
        else
        {
            //服务器异常
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        NSLog(@"error===%@",error);
    }];
}

#pragma mark 提交按钮响应事件
- (void)commitButtonPressed:(UIButton *)button
{
    [self commitBooking];
}

- (void)commitBooking
{
    //__weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"AM_Telphone":[self.bookingInfoDic objectForKey:@"AM_Telphone"],@"AM_AppointmentTime":@"2014-12-22",@"ac_id":@"1",@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl1:BOOKING_COMMIT_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"excitingResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             
         }
         else
         {
             //服务器异常
         }
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
         NSLog(@"error===%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
