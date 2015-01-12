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
    BMKMapView *_mapView;
    CLLocationCoordinate2D center;
    BMKPolyline *polyline;
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
    _mapView.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    _mapView.delegate = nil;
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
         //NSLog(@"historyDetailResponseDic=requestDic==%@===%@",operation.responseString,requestDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             NSLog(@"historyDetailResponseDic=responseDic==%@",responseDic);
             [weakSelf addLineToMapViewWithData:(NSArray *)responseDic];
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

#pragma mark 地图上画线
- (void)addLineToMapViewWithData:(NSArray *)dataArray
{
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    if ([self.dataArray count] > 0)
    {
        int count = (int)[self.dataArray count];
        CLLocationCoordinate2D corss[count];
        for (int i = 0; i < [self.dataArray count]; i++)
        {
            NSDictionary *dic  = self.dataArray[i];
            CLLocationCoordinate2D coor2d = CLLocationCoordinate2DMake([[dic valueForKey:@"lat"] floatValue], [[dic valueForKey:@"lng"] floatValue]);
            NSDictionary *baidudic = BMKConvertBaiduCoorFrom(coor2d, BMK_COORDTYPE_GPS);
            coor2d =  BMKCoorDictionaryDecode(baidudic);
            corss[i].latitude = coor2d.latitude;
            corss[i].longitude = coor2d.longitude;
            if (i == count/2)
            {
                center = CLLocationCoordinate2DMake(corss[i].latitude,corss[i].longitude);
                [_mapView setCenterCoordinate:center animated:NO];
            }
            if (i == 0 || i == self.dataArray.count -1)
            {
                BMKPointAnnotation *point = [[BMKPointAnnotation alloc]init];
                point.title = (i == 0) ? @"起始点":@"终点";
                [point setCoordinate:corss[i]];
                [_mapView addAnnotation:point];
            }
        }
        if (!polyline)
        {
            polyline = [BMKPolyline polylineWithCoordinates:corss count:count];
        }
        [_mapView addOverlay:polyline];
    }
}


#pragma mark MapViewDlegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        if ([annotation.title isEqualToString:@"起始点"])
        {
            newAnnotationView.image = [UIImage imageNamed:@"nav_start"];
        }
        else
        {
            newAnnotationView.image = [UIImage imageNamed:@"nav_end"];
        }
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    BMKPolylineView *linView;
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        linView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        linView.strokeColor = [UIColor purpleColor];
        linView.lineWidth = 5.0;
        _mapView.zoomLevel = 16.0;
    }
    return linView;
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
