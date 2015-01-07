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
    BOOL isLeft;
    UIButton *leftButton,*rightButton;
    CLPickerView *pickView;
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
    [self addTableViewHeader];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}


- (void)addTableViewHeader
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43) placeholderImage:nil];
    imageView.userInteractionEnabled = YES;
    [self.table setTableHeaderView:imageView];
    
    startHeight = 0.0;
    float label_width = 20.0;
    float left_x = (SCREEN_WIDTH - label_width)/2;
    float label_heigh = 35.0;
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, startHeight, label_width, label_heigh) textString:@"至" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    
    float buttonWidth = 140.0;
    float leftButton_left_x = left_x - buttonWidth;
    float add_y = 5.0;
    float left_y = startHeight + add_y;
    NSDate *nowDate = [NSDate date];
    NSDate *lastDate = [NSDate dateWithTimeInterval:- 30 * 24 * 60 * 60 sinceDate:nowDate];
    leftButton = [CreateViewTool createButtonWithFrame:CGRectMake(leftButton_left_x, left_y, buttonWidth, label_heigh - add_y) buttonTitle:[CommonTool getStringFromDate:lastDate formatterString:@"yyyy-MM-dd"] titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"dateButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:leftButton withLayerColor:APP_MAIN_COLOR bordWidth:.5];
    [CommonTool clipView:leftButton withCornerRadius:5.0];
    [imageView addSubview:leftButton];
    
    float rightButton_left_x = left_x + label_width;
    rightButton = [CreateViewTool createButtonWithFrame:CGRectMake(rightButton_left_x, left_y, buttonWidth, label_heigh - add_y) buttonTitle:[CommonTool getStringFromDate:nowDate formatterString:@"yyyy-MM-dd"] titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"dateButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:rightButton withLayerColor:APP_MAIN_COLOR bordWidth:.5];
    [CommonTool clipView:rightButton withCornerRadius:5.0];
    [imageView addSubview:rightButton];
    
    UIImageView *lineView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, imageView.frame.size.height - 1, SCREEN_WIDTH, .5) placeholderImage:nil];
    lineView.backgroundColor  = [UIColor lightGrayColor];
    [imageView addSubview:lineView];
}

- (void)addPickView
{
    if (pickView)
    {
        [UIView animateWithDuration:.3 animations:^{pickView.frame = CGRectMake(0, SCREEN_HEIGHT - 240.0, SCREEN_WIDTH, 240.0);}];
        return;
    }
    pickView =  [[CLPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 240.0, SCREEN_WIDTH, 240.0) pickerViewType:PickerViewTypeDate sureBlock:^(UIDatePicker *datePicker,NSDate *date)
                 {
                     NSDate *rightDate;
                     NSDate *leftDate;
                     if (isLeft)
                     {
                         rightDate = [date dateByAddingTimeInterval:30 * 24 * 60 * 60];
                         if ([rightDate compare:[NSDate date]] != NSOrderedAscending)
                         {
                             rightDate = [NSDate date];
                         }
                         leftDate =date;
                     }
                     else
                     {
                         leftDate = [date dateByAddingTimeInterval:- 30 * 24 * 60 * 60];
                         rightDate = date;
                         
                     }
                     [leftButton setTitle:[CommonTool getStringFromDate:leftDate formatterString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
                     [rightButton setTitle:[CommonTool getStringFromDate:rightDate formatterString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
                     [UIView animateWithDuration:.3 animations:^{pickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240.0);}];
                     currentPage = 1;
                     [self getHistoryList];
                 }
                cancelBlock:^
                 {
                     [UIView animateWithDuration:.3 animations:^{pickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240.0);}];
                 }];
    [pickView setPickViewMaxDate];
    [self.view addSubview:pickView];
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
    NSDictionary *requestDic = @{@"cId":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]],@"beginDate":[leftButton titleForState:UIControlStateNormal],@"endDate":[rightButton titleForState:UIControlStateNormal],@"currentPage":[NSNumber numberWithInt:currentPage]};
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
        self.dataArray = nil;
        self.table.tableFooterView = nil;
        [self.table reloadData];
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


#pragma mark date按钮响应事件
- (void)dateButtonPressed:(UIButton *)sender
{
    isLeft = (sender == leftButton) ? YES : NO;
    [self addPickView];
}


#pragma mark sectionView

- (UIImageView *)setSectionView
{
    UIImageView *sectionView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35.0) placeholderImage:nil];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIColor *fontColor = [UIColor grayColor];
    
    UIButton *detailButton = [CreateViewTool createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60.0, sectionView.frame.size.height) buttonTitle:@"详情" titleColor:fontColor normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"detailButtonPressed:" tagDelegate:self];
    detailButton.titleLabel.font = FONT(15.0);
    [sectionView addSubview:detailButton];
    
    float width = (SCREEN_WIDTH - detailButton.frame.size.width)/2;
    
    UILabel *startLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, width, sectionView.frame.size.height) textString:@"起始时间" textColor:fontColor textFont:FONT(16.0)];
    startLabel.textAlignment = NSTextAlignmentCenter;
    [sectionView addSubview:startLabel];
    
    UILabel *endLabel = [CreateViewTool createLabelWithFrame:CGRectMake(startLabel.frame.origin.x + width, 0, width, sectionView.frame.size.height) textString:@"结束时间" textColor:fontColor textFont:FONT(16.0)];
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
    
        UIFont *font = FONT(14.0);
        
        detailButton = [CreateViewTool createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60.0, cell.frame.size.height) buttonTitle:@"详情" titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:[UIColor lightGrayColor] selectorName:@"detailButtonPressed:" tagDelegate:self];
        detailButton.tag = 103 + indexPath.row;
        detailButton.titleLabel.font = font;
        [CommonTool setViewLayer:detailButton withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:detailButton];
        
        float width = (SCREEN_WIDTH - detailButton.frame.size.width)/2;
        
        startLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, width, cell.frame.size.height) textString:@"" textColor:fontColor textFont:font];
        startLabel.tag = 101;
        startLabel.textAlignment = NSTextAlignmentCenter;
        [CommonTool setViewLayer:startLabel withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:startLabel];
        
        endLabel = [CreateViewTool createLabelWithFrame:CGRectMake(startLabel.frame.origin.x + width, 0, width, cell.frame.size.height) textString:@"" textColor:fontColor textFont:font];
        endLabel.tag = 102;
        endLabel.textAlignment = NSTextAlignmentCenter;
        [CommonTool setViewLayer:endLabel withLayerColor:lineColor bordWidth:.5];
        [cell.contentView addSubview:endLabel];
        
    }
    
    NSDictionary *rowDic = self.dataArray[indexPath.row];
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
