//
//  HistoryListViewController.m
//  XSHCar
//
//  Created by clei on 14/12/31.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HistoryListViewController.h"
#import "CLPickerView.h"
#import "HistoryDetailViewController.h"

@interface HistoryListViewController ()
{
    UIButton *moreButton;
    BOOL isEndDate;
    int currentPage;
}
@end

@implementation HistoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"历史行程";
    //设置返回Item
    [self addBackItem];
    //添加UI
    [self createUI];
    //初始化数据
    currentPage = 1;
    //获取数据
    [self getHistoryList];
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


#pragma mark 设置左视图
- (UILabel *)addLeftViewWithText:(NSString *)text
{
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, 40.0, 30) textString:text textColor:[UIColor grayColor] textFont:FONT(14.0)];
    return label;
}




#pragma mark 获取历史数据
- (void)getHistoryList
{
    [moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    moreButton.enabled = NO;
    if (currentPage == 1)
    {
         [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    }
    __weak __typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"cId":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]],@"beginDate":@"2014-12-01",@"endDate":@"2014-12-31",@"currentPage":[NSNumber numberWithInt:currentPage]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:HISTORY_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
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
    [self getHistoryList];
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
        [moreButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
        moreButton.enabled = YES;
    }
    [self.table reloadData];
}


#pragma mark sectionView

- (UIImageView *)setSectionView
{
    UIImageView *sectionView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35.0) placeholderImage:nil];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIColor *fontColor = [UIColor grayColor];
    UILabel *ctrIdLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, 60.0, sectionView.frame.size.height) textString:@"ID" textColor:fontColor textFont:FONT(16.0)];
    ctrIdLabel.textAlignment = NSTextAlignmentCenter;
    [sectionView addSubview:ctrIdLabel];
    
    UIButton *detailButton = [CreateViewTool createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60.0, sectionView.frame.size.height) buttonTitle:@"详情" titleColor:fontColor normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"detailButtonPressed:" tagDelegate:self];
    detailButton.titleLabel.font = FONT(15.0);
    [sectionView addSubview:detailButton];
    
    float width = (SCREEN_WIDTH - ctrIdLabel.frame.size.width - detailButton.frame.size.width)/2;
    
    UILabel *startLabel = [CreateViewTool createLabelWithFrame:CGRectMake(ctrIdLabel.frame.size.width, 0, width, sectionView.frame.size.height) textString:@"起始时间" textColor:fontColor textFont:FONT(16.0)];
    startLabel.tag = 101;
    startLabel.textAlignment = NSTextAlignmentCenter;
    [sectionView addSubview:startLabel];
    
    UILabel *endLabel = [CreateViewTool createLabelWithFrame:CGRectMake(startLabel.frame.origin.x + width, 0, width, sectionView.frame.size.height) textString:@"结束时间" textColor:fontColor textFont:FONT(16.0)];
    endLabel.tag = 102;
    endLabel.textAlignment = NSTextAlignmentCenter;
    [sectionView addSubview:endLabel];
    
    return sectionView;
}


#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setSectionView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"historyCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UILabel *ctrIdLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *startLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *endLabel = (UILabel *)[cell.contentView viewWithTag:102];
    UIButton *detailButton = (UIButton *)[cell.contentView viewWithTag:103 + indexPath.row];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIColor *fontColor = [UIColor blackColor];
        UIColor *lineColor = [UIColor lightGrayColor];
        
        ctrIdLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, 60.0, cell.frame.size.height) textString:@"1" textColor:fontColor textFont:FONT(15.0)];
        ctrIdLabel.tag = 100;
        ctrIdLabel.textAlignment = NSTextAlignmentCenter;
        [CommonTool setViewLayer:ctrIdLabel withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:ctrIdLabel];
        
        detailButton = [CreateViewTool createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60.0, cell.frame.size.height) buttonTitle:@"详情" titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:[UIColor lightGrayColor] selectorName:@"detailButtonPressed:" tagDelegate:self];
        detailButton.tag = 103 + indexPath.row;
        detailButton.titleLabel.font = FONT(15.0);
        [CommonTool setViewLayer:detailButton withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:detailButton];
        
        float width = (SCREEN_WIDTH - ctrIdLabel.frame.size.width - detailButton.frame.size.width)/2;
        
        startLabel = [CreateViewTool createLabelWithFrame:CGRectMake(ctrIdLabel.frame.size.width, 0, width, cell.frame.size.height) textString:@"" textColor:fontColor textFont:FONT(15.0)];
        startLabel.tag = 101;
        startLabel.textAlignment = NSTextAlignmentCenter;
        [CommonTool setViewLayer:startLabel withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:startLabel];
        
        endLabel = [CreateViewTool createLabelWithFrame:CGRectMake(startLabel.frame.origin.x + width, 0, width, cell.frame.size.height) textString:@"" textColor:fontColor textFont:FONT(15.0)];
        endLabel.tag = 102;
        endLabel.textAlignment = NSTextAlignmentCenter;
        [CommonTool setViewLayer:endLabel withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:endLabel];
        
    }
    
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    ctrIdLabel.text = [NSString stringWithFormat:@"%@",[rowDic objectForKey:@"ctrId"]];
    startLabel.text = ([@"" isEqualToString:[rowDic objectForKey:@"ctrStartdatetime"]]) ? @"未知" : [rowDic objectForKey:@"ctrStartdatetime"];
    endLabel.text = ([@"" isEqualToString:[rowDic objectForKey:@"ctrEnddatetime"]]) ? @"未知" : [rowDic objectForKey:@"ctrEnddatetime"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 详情按钮响应事件
- (void)detailButtonPressed:(UIButton *)sender
{
    int index = (int)sender.tag - 103;
    NSDictionary *rowDic = self.dataArray[index];
    NSString *ctrId = [rowDic objectForKey:@"ctrId"];
    HistoryDetailViewController *detailViewController = [[HistoryDetailViewController alloc] init];
    detailViewController.ctrId = ctrId;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
