//
//  SafeInfomationViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/27.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "PeaceInfomationViewController.h"
#import "CityListViewController.h"

@interface PeaceInfomationViewController ()<UIAlertViewDelegate>
{
    BOOL isCanAdd;
}
@property(nonatomic, strong) NSArray *headerArray;
@end

@implementation PeaceInfomationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"平安亲人";
    //设置返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //初始化数据
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"设置省/市", nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:array1,array2,nil];
    self.headerArray = @[@"设置车辆所在地",@"手机号码"];
    isCanAdd = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *cityString = [[XSH_Application shareXshApplication] cityString];
    if (cityString)
    {
        [self.dataArray[0] replaceObjectAtIndex:0 withObject:cityString];
        [self.table reloadData];
    }
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
    [self setTableFootView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}

- (void)setTableFootView
{
    UIImageView *footView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) placeholderImage:nil];
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 20 * 2, 35) buttonTitle:@"提交" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"commitButtonPressed" tagDelegate:self];
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = FONT(16.0);
    [CommonTool clipView:button withCornerRadius:5.0];
    [footView addSubview:button];
    [self.table setTableFooterView:footView];
}

#pragma mark 提交按钮响应事件
- (void)commitButtonPressed
{
    int cityID = [[XSH_Application shareXshApplication] xshCityID];
    NSString *message = @"";
    NSString *phoneString = @"";
    
    int count = (int)[self.dataArray[1] count];
    if (count > 1)
    {
        phoneString = self.dataArray[1][0];
        for (int i = 1; i < count; i++)
        {
            NSString *string = self.dataArray[1][i];
            if (![@"" isEqualToString:string])
            {
                phoneString = [NSString stringWithFormat:@"%@,%@",phoneString,string];
            }
        }
    }

    if (cityID == 0)
    {
        message = @"请设置车辆所在地";
    }
    else if([self.dataArray[1] count] == 1)
    {
        message = @"请添加手机号";
    }
    
    if (![@"" isEqualToString:message])
    {
        [CommonTool addAlertTipWithMessage:message];
        return;
    }
    
    [self addPeaceInfoWithPhone:phoneString];
    
    NSLog(@"phoneString===%@",phoneString);
}


#pragma mark  设置平安亲人请求
- (void)addPeaceInfoWithPhone:(NSString *)phone
{
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在提交..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"city_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] xshCityID]],@"sis_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] sisID]],@"uss_id":[NSNumber numberWithInt:weakSelf.ussID],@"mobile_phone":phone};
    NSLog(@"-0-0-=%@",requestDic);
    [request requestWithUrl1:PEACE_INFO_COMMIT_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
     requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"peaceResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic])
         {
             if ([@"8888" isEqualToString:responseDic])
             {
                 [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"保存失败"];
             }
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


#pragma mark - tableView代理

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"peaceInfoCellID";
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
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 1 && indexPath.row == [self.dataArray[indexPath.section] count] - 1 && [self.dataArray[indexPath.section] count] < 5 && isCanAdd)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake((SCREEN_WIDTH - 30)/2, 5, 30, 30);
        [button addTarget:self action:@selector(addPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }

    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = FONT(16.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == [self.dataArray[indexPath.section] count] - 1 && [self.dataArray[indexPath.section] count] < 5)
    {
        [self addPhoneNumber];
    }
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        CityListViewController *cityListViewController = [[CityListViewController alloc] init];
        cityListViewController.cityScource = CityScourceFromXSH;
        cityListViewController.smsID = self.smsID;
        cityListViewController.ussID = self.ussID;
        UINavigationController  *nav = [[UINavigationController alloc] initWithRootViewController:cityListViewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark 添加手机号码
- (void)addPhoneNumber
{
    UIAlertView *addPhoneNumberAlert = [[UIAlertView alloc] initWithTitle:@"添加手机号码" message:@"" delegate:self cancelButtonTitle:@"添加" otherButtonTitles:@"取消", nil];
    addPhoneNumberAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [addPhoneNumberAlert textFieldAtIndex:0];
    textField.placeholder = @"请输入手机号码";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [addPhoneNumberAlert show];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *phoneNumber = textField.text;
        if (phoneNumber && ![@"" isEqualToString:phoneNumber])
        {
            if ([CommonTool isEmailOrPhoneNumber:phoneNumber])
            {
                [self.dataArray[1] insertObject:phoneNumber atIndex:0];
                isCanAdd = ([self.dataArray[1] count] == 5) ? NO : YES;
                if (!isCanAdd)
                {
                    [self.dataArray[1] removeObject:self.dataArray[1][[self.dataArray[1] count] - 1]];
                }
                [self.table  reloadData];
            }
            else
            {
                [self addPhoneNumber];
            }
        }
        else
        {
            [self addPhoneNumber];
        }
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
