//
//  MineCenterViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/29.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MineCenterViewController.h"
#import "ChangePasswordViewController.h"

@interface MineCenterViewController ()
@property(nonatomic, strong) NSArray *titleArray;
@end

@implementation MineCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"账户信息";
    //添加返回Item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //初始化数据
    self.titleArray = @[@[@"用户名",@"车辆信息"],@[@"修改密码"]];
    //获取账户信息
    [self getUserCenterInfo];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}


#pragma mark 获取账户信息
- (void)getUserCenterInfo
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    __weak __typeof(self) weakSelf = self;
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    NSLog(@"-0-0-=%@",requestDic);
    [request requestWithUrl1:GET_USER_INFO requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"userCenterResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
         {
             NSArray *array = [responseDic componentsSeparatedByString:@","];
             if ([array count] == 1)
             {
                 weakSelf.dataArray = (NSMutableArray *)@[@[array[0],@"未添加车辆信息"],@[@""]];
             }
             else if ([array count] == 2)
             {
                 weakSelf.dataArray = (NSMutableArray *)@[@[array[0],array[1]],@[@""]];
             }
             [weakSelf.table reloadData];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
         }
         else
         {
            [SVProgressHUD showSuccessWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
     }];
}


#pragma mark tableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"peaceInfoCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
        label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 150.0 - 10.0, 0, 150.0, cell.frame.size.height) textString:@"" textColor:[UIColor blackColor] textFont:FONT(16.0)];
        label.tag = 100;
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
    }
    
    if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    label.text = self.dataArray[indexPath.section][indexPath.row];
    
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = FONT(16.0);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        ChangePasswordViewController *changePasswordViewController = [[ChangePasswordViewController alloc] init];
        changePasswordViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
    }
    
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
