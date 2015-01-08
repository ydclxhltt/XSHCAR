//
//  MessageDetailViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/27.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "BugTipListCell.h"


@interface MessageDetailViewController ()
{
    int currentPage;
    UIButton *moreButton;
}
@end

@implementation MessageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置返回item
    [self addBackItem];
    //初始化数据
    currentPage = 1;
    //初始化UI
    [self createUI];
    //获取相关数据
    [self getMessageData];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addGetMoreView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    footView.backgroundColor = [UIColor clearColor];
    moreButton = [CreateViewTool createButtonWithFrame:CGRectMake(20, (footView.frame.size.height - 20)/2, SCREEN_WIDTH - 20 * 2, 20) buttonTitle:@"点击加载更多" titleColor:[UIColor grayColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"getMoreData" tagDelegate:self];
    moreButton.titleLabel.font = FONT(15.0);
    [footView addSubview:moreButton];
    self.table.tableFooterView = footView;
}



#pragma mark 获取详情数据
- (void)getMessageData
{
    __weak __typeof(self) weakSelf = self;
    moreButton.enabled = NO;
    if (currentPage == 1)
    {
        [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    }
    NSDictionary *requestDic = @{@"sms_id":[NSNumber numberWithInt:self.smsID],@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"pageno":[NSNumber numberWithInt:currentPage]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MESSAGE_DETAIL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"messageDetailResponseDic===%@",operation.responseString);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             if (currentPage == 1)
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             [weakSelf reloadDataWithDic:responseDic];
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


#pragma mark 加载更多
- (void)getMoreData
{
    currentPage++;
    [self getMessageData];
}

#pragma mark 刷新数据
- (void)reloadDataWithDic:(NSDictionary *)dataDic
{
    NSMutableArray *dataArray = (NSMutableArray *)[dataDic objectForKey:@"smsInforList"];
    
    if (([dataArray count] == 0 || !dataArray) && currentPage == 1)
    {
        //暂无数据
        [CommonTool addAlertTipWithMessage:@"暂无数据"];
    }
    else if (dataArray)
    {
        if (currentPage == 1)
        {
            [self addGetMoreView];
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
    
    int countPage = [[dataDic objectForKey:@"countpage"] intValue];
    if (countPage == currentPage)
    {
        //最后一页
        [self.table setTableFooterView:nil];
    }
    else
    {
        [moreButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
        moreButton.enabled = YES;
    }
    [self.table reloadData];
}



#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 25.0;
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataArray[section];
    NSString *time = [dic objectForKey:@"createtime"];
    time = (time) ? time : @"";
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0) textString:time textColor:[UIColor grayColor] textFont:FONT(15.0)];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    NSString *textString = [rowDic objectForKey:@"smsinforContent"];
    float height = [CommonTool labelHeightWithText:textString textFont:FONT(15.0) labelWidth:SCREEN_WIDTH - 10 * 2] + 10;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"bugTipCellID";
    
    BugTipListCell *cell = (BugTipListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[BugTipListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    [cell setLabelTextWithTitle:@"" contentText:[rowDic objectForKey:@"smsinforContent"]];
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
