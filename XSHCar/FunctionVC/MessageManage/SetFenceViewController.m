//
//  SetFenceViewController.m
//  XSHCar
//
//  Created by chenlei on 15/1/1.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SetFenceViewController.h"
#import "BMapKit.h"

@interface SetFenceViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    BMKCircle* circle;
    BMKLocationService *locationService;
    BMKPointAnnotation *pointAnnotation;
}
@end

@implementation SetFenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //title
    self.title = @"设置围栏";
    //添加返回item
    [self addBackItem];
    //添加提交按钮
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitFenceData"];
    //初始化UI
    [self createUI];
    //获取位置
    [self setLocation];
    [self startLocation];
    //获取围栏信息
    [self getFenceData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setAboutLocationDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setAboutLocationDelegate:nil];
}

#pragma mark 设置定位/地图代理
- (void)setAboutLocationDelegate:(id)delegate
{
    if (locationService)
        locationService.delegate = delegate;
    if (_mapView)
        _mapView.delegate = delegate;
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addMapView];
}

- (void)addMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 16.0;
    _mapView.showsUserLocation = NO;
    [self.view addSubview:_mapView];
}

#pragma mark  定位相关
- (void)setLocation
{
    locationService = [[BMKLocationService alloc]init];
    //定位的最小更新距离
    [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
    //定位精确度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)startLocation
{
    locationService.delegate = self;
    [locationService startUserLocationService];
}


- (void)stopLocation
{
    locationService.delegate = nil;
    [locationService stopUserLocationService];
    
}

#pragma mark 获取围栏数据
- (void)getFenceData
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    __weak __typeof(self) weakSelf = self;
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"sms_id":[NSNumber numberWithInt:weakSelf.smsID],@"uss_id":[NSNumber numberWithInt:weakSelf.ussID]};
    NSLog(@"-0-0-=%@",requestDic);
    [request requestWithUrl1:GET_FENCE_DATA_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"peaceResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic])
         {

         }
         else
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
     }];

}

#pragma mark 提交围栏数据
- (void)commitFenceData
{
    
}

#pragma mark 地图添加层
- (void)addOverLaysWithLocation:(CLLocationCoordinate2D)location
{
    [self addPointViewWithLocation:location];
    [self addCycleViewWithLocation:location];
}

- (void)addPointViewWithLocation:(CLLocationCoordinate2D)location
{
    if (!pointAnnotation)
    {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = location;
        pointAnnotation.title = @"拖拽设置围栏";
    }
    [_mapView addAnnotation:pointAnnotation];
}

- (void)addCycleViewWithLocation:(CLLocationCoordinate2D)location
{
    [_mapView removeOverlays:_mapView.overlays];
    if (circle)
    {
        circle = nil;
    }
    // 添加圆形覆盖物
    circle = [BMKCircle circleWithCenterCoordinate:location radius:500];
    [_mapView addOverlay:circle];
}

#pragma mark locationManageDelegate
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"userLocation====%@",[userLocation.location description]);
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self stopLocation];
    [self addOverLaysWithLocation:userLocation.location.coordinate];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}


#pragma mark MapViewDlegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *annotationView;
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        NSString *AnnotationViewID = @"renameMark";
        annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil)
        {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
    }
    return annotationView;
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    BMKCircleView* circleView;
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [APP_MAIN_COLOR colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 1.0;
    }
     return circleView;
}


- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState
{
    NSLog(@"=======%d=====%d",newState,oldState);
//    if (newState == BMKAnnotationViewDragStateStarting)
//    {
//        [_mapView removeOverlays:_mapView.overlays];
//    }
//    if (newState == BMKAnnotationViewDragStateDragging)
    {
        [self addCycleViewWithLocation:view.annotation.coordinate];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    if (_mapView)
    {
        _mapView = nil;
    }
    if (locationService)
    {
        [self stopLocation];
        locationService = nil;
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
