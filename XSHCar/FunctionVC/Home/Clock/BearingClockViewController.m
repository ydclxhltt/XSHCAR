//
//  BearingClockViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BearingClockViewController.h"
#import "BMapKit.h"
#import "HistoryListViewController.h"

@interface BearingClockViewController ()<BMKMapViewDelegate>
{
    UILabel *timeLabel;
    UILabel * speedScoreLabel;
    UIScrollView *speedScrollView;
    int ctrId;
    NSString *speedScore;
    BMKMapView *_mapView;
    BMKPolyline *polyline;
}
@property(nonatomic, strong) NSArray *speedArray;
@property(nonatomic, strong) NSArray *trackArray;
@end

@implementation BearingClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加返回item
    [self addBackItem];
    //添加历史行程Item
    [self setNavBarItemWithTitle:@"历史行程" navItemType:rightItem selectorName:@"showHistoryView"];
    //初始化UI
    [self createUI];
    //获取数据
    [self clockData];
   
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_mapView)
    {
        _mapView.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_mapView)
    {
        _mapView.delegate = nil;
    }
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTimeLabel];
    [self addLabels];
    [self addButtons];
}

- (void)addTimeLabel
{
    startHeight = NAV_HEIGHT;
    timeLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH, 25.0) textString:@"" textColor:[UIColor grayColor] textFont:FONT(13.0)];
    timeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timeLabel];
    startHeight += timeLabel.frame.size.height;
}

- (void)addLabels
{
    float labelHeight = 30.0;
    float labelWidth = SCREEN_WIDTH/2;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(j * labelWidth, startHeight + i * labelHeight, labelWidth, labelHeight) textString:@"" textColor:[UIColor blackColor] textFont:FONT(13.0)];
            label.tag  = i * 2 + j + 1;
            [CommonTool setViewLayer:label withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
            [self.view addSubview:label];
        }
    }
    startHeight += labelHeight * 4 + 10.0;
}

- (void)addButtons
{
    NSArray *array = @[@"经济车速",@"驾驶习惯统计",@"行驶轨迹"];
    float left_x = 20.0;
    float add_x = 1.0;
    float buttonWidth = (SCREEN_WIDTH - left_x * 2 - add_x * 2)/3;
    float buttonHeight = 35.0;
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(left_x + buttonWidth * i + add_x * i, startHeight, buttonWidth, buttonHeight) buttonTitle:array[i] titleColor:[UIColor whiteColor] normalBackgroundColor:[UIColor grayColor] highlightedBackgroundColor:nil selectorName:@"buttonPressed:" tagDelegate:self];
        [button setBackgroundImage:[CommonTool imageWithColor:APP_MAIN_COLOR] forState:UIControlStateSelected];
        button.tag = 100 + i;
        button.titleLabel.font = FONT(14.0);
        [self.view addSubview:button];
        
        if (i == 0)
        {
            button.selected = YES;
        }
    }
    
    startHeight += buttonHeight;
}

- (void)addBottomViewWithIndex:(int)index
{
    switch (index)
    {
        case 100:
            [self addSpeedView];
            break;
        case 101:
            [self addTableView];
            break;
        case 102:
            [self addMapView];
            break;
        default:
            break;
    }
}

- (void)addSpeedView
{
    if (speedScrollView)
    {
        [self.view addSubview:speedScoreLabel];
        [self.view addSubview:speedScrollView];
        return;
    }
    
    NSArray *speedRangeArray = @[@"0-10\nkm/h",@"10-60\nkm/h",@"60-90\nkm/h",@"90-120\nkm/h",@">120\nkm/h"];
    
    speedScoreLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, startHeight, SCREEN_HEIGHT, 35.0) textString:speedScore textColor:[UIColor blackColor] textFont:FONT(18.0)];
    speedScoreLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:speedScoreLabel];
    

    float height = 50.0;
    float labelWidth = 60.0;
    speedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startHeight + speedScoreLabel.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - startHeight)];
    speedScrollView.backgroundColor = [UIColor whiteColor];
    speedScrollView.pagingEnabled = YES;
    speedScrollView.showsHorizontalScrollIndicator = NO;
    speedScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height * [self.speedArray count]);
    [self.view addSubview:speedScrollView];
    
    float count = 0.0;
    for (int i = 0; i < [self.speedArray count]; i++)
    {
        NSDictionary *dic = self.speedArray[i];
        count += [[dic objectForKey:@"ssmMileage"] floatValue];
    }
    
    for (int i = 0; i < [self.speedArray count]; i++)
    {
        UIImageView *h_Line_ImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, (i + 1) * height, SCREEN_WIDTH, .5) placeholderImage:nil];
        h_Line_ImageView.backgroundColor = [APP_MAIN_COLOR colorWithAlphaComponent:.7];
        [speedScrollView addSubview:h_Line_ImageView];
        if (i == 0)
        {
            UIImageView *h_Line_ImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5) placeholderImage:nil];
            h_Line_ImageView.backgroundColor = [APP_MAIN_COLOR colorWithAlphaComponent:.7];
            [speedScrollView addSubview:h_Line_ImageView];
            UIImageView *v_Line_ImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(labelWidth, 0,.5, speedScrollView.contentSize.height) placeholderImage:nil];
            v_Line_ImageView.backgroundColor = [APP_MAIN_COLOR colorWithAlphaComponent:.7];
            [speedScrollView addSubview:v_Line_ImageView];
        }
        
        UILabel *speedLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, i * height, labelWidth, height) textString:speedRangeArray[i] textColor:[UIColor grayColor] textFont:FONT(14.0)];
        speedLabel.numberOfLines = 2;
        speedLabel.textAlignment = NSTextAlignmentCenter;
        [speedScrollView addSubview:speedLabel];
        
        NSDictionary *dic = self.speedArray[i];
        float totalWidth = 160.0;
        float zoom = 0.0;
        float imageViewHeight = 25.0;
        if (count > 0)
        {
           zoom = [[dic objectForKey:@"ssmMileage"] floatValue]/count;
        }
        float lineLabelWidth = zoom * totalWidth;
        int index = [[dic objectForKey:@"speedRange"] intValue] - 1;
        
        UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(labelWidth + 1.0, (height - imageViewHeight)/2 + index * height, lineLabelWidth , imageViewHeight) placeholderImage:nil];
        imageView.backgroundColor = [APP_MAIN_COLOR colorWithAlphaComponent:.7];
        [speedScrollView addSubview:imageView];

        
        NSString *mileageString = [NSString stringWithFormat:@"%.1fkm",[[dic objectForKey:@"ssmMileage"] floatValue]];
        float mileageWidth = [mileageString sizeWithFont:FONT(14.0)].width;
        UILabel *mileageLable =[CreateViewTool createLabelWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5.0, index * height,  mileageWidth + 5, height) textString:mileageString textColor:[UIColor grayColor] textFont:FONT(14.0)];
        [speedScrollView addSubview:mileageLable];
        
        NSString *zoomString = [NSString stringWithFormat:@"%.1f％",zoom * 100];
        float zoomWidth = [zoomString sizeWithFont:FONT(14.0)].width;
        UILabel *zoomLabel = [CreateViewTool createLabelWithFrame:CGRectMake(mileageLable.frame.origin.x + mileageLable.frame.size.width, index*height,zoomWidth, height) textString:zoomString textColor:[UIColor grayColor] textFont:FONT(14.0)];
        [speedScrollView addSubview:zoomLabel];
        
    }
    
    
    
}

- (void)addTableView
{
    if (self.table)
    {
        [self.view addSubview:self.table];
        return;
    }
    [self addTableViewWithFrame:CGRectMake(0, startHeight + 5.0, SCREEN_HEIGHT, SCREEN_HEIGHT - startHeight - 5.0) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.backgroundColor = [UIColor whiteColor];
}

- (void)addMapView
{
    if (_mapView)
    {
        [self.view addSubview:_mapView];
        return;
    }
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, startHeight + 5.0, SCREEN_WIDTH, SCREEN_HEIGHT - startHeight - 5.0)];
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 14.0;
    _mapView.showsUserLocation = NO;
    [self.view addSubview:_mapView];
}

#pragma mark 点击历史行程
- (void)showHistoryView
{
    HistoryListViewController *historyListViewController = [[HistoryListViewController alloc] init];
    historyListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyListViewController animated:YES];
}


#pragma mark 获取仪表盘数据
- (void)clockData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:GET_CLOCK_URL requestParamas:@{@"car_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]]} requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"clockResponseDic===%@",operation.responseString);
         if (responseDic && [responseDic isKindOfClass:[NSDictionary class]] && [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             [weakSelf setClockViewData:responseDic];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"error===%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
     }];
}

#pragma mark 设置相关数据
- (void)setClockViewData:(NSDictionary *)responseDic
{
    [self setTimeLabelText:responseDic];
    [self setLabelsText:responseDic];
    self.speedArray = [NSArray arrayWithArray:[responseDic objectForKey:@"speedSectionMileageTbl"]];
    ctrId = [[responseDic objectForKey:@"ctrId"]intValue];
    speedScore = [NSString stringWithFormat:@" 经济车速得分: %@分",[responseDic objectForKey:@"speedScore"]];
    [self addSpeedView];
}

- (void)setTimeLabelText:(NSDictionary *)responseDic
{
    NSString *startTime = [responseDic objectForKey:@"starttime"];
    startTime = (startTime) ? startTime : @"";
    NSString *endTime = [responseDic objectForKey:@"endtime"];
    endTime = (endTime) ? endTime : @"";
    
    timeLabel.text = [NSString stringWithFormat:@"  最近行程: %@ -- %@",startTime,endTime];
}

- (void)setLabelsText:(NSDictionary *)responseDic
{
    NSArray *array = @[@"ctr_totalmileage",@"ctr_averagespeed",@"ctr_cumulativeOil",@"ctr_FuelEconomyFKM",@"ctr_averagespeed",@"ctr_Totaltraveltime",@"totalMileage",@"uboxmileage"];
    NSMutableArray *textArray = [NSMutableArray array];
    NSArray *preArray = @[@"  里程: %@km",@"  车速: %@km/h",@"  油耗量: %@L",@"  油耗: %@L/km",@"  平均车速: %@km/h",@"  行程时间: %@",@"  总里程: %@km",@"  Ubox行驶里程: %@km"];
    for (NSString *key in array)
    {
        NSString *textString = [responseDic objectForKey:key];
        textString =  (textString) ? textString : @"";
        [textArray addObject:textString];
    }
    for (int i = 1; i < 9; i ++)
    {
        UILabel *label = (UILabel *)[self.view viewWithTag:i];
        label.text = [NSString stringWithFormat:preArray[i - 1],textArray[i - 1]];
    }

}

#pragma mark 按钮响应事件
- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = YES;
    for (int i = 0; i < 3; i ++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:100 + i];
        button.selected = (sender == button) ? YES : NO;
    }
    [self addBottomViewWithIndex:sender.tag];
    if (sender.tag == 100)
    {
        if (!self.speedArray)
        {
            [self clockData];
        }
    }
    if (sender.tag == 101)
    {
        if (!self.dataArray)
        {
            [self getDrivingHabitsData];
        }
    }
    else if (sender.tag == 102)
    {
        if (!self.trackArray)
        {
            [self getTrackData];
        }
    }
}

#pragma mark 获取驾驶习惯
- (void)getDrivingHabitsData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:CLOCK_DRIVING_HABITS requestParamas:@{@"ctrId":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]]} requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"drivingHabitsResponseDic===%@",operation.responseString);
         if (responseDic && [responseDic isKindOfClass:[NSArray class]] && [responseDic isKindOfClass:[NSMutableArray class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             weakSelf.dataArray = [NSMutableArray arrayWithArray:responseDic];
             [weakSelf.table reloadData];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"error===%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
     }];
}

#pragma mark 获取轨迹
- (void)getTrackData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl1:CAR_TRACK_URL requestParamas:@{@"cId":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]]} requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"trackResponseDic===%@",operation.responseString);
         if (responseDic && ![@"" isEqualToString:responseDic])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             weakSelf.trackArray = [responseDic componentsSeparatedByString:@","];
             [weakSelf addLineToMapView];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"error===%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
     }];

}


#pragma mark 画线
- (void)addLineToMapView
{
    if ([self.trackArray count] == 4)
    {
        self.trackArray = @[@"23.040772",@"113.176361",@"23.040772",@"113.196361"];
        CLLocationCoordinate2D corss[2];
        CLLocationCoordinate2D coor2d1 = CLLocationCoordinate2DMake([self.trackArray[0] floatValue], [self.trackArray[1] floatValue]);
        NSDictionary *baidudic1 = BMKConvertBaiduCoorFrom(coor2d1, BMK_COORDTYPE_GPS);
        coor2d1 =  BMKCoorDictionaryDecode(baidudic1);
        corss[0].latitude = coor2d1.latitude;
        corss[0].longitude = coor2d1.longitude;
        
        CLLocationCoordinate2D coor2d2 = CLLocationCoordinate2DMake([self.trackArray[2] floatValue], [self.trackArray[3] floatValue]);
        NSDictionary *baidudic2 = BMKConvertBaiduCoorFrom(coor2d2, BMK_COORDTYPE_GPS);
        coor2d2 =  BMKCoorDictionaryDecode(baidudic2);
        corss[1].latitude = coor2d2.latitude;
        corss[1].longitude = coor2d2.longitude;
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(corss[0].latitude,corss[0].longitude);
        [_mapView setCenterCoordinate:center animated:NO];
        
        for (int i = 0; i < 2; i ++)
        {
            BMKPointAnnotation *point = [[BMKPointAnnotation alloc]init];
            point.title = (i == 0) ? @"起始点":@"终点";
            [point setCoordinate:corss[i]];
            [_mapView addAnnotation:point];
        }

        if (!polyline)
        {
            polyline = [BMKPolyline polylineWithCoordinates:corss count:2];
        }
        [_mapView addOverlay:polyline];
    }
}




#pragma mark tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray  count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"drivingHabitsCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:102];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(20.0, (cell.frame.size.height - 35.0)/2, 35.0, 35.0) placeholderImage:[UIImage imageNamed:@"pic_default"]];
        imageView.tag = 101;
        [cell.contentView addSubview:imageView];
        textLabel = [CreateViewTool createLabelWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 25.0, 0, 140.0, cell.frame.size.height) textString:@"" textColor:[UIColor blackColor] textFont:FONT(16.0)];
        textLabel.tag = 102;
        [cell.contentView addSubview:textLabel];
        
        label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120.0 - 20.0, 0, 120.0, cell.frame.size.height) textString:@"" textColor:[UIColor grayColor] textFont:FONT(15.0)];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    NSString *title = [rowDic objectForKey:@"daName"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,[rowDic objectForKey:@"daFilepath"]];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pic_default"]];
    textLabel.text = (title) ? title : @"";
    
    NSString *pre = @"次";
    if ([title rangeOfString:@"时长"].length > 0)
    {
        pre = @"秒";
    }
    if ([title rangeOfString:@"分"].length > 0)
    {
        pre = @"分";
    }
    NSString *textString = [NSString stringWithFormat:@"%@%@",[rowDic objectForKey:@"daValue"],pre];
    
    label.text = textString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark mapViewDelegate

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
        _mapView.zoomLevel = 14.0;
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
