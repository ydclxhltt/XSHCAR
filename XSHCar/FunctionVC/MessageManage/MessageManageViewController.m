//
//  MessageManageViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MessageManageViewController.h"
#import "MessageDetailViewController.h"
#import "PeaceInfomationViewController.h"
#import "SetFenceViewController.h"

@interface MessageManageViewController ()
{
    BOOL isNeedLoad;
}
//@property(nonatomic, retain) NSArray *imageArray;
//@property(nonatomic, retain) NSArray *messageArray;
@end

@implementation MessageManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"消息管理";
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化数据
    isNeedLoad = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit) name:@"Exit" object:nil];
//    self.imageArray = @[@"abnormalvibration_alert",@"deployment_of_the_bootprompt",@"collision_warning",@"rollover_alarm",@"electronic_fence",@"peace_family",@"maintenance_tips"];
//    self.dataArray = (NSMutableArray *)@[@"异常震动提醒",@"布防启动提示",@"碰撞报警",@"侧翻报警",@"电子围栏",@"平安亲人",@"保养提示"];
    //初始化UI
    //[self createUI];

    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    if (isNeedLoad)
        //获取状态
        [self getMessageStatus];
}

#pragma mark 退出登录响应事件
- (void)exit
{
    isNeedLoad = YES;
}

#pragma mark 获取消息状态
- (void)getMessageStatus
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MESSAGE_MANAGE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"messageStatusResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [NSMutableArray isKindOfClass:[NSMutableArray class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             weakSelf.dataArray = (NSMutableArray *)responseDic;
             isNeedLoad = NO;
             [self createUI];
         }
         else
         {
             //服务器异常
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
             //[CommonTool addAlertTipWithMessage:LOADING_WEBERROR_TIP];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
     }];

}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    if (!self.table)
    {
        [self addTableViewWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 44.0 * [self.dataArray count]) tableType:UITableViewStylePlain tableDelegate:self];
        self.table.separatorInset = UIEdgeInsetsZero;
    }
    else
    {
        [self.table reloadData];
    }

}

#pragma mark 消息状态改变
- (void)messageStatusChanged:(UISwitch *)switchView
{
    int tag = (int)switchView.tag;
    NSDictionary *rowDic = [self.dataArray objectAtIndex:tag - 1];
    if (rowDic)
    {
        int smsID = [[rowDic objectForKey:@"sms_id"] intValue];
        int ussId = [[rowDic objectForKey:@"uss_id"] intValue];
        [self switchViewStatusChange:switchView smsID:smsID ussId:ussId ussStatus:switchView.isOn];
    }
    else
    {
        [switchView setOn:!switchView.isOn];
    }
}

#pragma mark 更新状态
- (void)switchViewStatusChange:(UISwitch *)switchView  smsID:(int)sms_id  ussId:(int)uss_id ussStatus:(int)uss_status
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在保存..."];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"sms_id":[NSNumber numberWithInt:sms_id],@"uss_id":[NSNumber numberWithInt:uss_id],@"uss_status":[NSNumber numberWithInt:uss_status]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl1:MESSAGE_UPDATE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
               requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"messageStatusResponseDic===%@",responseDic);
         if (!responseDic || [@"" isEqualToString:responseDic])
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
             //[CommonTool addAlertTipWithMessage:LOADING_WEBERROR_TIP];
             [switchView setOn:!switchView.isOn];
         }
         else
         {
             if (uss_id != [responseDic intValue])
             {
                 [SVProgressHUD showErrorWithStatus:@"修改失败"];
                 [switchView setOn:!switchView.isOn];
             }
             else
             {
                 [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                 if (switchView.isOn)
                 {
                     [weakSelf setPeaceAndFenceWithIndex:(int)switchView.tag - 1];
                 }
             }
         }
         
     }
                 requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [switchView setOn:!switchView.isOn];
         NSLog(@"error===%@",error);
     }];
    
}


#pragma mark 设置平安亲人和电子围栏
- (void)setPeaceAndFenceWithIndex:(int)index
{
    NSDictionary *rowDic = [self.dataArray objectAtIndex:index];
    NSString *imageName = ([rowDic objectForKey:@"sms_filepath"]) ? [rowDic objectForKey:@"sms_filepath"] : @"";
    if ([@"peace_family.png" isEqualToString:imageName])
    {
        PeaceInfomationViewController *infoViewController = [[PeaceInfomationViewController alloc] init];
        infoViewController.smsID = [[rowDic objectForKey:@"sms_id"] intValue];
        infoViewController.ussID = [[rowDic objectForKey:@"uss_id"] intValue];
        infoViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    if ([@"electronic_fence.png" isEqualToString:imageName])
    {
        SetFenceViewController *fenceViewController = [[SetFenceViewController alloc] init];
        fenceViewController.smsID = [[rowDic objectForKey:@"sms_id"] intValue];
        fenceViewController.ussID = [[rowDic objectForKey:@"uss_id"] intValue];
        fenceViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fenceViewController animated:YES];
    }
}


#pragma mark - tableView代理


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
    static NSString *homeCellID = @"messageCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(10.0, (cell.frame.size.height - 35.0)/2, 35.0, 35.0) placeholderImage:[UIImage imageNamed:@"pic_default"]];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        label = [CreateViewTool createLabelWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 15.0, 0, 140.0, cell.frame.size.height) textString:@"" textColor:[UIColor blackColor] textFont:FONT(16.0)];
        label.tag = 101;
        [cell.contentView addSubview:label];
        
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:[UISwitch class]])
        {
            [view removeFromSuperview];
        }
    }
    
    NSDictionary *rowDic = [self.dataArray objectAtIndex:indexPath.row];
    int flag = 0;
    NSString *imageName = @"";
    NSString *nameString = @"";
    if (rowDic)
    {
        flag = [[rowDic objectForKey:@"flag"] intValue];
        imageName = ([rowDic objectForKey:@"sms_filepath"]) ? [rowDic objectForKey:@"sms_filepath"] : @"";
        nameString = ([rowDic objectForKey:@"sms_name"]) ? [rowDic objectForKey:@"sms_name"] : @"";
    }
    
    if ([@"碰撞报警" isEqualToString:nameString ] || [@"侧翻报警" isEqualToString:nameString])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , (cell.frame.size.height - 30)/2, 60, 30)];
        [switchView setOn:flag];
        switchView.tag = indexPath.row + 1;
        [switchView addTarget:self action:@selector(messageStatusChanged:) forControlEvents:UIControlEventValueChanged];
        switchView.onTintColor = RGB(28.0, 130.0, 202.0);
        switchView.tintColor = RGB(189.0, 189.0, 189.0);
        [cell.contentView addSubview:switchView];
    }
    
    
    label.text = nameString;

    UIImage *image = [UIImage imageNamed:imageName];
    if (image)
        imageView.image = [UIImage imageNamed:imageName];
    else
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,imageName]] placeholderImage:[UIImage imageNamed:@"pic_default"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *rowDic = [self.dataArray objectAtIndex:indexPath.row];
    if (rowDic)
    {
        NSString * imageName = ([rowDic objectForKey:@"sms_filepath"]) ? [rowDic objectForKey:@"sms_filepath"] : @"";
        if ([@"collision_warning.png" isEqualToString:imageName ])
        {
            MessageDetailViewController *detailViewController = [[MessageDetailViewController alloc] init];
            detailViewController.title = @"碰撞报警说明";
            detailViewController.hidesBottomBarWhenPushed = YES;
            detailViewController.detailText = COLLISION_WARNING_TIP;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        else if ([@"rollover_alarm.png" isEqualToString:imageName])
        {
            MessageDetailViewController *detailViewController = [[MessageDetailViewController alloc] init];
            detailViewController.title = @"侧翻报警说明";
            detailViewController.hidesBottomBarWhenPushed = YES;
            detailViewController.detailText = ROLLOVER_ALARM_TIP;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        else
        {
            NSString *remarkString = [rowDic objectForKey:@"sms_remark"];
            if (remarkString && ![@"" isEqualToString:remarkString])
            {
                [CommonTool addAlertTipWithMessage:remarkString];
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
