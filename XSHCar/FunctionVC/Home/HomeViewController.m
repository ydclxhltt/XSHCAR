//
//  HomeViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HomeViewController.h"
#import "BookingViewController.h"
#import "ExcitingActivitiesViewController.h"
#import "MobileStoreViewController.h"
#import "BugsTipViewController.h"
#import "CarCheckViewController.h"
#import "BreakSelectViewController.h"
#import "DrivingHabitsViewController.h"
#import "LocationServiceViewController.h"
#import "FourSServiceViewController.h"
#import "FuleMileageViewController.h"
#import "BearingClockViewController.h"

#import "AdvView.h"

@interface HomeViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,NSXMLParserDelegate>
{
    float height;
    AdvView *advView;
    BMKLocationService *locationService;
    BMKGeoCodeSearch *geocodesearch;
    NSXMLParser *xmlParser;
    NSMutableArray *xmlWeatherStringArray;
}
@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, strong) NSString *tempString;
@property(nonatomic, strong) NSString *timeString;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"熙盛恒汽车卫士";
        height = NAV_HEIGHT;
        xmlWeatherStringArray = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@"一键救援",@"预约服务",@"精彩活动",@"移动商城",@"仪表盘",@"驾驶习惯",@"故障提示",@"车况检查",@"违章查询",@"油耗里程",@"位置服务",@"4S服务"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeather) name:@"GetWeather" object:nil];
    //初始化UI
    [self createUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = YES;
    [self setAdvData];
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
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addAdvView];
    [self addFunctionsView];
}

- (void)addAdvView
{
    //设置frame
    float advHeight = (SCREEN_WIDTH/320.0) * ADV_HEIGHT;

    //初始化广告视图
    advView = [[AdvView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, advHeight)];
    [self.view addSubview:advView];
    
    height += advView.frame.size.height + 5.0;
}

- (void)addFunctionsView
{
    int column = 4;
    int row = ceil([self.dataArray count]/column);
    float functionButtonHeight = 75.0;
    float functionButtonWidth = 75.0;
    float add_x = (SCREEN_WIDTH - functionButtonWidth * column)/5;
    float add_y = 15.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height, SCREEN_HEIGHT, SCREEN_HEIGHT - height - TABBAR_HEIGHT)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, functionButtonHeight *  row + add_y *  (row + 1));
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < row; i++)
    {
        int m = column;
        if (i == row - 1)
        {
            m = ([self.dataArray count]%column == 0) ? column : [self.dataArray count]%column;
        }
        for (int j = 0; j < m; j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(add_x * (j + 1) + functionButtonWidth * j, 20.0 + add_y * i  + functionButtonHeight * i, functionButtonWidth, functionButtonHeight);
            button.tag = i * column + j + 1;
            [button setTitle:self.dataArray[button.tag - 1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = FONT(12.0);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(35.0, 0.0, 0.0, 0.0)];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d",(int)button.tag]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.showsTouchWhenHighlighted = YES;
            [scrollView addSubview:button];
        }
    }
}

- (void)addWeatherView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(5, NAV_HEIGHT + 10, 120, 45) placeholderImage:nil];
    [CommonTool clipView:bgImageView withCornerRadius:22.5];
    bgImageView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.8];
    [self.view addSubview:bgImageView];
    
    UIImage *iconImage = [UIImage imageNamed:@"wetherIcon.png"];
    UIImageView *weatherIcon = [CreateViewTool createImageViewWithFrame:CGRectMake( 10 ,(bgImageView.frame.size.height - iconImage.size.height)/2 , iconImage.size.width, iconImage.size.height) placeholderImage:iconImage];
    [bgImageView addSubview:weatherIcon];
    
    NSArray *array = @[self.cityName,self.tempString];
    NSLog(@"array===%@",array);
    startHeight = weatherIcon.frame.origin.x + weatherIcon.frame.size.width + 5;
    
    for (int i = 0; i < [array count]; i++)
    {
        NSString *string = [array[i] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //NSLog(@"array====%@===%@",@"--",[string stringByAddingPercentEscapesUsingEncoding:<#(NSStringEncoding)#>]);
        float left_y = 5.0;
        float labelHeight = (bgImageView.frame.size.height - left_y*2)/[array count];
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(startHeight, left_y + i * labelHeight, bgImageView.frame.size.width - startHeight, labelHeight) textString:string textColor:[UIColor whiteColor] textFont:FONT(13.0)];
        if (i == 0)
        label.textAlignment = NSTextAlignmentCenter;
        [bgImageView addSubview:label];
    }
}

#pragma mark 设置广告数据
- (void)setAdvData
{
    //设置广告数据
    NSDictionary *loginDic = [[XSH_Application  shareXshApplication] loginDic];
    NSArray *imageUrlArray = nil;
    if (loginDic)
    {
        imageUrlArray = [loginDic objectForKey:@"bannerList"];
    }
    
    if (!imageUrlArray || [imageUrlArray count] == 0)
    {
        imageUrlArray = @[@""];
    }
    [advView setAdvData:imageUrlArray];
}



#pragma mark 按钮响应时间
- (void)buttonPressed:(UIButton *)button
{
    UIViewController *viewController = nil;
    int tag = (int)button.tag;
    switch (tag)
    {
        case 1:
            [self getPhoneNumber];
            break;
        case 2:
            viewController = [[BookingViewController alloc] init];
            break;
        case 3:
            viewController = [[ExcitingActivitiesViewController alloc] init];
            break;
        case 4:
            viewController = [[MobileStoreViewController alloc] init];
            break;
        case 5:
            viewController = [[BearingClockViewController alloc] init];
            break;
        case 6:
            viewController = [[DrivingHabitsViewController alloc] init];
            break;
        case 7:
            viewController = [[BugsTipViewController alloc] init];
            break;
        case 8:
            viewController = [[CarCheckViewController alloc] init];
            break;
        case 9:
            viewController = [[BreakSelectViewController alloc]init];
            break;
        case 10:
            viewController = [[FuleMileageViewController alloc] init];
            break;
        case 11:
            viewController = [[LocationServiceViewController alloc] init];
            break;
        case 12:
            viewController = [[FourSServiceViewController alloc] init];
            break;
        default:
            break;
    }
    if (viewController)
    {
        viewController.title = self.dataArray[(int)tag - 1];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark 获取一键救援号码
- (void)getPhoneNumber
{
    [SVProgressHUD showWithStatus:@"正在获取"];
    RequestTool *request = [[RequestTool alloc] init];
    int shopID = [[XSH_Application shareXshApplication] shopID];
    [request requestWithUrl1:KEY_RESCUE_URL requestParamas:@{@"shop_id":[NSNumber numberWithInt:shopID]} requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"=====%@",responseDic);
         NSString *responseString = (NSString *)responseDic;
         if(responseString && ![@"" isEqualToString:responseString])
         {
             [SVProgressHUD showSuccessWithStatus:@"获取成功" duration:.5];
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",responseString]];
             if ([[UIApplication sharedApplication] canOpenURL:url])
             {
                 [[UIApplication sharedApplication] openURL:url];
             }
             else
             {
                 //设备不支持
                 [CommonTool addAlertTipWithMessage:@"设备不支持"];
             }
         }
         else
         {
             //获取失败
             [SVProgressHUD showErrorWithStatus:@"获取号码失败"];
         }
     }
                 requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"获取号码失败"];
         NSLog(@"error===%@",error);
     }];
}



#pragma mark 开始获取天气
- (void)getWeather
{
    [self setLocation];
    [self startLocation];
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



#pragma mark 编译地址
- (void)getReverseGeocodeWithLocation:(CLLocationCoordinate2D)locaotion
{
    if (!geocodesearch)
    {
        geocodesearch = [[BMKGeoCodeSearch alloc] init];
        geocodesearch.delegate = self;
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = locaotion;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


#pragma mark  获取天气信息
- (void)getWeatherDataWithCity:(NSString *)city
{
    city = (city && ![@"" isEqualToString:city]) ? city : nil;
    if (city)
    {
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        NSString *url = [GET_WEATHER_URL stringByAppendingString:city];
        NSLog(@"url====%@",url);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^
        {
            NSURL *weatherUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *weatherString = [NSString  stringWithContentsOfURL:weatherUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [weatherString dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"data====%@",data);
            xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:self];
            [xmlParser setShouldProcessNamespaces:NO];
            [xmlParser setShouldReportNamespacePrefixes:NO];
            [xmlParser setShouldResolveExternalEntities:NO];
            [xmlParser parse];

        });

    }
}


#pragma mark 坐标转换地址Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result====%@",[[result addressDetail] city]);
    [self getWeatherDataWithCity:[[result addressDetail] city]];
}

#pragma mark locationManageDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"userLocation====%@",[userLocation.location description]);
    [self getReverseGeocodeWithLocation:userLocation.location.coordinate];
    [self stopLocation];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

#pragma mark xml parser delegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    string = [string stringByTrimmingCharactersInSet:whitespace];
    
    if (![string isEqualToString:@"\n"]) {
        [xmlWeatherStringArray addObject:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError description]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [self outputParseInfo];
    
    //取出xml中数据后提取信息
    [self splitXmlWeatherInfo];
}	

#pragma mark other
- (void)outputParseInfo{
    for (int i = 0; i < [xmlWeatherStringArray count]; ++i) {
        NSLog(@"<%d>%@", i, [xmlWeatherStringArray objectAtIndex:i]);
    }
}

- (void)splitXmlWeatherInfo
{
    if ([xmlWeatherStringArray count] >= 30)
    {
        NSLog(@"%@",xmlWeatherStringArray);
        self.cityName = xmlWeatherStringArray[1];
        self.timeString = xmlWeatherStringArray[4];
        self.tempString =[xmlWeatherStringArray[5] stringByAppendingString:xmlWeatherStringArray[6]];
        dispatch_async(dispatch_get_main_queue(), ^{[self addWeatherView];});
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    if (locationService)
    {
        [self startLocation];
        locationService = nil;
    }
    if (geocodesearch)
    {
        geocodesearch = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    // Get the new view controller using [segue destinationViewController].    // Pass the selected object to the new view controller.
}
*/

@end
