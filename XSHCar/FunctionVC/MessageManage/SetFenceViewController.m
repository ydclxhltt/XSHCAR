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
    BMKPolygon *polygon;
    BMKLocationService *locationService;
    BMKPointAnnotation *pointAnnotation;
    int efsID;
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
         NSLog(@"fenceResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic])
         {
             if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",responseDic]])
             {
                 return;
             }
             else
             {
                 NSDictionary *jsonDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[responseDic dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                 efsID = [[jsonDic objectForKey:@"efsId"] intValue];
                 NSString *string = [jsonDic objectForKey:@"efsLocation"];
                 NSArray *array = [string componentsSeparatedByString:@";"];
                 if (array)
                 {
                     weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                     if ([array count] > 0)
                     {
                         NSArray *locationArray = [array[0] componentsSeparatedByString:@","];
                         if (locationArray && [locationArray count] == 2)
                         {
                             [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([locationArray[0] floatValue], [locationArray[1] floatValue]) animated:YES];
                         }
                     }
                     if ([array count] > 3)
                     {
                         //画区域
                         [self addPolygonView];
                     }
                 }
             }
             
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
    [SVProgressHUD showWithStatus:@"正在保存..."];
    NSString *locationString = @"";
    for (int i = 1; i < [self.dataArray count]; i++)
    {
        NSString *locationstr = self.dataArray[i];
        if (i != [self.dataArray count] - 1)
        {
            locationstr = [locationstr stringByAppendingString:@";"];
        }
        locationString = [NSString stringWithFormat:@"%@%@",locationString,locationstr];
    }
    __weak __typeof(self) weakSelf = self;
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"efs_id":[NSNumber numberWithInt:efsID],@"efs_location":locationString,@"uss_id":[NSNumber numberWithInt:weakSelf.ussID]};
    NSLog(@"-0-0-=%@",requestDic);
    [request requestWithUrl1:COMMIT_FENCE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"fenceResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic])
         {
             if ([@"8888" isEqualToString:[NSString stringWithFormat:@"%@",responseDic]])
             {
                 [SVProgressHUD showSuccessWithStatus:@"设置成功"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"设置失败"];
             }
             
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

#pragma mark 地图添加层

- (void)addPolygonView
{
    [_mapView removeOverlays:_mapView.overlays];
    if (polygon)
    {
        polygon = nil;
    }
    int count = (int)[self.dataArray count];
    CLLocationCoordinate2D locationArray[count];
    for (int i = 0; i < [self.dataArray count];i++)
    {
        NSString *string = self.dataArray[i];
        NSArray *array = [string componentsSeparatedByString:@","];
        if ([array count] == 2)
        {
            CLLocationCoordinate2D location =  CLLocationCoordinate2DMake([array[0] floatValue], [array[1] floatValue]);
            locationArray[i] = location;
        }
    }
    NSLog(@"locationArray===%@========%d",[NSString stringWithFormat:@"%f,%f",locationArray[0].latitude,locationArray[0].longitude],count);
    polygon = [BMKPolygon polygonWithCoordinates:locationArray count:count];
    [_mapView addOverlay:polygon];

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
    if (!self.dataArray || [self.dataArray count] == 0)
    {
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    }
    [self stopLocation];
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
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.fillColor = [APP_MAIN_COLOR colorWithAlphaComponent:0.5];
        polygonView.strokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        polygonView.lineDash = (overlay == polygon);
        polygonView.lineWidth = 1.0;
        return polygonView;
    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (!self.dataArray)
    {
        self.dataArray = [NSMutableArray array];
    }
    NSString *locationString = [NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude];
    [self.dataArray addObject:locationString];
    NSLog(@"self.dataArray ===%@",self.dataArray);
    [self addPolygonView];
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
