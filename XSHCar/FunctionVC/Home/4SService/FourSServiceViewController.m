//
//  4SServiceViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//
#define SEGMENT_HEIGHT 40.0
#import "FourSServiceViewController.h"
#import "ExcitingActivityDetailViewController.h"
#import "SDSegmentedControl.h"
#import "MobileStoreCell.h"
#import "ExcitingListCell.h"
#import "AboutMeViewController.h"

@interface FourSServiceViewController ()
{
    int currentPage;
    int ncID;
    int lastSelectedIndex;
    UIButton *moreButton;
    SDSegmentedControl *segmentControl;
}
@property(nonatomic, strong) NSArray *sortArray;
@end

@implementation FourSServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加返回item
    [self addBackItem];
    //数据初始化
    currentPage = 1;
    ncID = 0;
    startHeight = 0;
    lastSelectedIndex = 0;
    //获取4s信息
    [self get4sData];
    // Do any additional setup after loading the view.
}

#pragma mark 获取4s信息
- (void)get4sData
{
    __weak __typeof(self) weakSelf = self;
    if (currentPage == 1)
        [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    NSDictionary *requestDic = @{@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"currentPage":[NSNumber numberWithInt:currentPage],@"nc_id":[NSNumber numberWithInt:ncID]};
    NSLog(@"MOBILE_STORE_URL===%@",MOBILE_STORE_URL);
    NSLog(@"requestDic===%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:GET_4S_DATA_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"4sResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             if (currentPage == 1)
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             NSArray *array = [responseDic objectForKey:@"newCatagoryList"];
             if (array && [array count] > 0)
             {
                 weakSelf.sortArray = [NSArray arrayWithArray:array];
                 NSMutableArray *titleArray = [NSMutableArray array];
                 for (NSDictionary *dic in weakSelf.sortArray)
                 {
                     [titleArray addObject:[dic objectForKey:@"ncName"]];
                 }
                 [weakSelf createUIWithArray:titleArray];
                 
             }
             else
             {
                 [weakSelf createUI];
             }
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
             //moreButton.enabled = YES;
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         if (currentPage == 1)
             [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         //moreButton.enabled = YES;
         if (currentPage > 1)
         {
             currentPage--;
         }
         NSLog(@"error===%@",error);
     }];
}


#pragma mark 初始化UI

- (void)createUI
{
    [self addTableView];
}

- (void)createUIWithArray:(NSArray *)array
{
    [self addSegmentViewWithArray:array];
    [self addTableView];
}

- (void)addSegmentViewWithArray:(NSArray *)array
{
    
    if (!segmentControl)
    {
        startHeight = NAV_HEIGHT;
        segmentControl = [[SDSegmentedControl alloc] initWithItems:array];
        [segmentControl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
        segmentControl.selectedSegmentIndex = lastSelectedIndex;
        segmentControl.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SEGMENT_HEIGHT);
        [self.view addSubview:segmentControl];
        
        startHeight += SEGMENT_HEIGHT;
    }
    


}

- (void)addTableView
{
    if (!self.table)
    {
        [self addTableViewWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH, SCREEN_HEIGHT - startHeight) tableType:UITableViewStylePlain tableDelegate:self];
    }
}

//重构基类方法
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate
{
    self.table=[[UITableView alloc]initWithFrame:frame style:type];
    self.table.dataSource=delegate;
    self.table.delegate=delegate;
    self.table.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.table atIndex:0];
    
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




#pragma mark 加载更多
- (void)getMoreData
{
    currentPage++;
    [self get4sData];
}

#pragma mark 刷新数据
- (void)reloadDataWithDic:(NSDictionary *)dataDic
{
    NSMutableArray *dataArray = (NSMutableArray *)[dataDic objectForKey:@"messageNewCatagoryBean"];
    
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


#pragma mark segment事件
- (void)segmentedValueChanged:(SDSegmentedControl *)segmentView
{
    if (lastSelectedIndex == segmentView.selectedSegmentIndex)
    {
        return;
    }
    lastSelectedIndex = (int)segmentView.selectedSegmentIndex;
    currentPage = 1;
    self.dataArray = nil;
    [self.table reloadData];
    NSDictionary *dic = self.sortArray[segmentView.selectedSegmentIndex];
    NSLog(@"dic===%@",dic);
    ncID = [[dic objectForKey:@"ncId"] intValue];
    [self get4sData];
    
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
    static NSString *cellID = @"4sCellID";
    
    //MobileStoreCell *cell = (MobileStoreCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    ExcitingListCell *cell = (ExcitingListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        //cell = [[MobileStoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell = [[ExcitingListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,[rowDic objectForKey:@"mdtTopimage"]];
    NSLog(@"url===%@",url);
    NSString *title = ([rowDic objectForKey:@"mdtTitle"]) ? [rowDic objectForKey:@"mdtTitle"] : @"";
    //NSString *content = ([rowDic objectForKey:@"mdtIntrdouct"]) ? [rowDic objectForKey:@"mdtIntrdouct"] : [rowDic objectForKey:@"mdtTitle"];
    NSString *time = ([rowDic objectForKey:@"mdtPushtime"]) ? [rowDic objectForKey:@"mdtPushtime"] : @"";
    //[cell setCellDataWithImageUrl:url titleText:title contentText:content priceText:time];
    [cell setCellDataWithImageUrl:url titleText:title contentText:time];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *title = [dic objectForKey:@"mdtTitle"];
    title = (title) ? title : @"";
    NSString *content = [dic objectForKey:@"mdtContent"];
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
