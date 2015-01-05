//
//  ChangePasswordViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/29.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
{
    UIImageView *bgImageView;
}
@property(nonatomic, strong) NSString *oldPWDString;
@property(nonatomic, strong) NSString *passwordString;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"修改密码";
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addLabelAndTextField];
    [self addCommitButton];
}

- (void)addLabelAndTextField
{
    bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)placeholderImage:nil];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    float left_x = 20.0;
    float left_y = 5.0;
    float labelWidth = 65.0;
    float labelHeight = 35.0;
    float add_x = 10.0;
    float add_y = 5.0;
    float textFieldWidth = SCREEN_WIDTH - left_x * 2 - labelWidth - add_x * 2;
    NSArray *titleArray = @[@"原始密码:",@"新密码:",@"确认密码:"];
    NSArray *placeArray = @[@"请输入原始密码",@"请输入新密码",@"请确认新密码"];
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, NAV_HEIGHT + left_y + i * (labelHeight + add_y), labelWidth, labelHeight) textString:titleArray[i] textColor:[UIColor grayColor] textFont:FONT(15.0)];
        label.textAlignment = NSTextAlignmentRight;
        [bgImageView addSubview:label];
        
        UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(add_x + left_x + labelWidth, label.frame.origin.y, textFieldWidth, label.frame.size.height) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:placeArray[i]];
        [textField addTarget:self action:@selector(fieldExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.tag = i + 1;
        textField.text = @"";
        [bgImageView addSubview:textField];
        
        UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, textField.frame.origin.y + textField.frame.size.height + .5, SCREEN_WIDTH, .5) placeholderImage:nil];
        lineImageView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7];
        [bgImageView addSubview:lineImageView];
        
        if (i == [titleArray count] - 1)
        {
            startHeight += lineImageView.frame.origin.y + lineImageView.frame.size.height + add_y * 2;
        }
    }
}

- (void)addCommitButton
{
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(20, startHeight, SCREEN_WIDTH - 20 * 2, 35) buttonTitle:@"提交" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"commitButtonPressed:" tagDelegate:self];
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = FONT(16.0);
    [CommonTool clipView:button withCornerRadius:5.0];
    [bgImageView addSubview:button];
}

#pragma mark 取消textField第一响应
- (void)fieldExit:(UITextField *)textField
{
    [UIView animateWithDuration:.3 animations:^{bgImageView.transform = CGAffineTransformMakeTranslation(0, 0);}];
    [textField resignFirstResponder];
}


#pragma mark  判断数据是否合法
- (BOOL)isCanNextWithCount
{
    UITextField *oldPWDTextField = (UITextField *)[self.view viewWithTag:1];
    UITextField *PWDTextField1 = (UITextField *)[self.view viewWithTag:2];
    UITextField *PWDTextField2 = (UITextField *)[self.view viewWithTag:3];
    self.oldPWDString = oldPWDTextField.text;
    NSString *pwdString1 = PWDTextField1.text;
    NSString *pwdString2 = PWDTextField2.text;
    
    NSString *message = @"";
    if ([@"" isEqualToString:self.oldPWDString])
    {
        message = @"原始不能为空";
    }
    else if ([@"" isEqualToString:pwdString1] || [@"" isEqualToString:pwdString2])
    {
        message = @"密码不能为空";
    }
    else if (![pwdString1 isEqualToString:pwdString2])
    {
        message = @"密码不一致";
    }
    
    if (![@"" isEqualToString:message])
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    
    self.passwordString = pwdString1;
    
    return YES;
}


#pragma mark 提交按钮响应时间
- (void)commitButtonPressed:(UIButton *)sender
{
    if ([self isCanNextWithCount])
    {
        [self commitPasswordInfo];
    }
}

#pragma mark 修改密码
- (void)commitPasswordInfo
{
    [SVProgressHUD showWithStatus:@"正在保存..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"oldPassword":[[CommonTool md5:self.oldPWDString] uppercaseString],@"newPassword":[[CommonTool md5:self.passwordString] uppercaseString]};
    NSLog(@"requestDic== %@",requestDic);
    [request requestWithUrl1:CHANGE_PWD_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"commitResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
         {
             if ([@"8888" isEqualToString:responseDic])
             {
                 [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                 NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                 [userDefault setValue:self.passwordString forKey:@"PassWord"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else if ([@"1002" isEqualToString:responseDic])
             {
                 [SVProgressHUD showErrorWithStatus:@"密码不正确" duration:.1];
                 [CommonTool addAlertTipWithMessage:@"密码不正确"];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"error===%@",error);
         [SVProgressHUD showErrorWithStatus:@"修改失败"];
     }];

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
