//
//  CommunicationModeViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/28.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CommunicationModeViewController.h"

@interface CommunicationModeViewController ()<UIActionSheetDelegate>
{
    UILabel *tipLabel;
}
@end

@implementation CommunicationModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"通讯模式设置";
    //添加返回item
    [self addBackItem];
    //获取矫正信息
    [self getCommunicationInfo];
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma mark 获取矫正信息
- (void)getCommunicationInfo
{
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    [request requestWithUrl1:COMMUNICATION_INFO_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
               requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"communicationInfoResponse===%@",responseDic);
         if ([responseDic isKindOfClass:[NSString class]])
         {
             if (responseDic && ![@"" isEqualToString:responseDic])
             {
                 NSArray *array = [responseDic componentsSeparatedByString:@","];
                 if (array && [array count] == 4)
                 {
                     [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
                     weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                     [weakSelf createUI];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
                 }
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
    }];
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
    [self setFootView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0,NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}

- (void)setFootView
{
    UIImageView *footView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75) placeholderImage:nil];
    
    NSString *tipString = @"UBOX校正:";
    if (self.dataArray && [self.dataArray count] == 4)
    {
        NSString *rightString = ([@"false" isEqualToString:self.dataArray[3]]) ? @"未校正" : @"已校正";
        tipString = [tipString stringByAppendingString:rightString];
    }
    
    tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 20) textString:tipString textColor:[UIColor grayColor] textFont:FONT(16.0)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:tipLabel];
    
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(20, tipLabel.frame.origin.y + tipLabel.frame.size.height + 10, SCREEN_WIDTH - 20 * 2, 35) buttonTitle:@"重新校正" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"commitButtonPressed" tagDelegate:self];
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = FONT(15.0);
    [CommonTool clipView:button withCornerRadius:5.0];
    [footView addSubview:button];
    [self.table setTableFooterView:footView];
}

#pragma mark 重新校正按钮事件
- (void)commitButtonPressed
{
    [self commitCommunicationInfo];
}


#pragma mark tableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"数据上传时间间隔";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"settingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    cell.textLabel.text = (indexPath.row == 0) ? @"GPS数据":@"行程数据";
    cell.textLabel.font = FONT(16.0);
    cell.textLabel.textColor = [UIColor grayColor];
    
    NSString *string1 = [NSString stringWithFormat:@"%d秒",[self.dataArray[1] intValue]];
    NSString *string2 = [NSString stringWithFormat:@"%d秒",[self.dataArray[2] intValue]];
    NSString *textString = (indexPath.row == 0) ? string1 : string2;
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(250.0, 0.0, 40.0, cell.frame.size.height) textString:textString textColor:[UIColor blackColor] textFont:FONT(16.0)];
    label.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = (indexPath.row == 0) ? @"GPS数据" : @"行程数据";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"5秒",@"10秒",@"15秒",@"30秒",@"60秒", nil];
    actionSheet.tag = indexPath.row + 1;
    [actionSheet showInView:[[UIApplication sharedApplication] delegate].window];
}


#pragma mark actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    NSArray *array = @[@"5",@"10",@"15",@"30",@"60"];
    if (buttonIndex < [array count])
    {
        NSString *selcetString = [array[buttonIndex] stringByAppendingString:@"秒"];
        NSString *defaultString = self.dataArray[actionSheet.tag];
        if (![selcetString isEqualToString:defaultString])
        {
            [self.dataArray replaceObjectAtIndex:actionSheet.tag withObject:array[buttonIndex]];
            [self.table reloadData];
            [self commitCommunicationInfo];
        }
    }
}

#pragma mark 提交通讯设置
- (void)commitCommunicationInfo
{
    [SVProgressHUD showWithStatus:@"正在保存..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"cmc_id":[NSNumber numberWithInt:[self.dataArray[0] intValue]],@"cmc_gps":[NSNumber numberWithInt:[self.dataArray[1] intValue]],@"cmc_travel":[NSNumber numberWithInt:[self.dataArray[2] intValue]]};
    [request requestWithUrl1:COMMIT_COMMUNICATION_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
               requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"commitCommunicationInfoResponse===%@",responseDic);
         if ([responseDic isKindOfClass:[NSString class]])
         {
             if ([@"8888" isEqualToString:responseDic])
             {
                 tipLabel.text = @"UBOX校正:已校正";
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"设置失败"];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         [SVProgressHUD showErrorWithStatus:@"设置失败"];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
