//
//  RegisterViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/29.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UIButton *codeButton;
    UIImageView *bgImageView;
}
@property(nonatomic, strong)  NSString *phoneString;
@property(nonatomic, strong)  NSString *userName;
@property(nonatomic, strong)  NSString *passwordString;
@property(nonatomic, strong)  NSString *foursString;
@property(nonatomic, strong)  NSString *wantCarString;
@property(nonatomic, strong)  NSString *myCarString;
@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"注册";
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //获取4Slist
    [self get4SInfo];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addLabelAndTextField];
    [self addCommitButton];
}

- (void)addLabelAndTextField
{
    bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)placeholderImage:nil];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    float left_x = 20.0;
    float left_y = 5.0;
    float labelWidth = 65.0;
    float labelHeight = 35.0;
    float add_x = 10.0;
    float add_y = 5.0;
    float textFieldWidth = SCREEN_WIDTH - left_x * 2 - labelWidth - add_x * 2;
    NSArray *titleArray = @[@"用户名:",@"密码:",@"确认密码:",@"手机号:",@"4S店:",@"意向车型",@"现有车型"];
    NSArray *placeArray = @[@"请输入用户名",@"请输入新密码",@"请确认新密码",@"请输入手机号",@"请选择4S店",@"请输入意向车型",@"请输入现有车型"];
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, NAV_HEIGHT + left_y + i * (labelHeight + add_y), labelWidth, labelHeight) textString:titleArray[i] textColor:[UIColor grayColor] textFont:FONT(15.0)];
        label.textAlignment = NSTextAlignmentRight;
        [bgImageView addSubview:label];
        
        UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(add_x + left_x + labelWidth, label.frame.origin.y, textFieldWidth, label.frame.size.height) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:placeArray[i]];
        textField.delegate = self;
        [textField addTarget:self action:@selector(fieldExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.returnKeyType = UIReturnKeyDone;
        textField.tag = i + 1;
        textField.text = @"";
        [bgImageView addSubview:textField];
        
        if (i == 3)
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
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

#pragma mark textField取消第一响应
- (void)fieldExit:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark 
- (void)commitButtonPressed:(UIButton *)sender
{
    if ([self isCanNextWithCount])
    {
        //注册请求
        [self registerRequest];
    }
}

#pragma mark  判断数据是否合法
- (BOOL)isCanNextWithCount
{
    UITextField *userTextField = (UITextField *)[self.view viewWithTag:1];
    UITextField *PWDTextField1 = (UITextField *)[self.view viewWithTag:2];
    UITextField *PWDTextField2 = (UITextField *)[self.view viewWithTag:3];
    UITextField *phoneTextField = (UITextField *)[self.view viewWithTag:4];
    UITextField *foursTextField = (UITextField *)[self.view viewWithTag:5];
    UITextField *wantCarTextField = (UITextField *)[self.view viewWithTag:6];
    UITextField *myCarTextField = (UITextField *)[self.view viewWithTag:7];
    self.phoneString = phoneTextField.text;
    self.userName = userTextField.text;
    self.foursString = foursTextField.text;
    self.wantCarString = wantCarTextField.text;
    self.myCarString = myCarTextField.text;
    NSString *pwdString1 = PWDTextField1.text;
    NSString *pwdString2 = PWDTextField2.text;
    
    NSString *message = @"";
    if ([@"" isEqualToString:self.userName])
    {
        message = @"用户名不能为空";
    }
    else if ([@"" isEqualToString:pwdString1] || [@"" isEqualToString:pwdString2])
    {
        message = @"密码不能为空";
    }
    else if (![pwdString1 isEqualToString:pwdString2])
    {
        message = @"密码不一致";
    }
    else if ([@"" isEqualToString:self.phoneString])
    {
        message = @"手机号不能为空";
    }
    else if (![CommonTool isEmailOrPhoneNumber:self.phoneString])
    {
        message = @"请输入正确的手机号";
    }
    else if ([@"" isEqualToString:self.foursString])
    {
        message = @"请选择您的4S店";
    }
    else if ([@"" isEqualToString:self.wantCarString])
    {
        message = @"请输入意向车型";
    }
    else if ([@"" isEqualToString:self.myCarString])
    {
        message = @"请输入现有车型";
    }
    
    if ([@"" isEqualToString:message])
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    
    self.passwordString = pwdString1;
    
    return YES;
}



#pragma mark 获取4S店信息
- (void)get4SInfo
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:GET_4S_SHOP_URL requestParamas:nil requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"excitingResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             weakSelf.dataArray = [NSMutableArray arrayWithArray:responseDic];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
         }
         else
         {
             //服务器异常
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
         NSLog(@"error===%@",error);
     }];

}

#pragma mark 注册请求
- (void)registerRequest
{
    [SVProgressHUD showWithStatus:@"正在注册..."];
    NSDictionary *requestDic = @{@"username":self.userName,@"password":[CommonTool md5:self.passwordString],@"telephone":self.phoneString,@"cl_intentionmodel":self.wantCarString,@"cl_existingmodels":self.myCarString,@"shop_id":[NSNumber numberWithInt:67]};
    NSLog(@"requestDic===%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl1:REGISTER_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"registerResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
         {
             if ([@"8888" isEqualToString:responseDic])
             {
                 [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterSucess" object:@[self.userName,self.passwordString]];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"注册失败"];
             }
         }
         else
         {
             //服务器异常
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"注册失败"];
         NSLog(@"error===%@",error);
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
