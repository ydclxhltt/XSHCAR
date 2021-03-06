//
//  BreakSelectViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define SEGMENT_HEIGHT 40.0

#import "BreakSelectViewController.h"
#import "SDSegmentedControl.h"
#import "CityListViewController.h"
#import "BreakListViewController.h"
#import "BreakCell.h"

@interface BreakSelectViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    SDSegmentedControl *segmentView;
    UIScrollView *contentScrollView;
    UIView *selectView,*recordView,*dealView;
    UIButton *cityButton;
    CityListViewController *tempListViewController;
    UITableView *recordTable,*dealTable;
    int currentPage;
    UIButton *moreButton;
}
@end

@implementation BreakSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //初始化数据
    currentPage = 1;
    //获取车辆数据
    [self getCarInfo];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    //初始化车牌
    [self initCarInfo];
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addScrollView];
    [self addContentViewWithIndex:0];
    [self addSegmentView];
}

- (void)addSegmentView
{
    NSMutableArray *itemsArray = (NSMutableArray *)@[@"违章查询",@"违章记录",@"违章处理"];
    segmentView = [[SDSegmentedControl alloc] initWithItems:itemsArray];
    [segmentView addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SEGMENT_HEIGHT);
    //segmentView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SEGMENT_HEIGHT);
    [self.view addSubview:segmentView];
}

- (void)addScrollView
{
    float start_y = SEGMENT_HEIGHT;
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, start_y, SCREEN_WIDTH, SCREEN_HEIGHT - start_y - NAV_HEIGHT)];
    contentScrollView.backgroundColor = [UIColor clearColor];
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, contentScrollView.frame.size.height);
    [self.view addSubview:contentScrollView];
}

#pragma mark 获取车牌等信息
- (void)getCarInfo
{
    //__weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"car_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]]};
    [request requestWithUrl1:BREAK_INFO_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"breakListResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic]  && ![@"null" isEqualToString:responseDic])
         {
             NSArray *array = [responseDic componentsSeparatedByString:@","];
             if ([array count] == 3)
             {
                [[XSH_Application shareXshApplication] setShortName:[array[0] substringToIndex:2]];
                ((UITextField *)[selectView viewWithTag:1]).text = [array[0] substringWithRange:NSMakeRange(2,[array[0] length] - 2)];
                ((UITextField *)[selectView viewWithTag:2]).text = array[1];
                ((UITextField *)[selectView viewWithTag:3]).text = array[2];
                [self initCarInfo];
                 //需特殊处理请求第三方，对比取出第三方对应的城市ID
                tempListViewController = [[CityListViewController alloc]init];
                tempListViewController.cityScource = CityScourceFromThird;
                [tempListViewController viewDidLoad];
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

#pragma mark 初始化车牌等信息
- (void)initCarInfo
{
    NSString *proString = [[XSH_Application shareXshApplication] shortName];
    NSString *city = [[XSH_Application shareXshApplication] carHeader];
    if (city && ![@"" isEqualToString:city])
    {
        [cityButton setTitle:city forState:UIControlStateNormal];
    }
    else if (proString && ![@"" isEqualToString:proString])
    {
        [cityButton setTitle:proString forState:UIControlStateNormal];
    }
//    UITextField *textfield = (UITextField *)[selectView viewWithTag:1];
//    if (![city isEqualToString:@""])
//    {
//        textfield.text = [city stringByReplacingOccurrencesOfString:proString withString:@""];
//    }
}

#pragma mark 点击分段控件
- (void)segmentedValueChanged:(SDSegmentedControl *)segment
{
    [self addContentViewWithIndex:(int)segment.selectedSegmentIndex];
}

#pragma mark 添加视图
- (void)addContentViewWithIndex:(int)index
{
    [contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0)];
    if (index != 0)
    {
        currentPage = 1;
        moreButton.enabled = YES;
        self.dataArray = nil;
    }
    switch (index)
    {
        case 0:
            [self addSelectView];
            break;
        case 1:
            [self getBreakDataWithType:1];
            [self addRecordView];
            break;
        case 2:
            [self getBreakDataWithType:2];
            [self addDealView];
            break;
        default:
            break;
    }
}

- (void)addSelectView
{
    if (!selectView)
    {
        NSArray *titleArray = @[@" 车牌号码:",@" 车架号码:",@" 发动机号:"];
        NSArray *deArray = @[@"请输入完整的车牌号",@"请输入车架号后6位",@"请输入完整发动机号"];
        selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, contentScrollView.frame.size.height)];

        float height = 0.0;
        
        for (int i = 0; i < [titleArray count]; i++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,5 + (35 + 9)*i, 80, 35)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16.0];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = titleArray[i];
            [selectView addSubview:label];
            
            float x = label.frame.origin.x + label.frame.size.width;
            float w = 200;
            if (i == 0)
            {
                UIImage *image = [UIImage imageNamed:@"arrow.png"];
                cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
                cityButton.frame = CGRectMake(label.frame.size.width - 3, label.frame.origin.y + 2, image.size.width/4, image.size.height/4);
                [cityButton setTitle:@"粤B" forState:UIControlStateNormal];
                [cityButton addTarget:self action:@selector(showCity) forControlEvents:UIControlEventTouchUpInside];
                [cityButton setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
                [selectView addSubview:cityButton];
                x += 32.0;
                w = 190.0;
            }
            else
            {
                w = 225.0;
            }
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(x,label.frame.origin.y, w, 35)];
            textField.tag = i + 1;
            textField.placeholder = [deArray objectAtIndex:i];
            textField.returnKeyType =  UIReturnKeyDone;
            textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            UIView *left  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, textField.frame.size.height)];
            textField.leftView = left;
            textField.font = [UIFont systemFontOfSize:14.0];
            textField.leftViewMode = UITextFieldViewModeAlways;
            [textField addTarget:self action:@selector(exitEvent:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [selectView addSubview:textField];
            
            UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, textField.frame.origin.y + textField.frame.size.height + 4,SCREEN_WIDTH , .5)];
            lineImageView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7];
            [selectView addSubview:lineImageView];
            
            
            height = label.frame.origin.y + 35 + 20;
        }
    
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, height, SCREEN_WIDTH - 20 * 2, 35)];
        //[button setBackgroundImage:image forState:UIControlStateNormal];
        button.backgroundColor = APP_MAIN_COLOR;
        button.showsTouchWhenHighlighted = YES;
        [button setTitle:@"开始查询" forState:UIControlStateNormal];
        button.titleLabel.font = FONT(16.0);
        [CommonTool clipView:button withCornerRadius:5.0];
        [button addTarget:self action:@selector(commitButtonPressed) forControlEvents:UIControlEventTouchDown];
        [selectView addSubview:button];
        
        [contentScrollView addSubview:selectView];
    }
}

- (void)addRecordView
{
    if (!recordTable)
    {
        recordTable=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 1, 0.0, SCREEN_WIDTH, contentScrollView.frame.size.height) style:UITableViewStylePlain];
        recordTable.dataSource=self;
        recordTable.delegate=self;
        recordTable.backgroundColor = [UIColor clearColor];
        [contentScrollView insertSubview:recordTable atIndex:0];
    }

}

- (void)addDealView
{
    if (!dealTable)
    {
        dealTable=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0.0, SCREEN_WIDTH, contentScrollView.frame.size.height) style:UITableViewStylePlain];
        dealTable.dataSource=self;
        dealTable.delegate=self;
        dealTable.backgroundColor = [UIColor clearColor];
        [contentScrollView insertSubview:dealTable atIndex:0];
    }
}


- (void)setFootViewForTable:(UITableView *)table
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    footView.backgroundColor = [UIColor clearColor];
    moreButton = [CreateViewTool createButtonWithFrame:CGRectMake(20, (footView.frame.size.height - 20)/2, SCREEN_WIDTH - 20 * 2, 20) buttonTitle:@"点击加载更多" titleColor:[UIColor grayColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"getMoreData" tagDelegate:self];
    moreButton.titleLabel.font = FONT(15.0);
    [footView addSubview:moreButton];
    table.tableFooterView = footView;
}

#pragma mark 城市列表
- (void)showCity
{
    CityListViewController *cityListViewController = [[CityListViewController alloc]init];
    UINavigationController  *nav = [[UINavigationController alloc] initWithRootViewController:cityListViewController];
    cityListViewController.cityScource = CityScourceFromThird;
    [self presentViewController:nav animated:YES completion:Nil];
}


#pragma mark 键盘消失
- (void)exitEvent:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)returnKeyboard
{
    [((UITextField *)[selectView viewWithTag:1]) resignFirstResponder];
    [((UITextField *)[selectView viewWithTag:2]) resignFirstResponder];
    [((UITextField *)[selectView viewWithTag:3]) resignFirstResponder];
}

#pragma mark 查询按钮
- (void)commitButtonPressed
{
    [self returnKeyboard];
    NSString *carNo = ((UITextField *)[selectView viewWithTag:1]).text;
    NSString *classNo = ((UITextField *)[selectView viewWithTag:2]).text;
    NSString *engineNo = ((UITextField *)[selectView viewWithTag:3]).text;
    NSLog(@"classNo===%@==classNo＝＝%@==engineNo====%@",classNo,classNo,engineNo);
    NSString *message = @"";
    NSString *carString = [[cityButton titleForState:UIControlStateNormal] stringByAppendingString:carNo];
    if (!carNo && [carNo isEqualToString:@""])
    {
        message = @"请输入车牌号";
    }
    else if (!classNo || [classNo isEqualToString:@""])
    {
        message = @"请输入车架号码";
    }
    else if (!engineNo || [engineNo isEqualToString:@""])
    {
        message = @"请输入发动机号";
    }
    else if (carString.length != 7)
    {
        message = @"请输入正确的车牌号";
    }
//    else if (classNo.length != 6)
//    {
//        message = @"请输后6位车架号";
//    }
    if (![message isEqualToString:@""])
    {
        [CommonTool addAlertTipWithMessage:message];
        return;
    }
    NSNumber *cityNumber = [[XSH_Application shareXshApplication] carCity];
    NSString *cityStr = @"";
    if (!cityNumber)
    {
        cityStr = @"152";
    }
    else
    {
        int cityID = [cityNumber intValue];
        cityStr = [NSString stringWithFormat:@"%d",cityID];
    }
    
    NSString *appKey = APP_KEY;
    NSString *urlStr = BREAK_SELECT_URL;
    NSString *car_info = [NSString stringWithFormat:@"{hphm=%@&classno=%@&engineno=%@&registno=&city_id=%@&car_type=02}",[[cityButton titleForState:UIControlStateNormal] stringByAppendingString:carNo],classNo,engineNo,cityStr];
    //NSString *car_info = [NSString stringWithFormat:@"{hphm=%@&classno=%@&engineno=%@&registno=&city_id=152&car_type=02}",@"粤BF176F",@"302947",@"0788"];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString *appID = APP_ID;
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",appID,car_info,timeStr,appKey];
    NSLog(@"car_info====%@",car_info);
    sign = [CommonTool md5:sign];
    
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@car_info=%@&sign=%@&timestamp=%@&app_id=%@",urlStr,[CommonTool encodeToPercentEscapeString:car_info],sign,timeStr,appID];
    NSLog(@"requestUrlStr====%@",requestUrlStr);

    [self getBreakListWithUrl:requestUrlStr];
}

#pragma mark 获取违章数据
- (void)getBreakListWithUrl:(NSString *)urlStr
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:urlStr requestParamas:nil requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"breakListResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             int status = [[responseDic objectForKey:@"status"] intValue];
             if (status == 2001)
             {
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
                 NSArray *array = [responseDic objectForKey:@"historys"];
                 if (array && [array count] > 0)
                 {
                     weakSelf.dataArray = [NSMutableArray array];
                     BreakListViewController *breakListVC = [[BreakListViewController alloc] init];
                     breakListVC.dataArray = weakSelf.dataArray;
                     UINavigationController *nav = [[UINavigationController  alloc] initWithRootViewController:breakListVC];
                     [weakSelf presentViewController:nav animated:YES completion:Nil];
                 }
             }
             else if (status == 2000)
             {
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP duration:.1];
                 [CommonTool addAlertTipWithMessage:@"暂无违章记录"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
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


#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self returnKeyboard];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == contentScrollView)
    {
        int page = scrollView.contentOffset.x/SCREEN_WIDTH;
        
        if (page == segmentView.selectedSegmentIndex)
        {
            return;
        }
        segmentView.selectedSegmentIndex = page;
        [self addContentViewWithIndex:page];
    }
}


#pragma mark 加载更多
- (void)getMoreData
{
    currentPage++;
    [self getBreakDataWithType:(int)segmentView.selectedSegmentIndex];
}


#pragma mark 查询违章记录和处理纪录 1:normal 2:deal
- (void)getBreakDataWithType:(int)type
{
    NSString *urlStr = nil;
    if (type == 1)
    {
        urlStr = BREAK_LIST_URL;
    }
    else if (type == 2)
    {
        urlStr = DEAL_BREAK_URL;
    }
    __weak __typeof(self) weakSelf = self;
    moreButton.enabled = NO;
    if (currentPage == 1)
    {
        [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    }
    NSDictionary *requestDic = @{@"uid":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"currentPage":[NSNumber numberWithInt:currentPage]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:urlStr requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"breakResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             if (currentPage == 1)
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             [weakSelf loadBreakData:responseDic];
         }
         else
         {
             moreButton.enabled = YES;
             //失败
             if (currentPage == 1)
             {
                 [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
             }
             if (currentPage > 1)
             {
                 currentPage--;
             }
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         moreButton.enabled = YES;
         if (currentPage > 1)
         {
             currentPage--;
         }
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
     }];

}


#pragma mark 加载违章查询和处理违章数据
- (void)loadBreakData:(NSDictionary *)responseDic
{
    NSMutableArray *dataArray = (NSMutableArray *)[responseDic objectForKey:@"list"];
    UITableView *table = nil;
    if (segmentView.selectedSegmentIndex == 1)
    {
        table = recordTable;
    }
    if (segmentView.selectedSegmentIndex == 2)
    {
        table = dealTable;
    }
    
    if (([dataArray count] == 0 || !dataArray) && currentPage == 1)
    {
        //暂无数据
        [CommonTool addAlertTipWithMessage:@"暂无数据"];
    }
    else if (dataArray)
    {
        if (currentPage == 1)
        {
            [self setFootViewForTable:table];
        }
        if (!self.dataArray)
        {
            self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        }
        else
        {
            [self.dataArray addObjectsFromArray:dataArray];
        }
    }
    
    int countPage = [[responseDic objectForKey:@"countpage"] intValue];
    if (countPage <= currentPage)
    {
        //最后一页
        [table setTableFooterView:nil];
    }
    moreButton.enabled = YES;
    [table reloadData];
}

#pragma mark 获取高度
- (float)getHeightWithString:(NSString *)text
{
    CGSize size = [text sizeWithFont:FONT(16.0) constrainedToSize:CGSizeMake(230, 20000)];
    NSLog(@"size.height===%.0f",size.height);
    if (size.height + 10 > 40.0)
        return  size.height + 10;
    else
        return 40.0;
}

#pragma mark tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 1)
    {
        return [self getHeightWithString:[dic objectForKey:@"brAddress"]];
    }
    else if (indexPath.row == 5)
    {
        return [self getHeightWithString:[dic objectForKey:@"brReason"]];
    }
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"违章%d:",(int)section + 1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    BreakCell *cell = (BreakCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[BreakCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    [cell setDescLabelFrame];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    cell.descLabel.textColor = [UIColor blackColor];
    switch (indexPath.row)
    {
        case 0:
            cell.titleLabel.text = @"违规时间:";
            cell.descLabel.text = [dic objectForKey:@"brTimestr"];
            break;
        case 1:
            cell.titleLabel.text = @"违规地点:";
            cell.descLabel.text = [dic objectForKey:@"brAddress"];
            break;
        case 2:
            cell.titleLabel.text = @"违规扣分:";
            cell.descLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"brScore"]];
            break;
        case 3:
            cell.titleLabel.text = @"违规罚款:";
            cell.descLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"brFine"]];
            break;
        case 4:
            cell.titleLabel.text = @"是否处理:";
            cell.descLabel.textColor = [UIColor redColor];
            cell.descLabel.text = [[dic objectForKey:@"brDealstatus"] isEqualToString:@"Y"] ? @"已处理":@"未处理";
            break;
        case 5:
            cell.titleLabel.text = @"违规原因:";
            cell.descLabel.text = [dic objectForKey:@"brReason"];
            break;
        default:
            break;
    }
    return cell;
}




- (void)didReceiveMemoryWarning {
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
