//
//  MobileStoreViewController.m
//  XSHCar
//
//  Created by clei on 14/12/19.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MobileStoreViewController.h"
#import "MobileStoreSortViewController.h"
#import "MobileStoreListViewController.h"

@interface MobileStoreViewController ()

@end

@implementation MobileStoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化UI
    [self createUI];
    //加载数据
    [self getMobileStoreListWithCatagory:0];
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

#pragma mark 获取移动商城列表
- (void)getMobileStoreListWithCatagory:(int)catagoryID
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    NSDictionary *requestDic = @{@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"catagory_id":[NSNumber numberWithInt:catagoryID],@"pageno":[NSNumber numberWithInt:1]};
    NSLog(@"MOBILE_STORE_URL===%@",MOBILE_STORE_URL);
    NSLog(@"requestDic===%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MOBILE_STORE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"storeResponseDic===%@",operation.responseString);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             NSArray *array = [responseDic objectForKey:@"oneShopCatagorys"];
             if (!array || [array count] == 0)
             {
                 [CommonTool addAlertTipWithMessage:@"暂无数据"];
                 return;
             }
             weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
             [weakSelf.table reloadData];
         }
         else
         {
            [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         }
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
    }];

}

#pragma mark - tableView代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"sortCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *string = [dic objectForKeyedSubscript:@"spcs_name"];
    cell.textLabel.text = (string) ? string : @"";
    //cell.textLabel.font = FONT(16.0);
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSArray *array = [dic objectForKeyedSubscript:@"twoShopCatagorys"];
    if (!array || [array count] == 0)
    {
        //直接请求
        MobileStoreListViewController *listViewController = [[MobileStoreListViewController alloc] init];
        listViewController.spcID = [[dic objectForKey:@"spcs_id"] intValue];
        listViewController.title = [dic  objectForKey:@"spcs_name"];
        listViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    else
    {
        //下一级
        MobileStoreSortViewController *sortViewController = [[MobileStoreSortViewController alloc] init];
        sortViewController.level = 2;
        sortViewController.dataArray = [NSMutableArray arrayWithArray:array];
        sortViewController.hidesBottomBarWhenPushed = YES;
        NSString *title = [dic objectForKey:@"spcs_name"];
        sortViewController.title = (title && ![@"" isEqualToString:title]) ? title : @"分类";
        [self.navigationController pushViewController:sortViewController animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
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
