//
//  HistoryDetailViewController.m
//  XSHCar
//
//  Created by clei on 14/12/31.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "BMapKit.h"

@interface HistoryDetailViewController ()<BMKMapViewDelegate>
{
    BMKMapView *mapView;
}
@end

@implementation HistoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //title
    self.title = @"行驶轨迹";
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //获取数据
    [self getHistoryDetailData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mapView.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    mapView.delegate = nil;
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addMapView];
}

- (void)addMapView
{
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mapView.delegate = self;
    mapView.mapType = BMKMapTypeStandard;
    mapView.zoomLevel = 14.0;
    mapView.showsUserLocation = NO;
    [self.view addSubview:mapView];
}


#pragma mark 获取详情数据
- (void)getHistoryDetailData
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"ctrId":[NSNumber numberWithInt:[self.ctrId intValue]]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:HISTORY_DETAIL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"historyDetailResponseDic=requestDic==%@===%@",operation.responseString,requestDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
         }
         else
         {
             //服务器异常
            [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    if (mapView)
    {
        mapView = nil;
    }
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
