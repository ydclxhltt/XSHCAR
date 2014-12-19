//
//  HomeViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HomeViewController.h"
#import "ExcitingActivitiesViewController.h"

@interface HomeViewController ()
{
    float height;
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

    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addAdvView];
    [self addFunctionsView];
}

- (void)addAdvView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_HEIGHT, 160)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    height += view.frame.size.height;
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
            
            break;
        case 3:
            viewController = [[ExcitingActivitiesViewController alloc] init];
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 10:
            
            break;
        case 11:
            
            break;
        case 12:
            
            break;
        default:
            break;
    }
    if (viewController)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark 获取一键救援号码
- (void)getPhoneNumber
{
    RequestTool *request = [[RequestTool alloc] init];
    int shopID = [[XSH_Application shareXshApplication] shopID];
    [request requestWithUrl1:KEY_RESCUE_URL requestParamas:@{@"shop_id":[NSNumber numberWithInt:shopID]} requestType:RequestTypeSynchronous requestSucess:^(AFHTTPRequestOperation *operation,id responseDic){NSLog(@"=====%@",responseDic);} requestFail:^(AFHTTPRequestOperation *operation,NSError *error){NSLog(@"error===%@",error);}];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
