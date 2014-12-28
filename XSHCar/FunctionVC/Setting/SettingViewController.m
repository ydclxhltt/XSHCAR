//
//  SettingViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "SettingViewController.h"
#import "CorrectTipViewController.h"
#import "CommunicationModeViewController.h"

@interface SettingViewController ()
@property(nonatomic, retain) NSArray *imageArray;
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"设置";
    //初始化UI
    [self createUI];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"通讯模式设置",@"保养矫正提示"],@[@"后台监听",@"定位开关"]];
    self.imageArray = @[@[@"communication_mode_setting",@"maintenance_prompt_correction"],@[@"background_monitor",@"position_switch"]];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0 *  4 + 15 * 2 + NAV_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.scrollEnabled = NO;
}

#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
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
        cell.separatorInset = UIEdgeInsetsZero;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:[UISwitch class]])
        {
            [view removeFromSuperview];
        }
    }
    
    NSArray *array = self.dataArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.font = FONT(16.0);
    cell.imageView.image = [UIImage imageNamed:[[self.imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isAcceptNews = ([userDefault objectForKey:@"AcceptNews"]) ? [userDefault objectForKey:@"AcceptNews"] : @"1";
    NSString *isOpenLocation = ([userDefault objectForKey:@"OpenLocation"]) ? [userDefault objectForKey:@"OpenLocation"] : @"1";
    if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , (cell.frame.size.height - 30)/2, 60, 30)];
        switchView.tag = indexPath.row + 1;
        //    switchView.onImage = [UIImage imageNamed:@"open_btn"];
        //    switchView.offImage = [UIImage imageNamed:@"close_btn"];
        int flag = (indexPath.row == 0) ? [isAcceptNews intValue] : [isOpenLocation intValue];
        [switchView setOn:flag];
        [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        switchView.onTintColor = RGB(28.0, 130.0, 202.0);
        switchView.tintColor = RGB(189.0, 189.0, 189.0);
        [cell.contentView addSubview:switchView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        UIViewController *viewController = nil;
        if (indexPath.row == 0)
        {
            viewController = [[CommunicationModeViewController alloc] init];
        }
        if (indexPath.row == 1)
        {
            viewController = [[CorrectTipViewController alloc] init];
        }
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark switchValueChanged

- (void)switchValueChanged:(UISwitch *)switchView
{
    int tag = (int)switchView.tag;
    if (tag == 1)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSString stringWithFormat:@"%d",switchView.isOn] forKey:@"AcceptNews"];
    }
    else if (tag == 2)
    {
        [self saveLocationWithSwitch:switchView];
    }
}


#pragma mark 保存定位开关设置
- (void)saveLocationWithSwitch:(UISwitch *)switchView
{
    [SVProgressHUD showWithStatus:@"正在保存..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"sms_id":[NSNumber numberWithInt:10]};
    [request requestWithUrl1:LOCATION_SWITCH_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"======%@",responseDic);
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
       
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *errror)
    {
        NSLog(@"error====%@",errror);
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
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
