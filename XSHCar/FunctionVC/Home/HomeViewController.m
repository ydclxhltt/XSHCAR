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

#import "AdvView.h"

@interface HomeViewController ()
{
    float height;
    AdvView *advView;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"熙盛恒汽车卫士";
        height = NAV_HEIGHT;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@"一键救援",@"预约服务",@"精彩活动",@"移动商城",@"仪表盘",@"驾驶习惯",@"故障提示",@"车况检查",@"违章查询",@"油耗里程",@"位置服务",@"4S服务"];
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
    float advHeight = ADV_HEIGHT;
    
    if (SCREEN_WIDTH > 320.0)
    {
        advHeight = (SCREEN_WIDTH/320.0) * ADV_HEIGHT;
    }
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
