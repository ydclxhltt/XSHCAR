//
//  ExcitingActivitiesViewController.m
//  XSHCar
//
//  Created by clei on 14/12/19.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "ExcitingActivitiesViewController.h"
#import "ExcitingListCell.h"
#import "ExcitingActivityDetailViewController.h"

@interface ExcitingActivitiesViewController ()
{
    int currentPage;
    UIButton *moreButton;
}
@end

@implementation ExcitingActivitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化数据
    currentPage = 1;
    //初始化UI
    [self createUI];

    //获取数据
    [self getDataList];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
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


#pragma mark 获取数据
- (void)getDataList
{
    __weak __typeof(self) weakSelf = self;
    moreButton.enabled = NO;
    if (currentPage == 1)
    {
        [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    }
    NSDictionary *requestDic = @{@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"currentPage":[NSNumber numberWithInt:currentPage],@"pageNum":[NSNumber numberWithInt:10]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:EXCITING_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"excitingResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
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

#pragma mark 刷新数据
- (void)reloadDataWithDic:(NSDictionary *)dataDic
{
    NSMutableArray *dataArray = (NSMutableArray *)[dataDic objectForKey:@"list"];
    
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
        moreButton.enabled = YES;
    }
    [self.table reloadData];
}

#pragma mark 加载更多
- (void)getMoreData
{
    currentPage++;
    [self getDataList];
}


#pragma mark - tableView代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"excitingCellID";
    
    ExcitingListCell *cell = (ExcitingListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[ExcitingListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
    }
    NSDictionary *rowDataDic = self.dataArray[indexPath.row];
    NSString *imageUrl = [rowDataDic objectForKey:@"mdtTopimage"];
    imageUrl = @"http://211.154.155.29:8086/epg30/selfadaimg.do?path=/pgicon/20141222/3066944/144209.jpg";
    [cell setCellDataWithImageUrl:imageUrl titleText:[rowDataDic objectForKey:@"mdtTitle"] contentText:[rowDataDic objectForKey:@"mdtContent"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    ExcitingActivityDetailViewController *detailViewController = [[ExcitingActivityDetailViewController alloc]init];
    detailViewController.title = [dic objectForKey:@"mdtTitle"];
    detailViewController.detailText = [dic objectForKey:@"mdtContent"];
    [self.navigationController pushViewController:detailViewController animated:YES];
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
