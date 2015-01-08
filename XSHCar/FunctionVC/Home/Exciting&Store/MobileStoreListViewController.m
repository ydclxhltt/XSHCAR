//
//  MobileStoreListViewController.m
//  XSHCar
//
//  Created by chenlei on 15/1/1.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "MobileStoreListViewController.h"
#import "ExcitingActivityDetailViewController.h"
#import "MobileStoreCell.h"
#import "AboutMeViewController.h"

@interface MobileStoreListViewController ()
{
    int currentPage;
    UIButton *moreButton;
}
@end

@implementation MobileStoreListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化数据
    currentPage = 1;
    //初始化UI
    [self createUI];
    //加载数据
    [self getMobileStoreListWithCatagory];
    // Do any additional setup after loading the view.
}

#pragma mark 添加返回Item
- (void)backButtonPressed:(UIButton *)sender
{
    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:viewController animated:YES];
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


#pragma mark 获取移动商城列表
- (void)getMobileStoreListWithCatagory
{
    __weak __typeof(self) weakSelf = self;
    if (currentPage == 1)
        [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    NSDictionary *requestDic = @{@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"catagory_id":[NSNumber numberWithInt:self.spcID],@"pageno":[NSNumber numberWithInt:currentPage]};
    NSLog(@"MOBILE_STORE_URL===%@",MOBILE_STORE_URL);
    NSLog(@"requestDic===%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MOBILE_STORE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"historyResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             if (currentPage == 1)
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             [weakSelf reloadDataWithDic:responseDic];
         }
         else
         {
             //服务器异常
             if (currentPage > 1)
             {
                 currentPage--;
             }
             if (currentPage == 1)
                 [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
             moreButton.enabled = YES;
         }
     
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         if (currentPage == 1)
             [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         moreButton.enabled = YES;
         if (currentPage > 1)
         {
             currentPage--;
         }
         NSLog(@"error===%@",error);
     }];
}

#pragma mark 加载更多
- (void)getMoreData
{
    currentPage++;
    [self getMobileStoreListWithCatagory];
}

#pragma mark 刷新数据
- (void)reloadDataWithDic:(NSDictionary *)dataDic
{
    NSMutableArray *dataArray = (NSMutableArray *)[dataDic objectForKey:@"productList"];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"listCellID";
    
    MobileStoreCell *cell = (MobileStoreCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[MobileStoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,[dic objectForKey:@"p_indeximg"]];
    NSLog(@"url===%@",url);
    NSString *title = ([dic objectForKey:@"p_name"]) ? [dic objectForKey:@"p_name"] : @"";
    NSString *content = ([dic objectForKey:@"p_content"]) ? [dic objectForKey:@"p_content"] : @"";
    NSString *price = ([dic objectForKey:@"p_price"]) ? [dic objectForKey:@"p_price"] : @"";
    price = [NSString stringWithFormat:@"价格:%@元",price];
    [cell setCellDataWithImageUrl:url titleText:title contentText:content priceText:price];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *title = [dic objectForKey:@"p_name"];
    title = (title) ? title : @"";
    NSString *content = [dic objectForKey:@"p_introduct"];
    content = (title) ? content : @"";
    /*
     * 修改为加载html片段，废弃此页面
         ExcitingActivityDetailViewController *detailViewController = [[ExcitingActivityDetailViewController alloc]init];
         detailViewController.title = title;
         detailViewController.detailText = content;
         [self.navigationController pushViewController:detailViewController animated:YES];
     */
    AboutMeViewController *detailViewController = [[AboutMeViewController alloc] init];
    detailViewController.title = title;
    detailViewController.contentString = content;
    detailViewController.dataArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"productImg"]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    //p_introduct
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
