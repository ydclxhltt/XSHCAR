//
//  MessageManageViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MessageManageViewController.h"

@interface MessageManageViewController ()
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
//    self.imageArray = @[@"abnormalvibration_alert",@"deployment_of_the_bootprompt",@"collision_warning",@"rollover_alarm",@"electronic_fence",@"peace_family",@"maintenance_tips"];
//    self.dataArray = (NSMutableArray *)@[@"异常震动提醒",@"布防启动提示",@"碰撞报警",@"侧翻报警",@"电子围栏",@"平安亲人",@"保养提示"];
    //初始化UI
    //[self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getMessageStatus];
}


#pragma mark 获取消息状态
- (void)getMessageStatus
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MESSAGE_MANAGE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"messageStatusResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [NSMutableArray isKindOfClass:[NSMutableArray class]])
         {
             weakSelf.dataArray = (NSMutableArray *)responseDic;
             [self createUI];
         }
         else
         {
             //服务器异常
             [CommonTool addAlertTipWithMessage:@"服务器异常"];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
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
        self.table.scrollEnabled = NO;
        self.table.separatorInset = UIEdgeInsetsZero;
    }
    else
    {
        [self.table reloadData];
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
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , (cell.frame.size.height - 30)/2, 60, 30)];
    [switchView setOn:flag];
    switchView.tag = indexPath.row + 1;
    [switchView addTarget:self action:@selector(messageStatusChanged:) forControlEvents:UIControlEventValueChanged];
    switchView.onTintColor = RGB(28.0, 130.0, 202.0);
    switchView.tintColor = RGB(189.0, 189.0, 189.0);
    [cell.contentView addSubview:switchView];
    
    cell.textLabel.text = nameString;
    cell.textLabel.font = FONT(16.0);
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *rowDic = [self.dataArray objectAtIndex:indexPath.row];
    if (rowDic)
    {
        NSString *remarkString = [rowDic objectForKey:@"sms_remark"];
        if (remarkString && ![@"" isEqualToString:remarkString])
        {
            [CommonTool addAlertTipWithMessage:remarkString];
        }
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
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"sms_id":[NSNumber numberWithInt:sms_id],@"uss_id":[NSNumber numberWithInt:uss_id],@"uss_status":[NSNumber numberWithInt:uss_status]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl1:MESSAGE_UPDATE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"messageStatusResponseDic===%@",responseDic);
        if (!responseDic || [@"" isEqualToString:responseDic])
        {
            [CommonTool addAlertTipWithMessage:@"服务器异常"];
            [switchView setOn:!switchView.isOn];
        }
        else
        {
            if (uss_id != [responseDic intValue])
            {
                [CommonTool addAlertTipWithMessage:@"修改失败"];
                [switchView setOn:!switchView.isOn];
            }
        }

    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        [switchView setOn:!switchView.isOn];
         NSLog(@"error===%@",error);
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
