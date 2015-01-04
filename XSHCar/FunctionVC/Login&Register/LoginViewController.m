//
//  LoginViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/24.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *userNameTextField,*passwordTextField;
    UIImageView *bgImageView;
    BOOL isAutoLogin,isSavePwd;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    isAutoLogin = [[userDefault objectForKey:@"IsAutoLogin"] intValue];
    isSavePwd = [[userDefault objectForKey:@"IsSavePwd"] intValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSucess:) name:@"RegisterSucess" object:nil];
    //初始化UI
    [self createUI];
    //是否需要自动登录
    [self setData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addBgView];
    [self addTextFieldAndButtons];
}

#pragma mark 添加背景
//添加背景
- (void)addBgView
{
    float add_y =25.0;
    bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) placeholderImage:[UIImage imageNamed:@"login_bg"]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    
    UIImage *image = [UIImage imageNamed:@"login_logo"];
    UIImageView *logoImageView = [CreateViewTool createImageViewWithFrame:CGRectMake( (SCREEN_WIDTH - image.size.width/2)/2, 50.0, image.size.width/2 , image.size.height/2) placeholderImage:image];
    [bgImageView addSubview:logoImageView];
    
    startHeight = logoImageView.frame.origin.y + logoImageView.frame.size.height + 10;
    
    UIImage *titleImage = [UIImage imageNamed:@"logo_title"];
    UIImageView *logoTitleImageView = [CreateViewTool createImageViewWithFrame:CGRectMake( (SCREEN_WIDTH - titleImage.size.width/2)/2, startHeight, titleImage.size.width/2 , titleImage.size.height/2) placeholderImage:titleImage];
    [bgImageView addSubview:logoTitleImageView];
    
    startHeight = logoTitleImageView.frame.origin.y + logoTitleImageView.frame.size.height + add_y;
}

#pragma mark 添加textField和buttons
//添加textField和buttons
- (void)addTextFieldAndButtons
{
    [self addTextFields];
    [self addAutoLoginButtons];
    [self addLoginAndRegisterButtons];
    [self addFindPasswordButton];
}

//用户名，密码框
- (void)addTextFields
{
    float left_x = 25.0;
    float add_y = 15.0;
    //输入框
    userNameTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(left_x, startHeight, SCREEN_WIDTH - left_x * 2, 35.0) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入用户名"];
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.returnKeyType = UIReturnKeyDone;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.delegate = self;
    userNameTextField.leftView = [self addLeftViewWithImageName:@"user_name" isCanClick:NO];
    [bgImageView addSubview:userNameTextField];
    
    startHeight += userNameTextField.frame.size.height + add_y;
    
    passwordTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(left_x, startHeight, SCREEN_WIDTH - left_x * 2, userNameTextField.frame.size.height) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入密码"];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.leftView = [self addLeftViewWithImageName:@"login_password" isCanClick:NO];
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.rightView = [self addLeftViewWithImageName:@"pwd_kj_hide" isCanClick:YES];
    [bgImageView addSubview:passwordTextField];
    
    startHeight += passwordTextField.frame.size.height + add_y;
}


- (UIImageView *)addLeftViewWithImageName:(NSString *)imageName isCanClick:(BOOL)canClick
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2) placeholderImage:image];
    if (canClick)
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seePasswordOrNot:)];
        [imageView addGestureRecognizer:gesture];
    }
    return imageView;
}


//添加自动登录,记住密码
- (void)addAutoLoginButtons
{
    float left_x = 25.0;
    float add_y = 25.0;
    
    float buttonHeight = 30.0;
    float buttonWidth = 80.0;
    //自动登录/记住密码
    NSArray *array = @[NSStringFromCGRect(CGRectMake(left_x, startHeight, buttonWidth, buttonHeight)) ,NSStringFromCGRect(CGRectMake(SCREEN_WIDTH - left_x - buttonWidth, startHeight, buttonWidth, buttonHeight))];
    NSArray *titleArray = @[@"自动登录",@"记住密码"];
    
    for (int i = 0; i < [array count]; i++)
    {
        CGRect frame = CGRectFromString(array[i]);
        UIImage *sortImage = [UIImage imageNamed:@"sort_up.png"];
        
        UIButton *iconButton = [CreateViewTool createButtonWithFrame:CGRectMake(frame.origin.x, startHeight + (buttonHeight - sortImage.size.height/2)/2 , sortImage.size.width/2 , sortImage.size.height/2) buttonImage:@"" selectorName:@"" tagDelegate:nil];
        iconButton.tag = 1 + i;
        iconButton.selected = (i == 0) ? isAutoLogin : isSavePwd;
        [iconButton setBackgroundImage:sortImage forState:UIControlStateNormal];
        [iconButton setBackgroundImage:[UIImage imageNamed:@"sort_down.png"] forState:UIControlStateSelected];
        [bgImageView addSubview:iconButton];
        
        UIButton *button = [CreateViewTool createButtonWithFrame:frame buttonImage:@"" selectorName:@"buttonPressed:" tagDelegate:self];
        button.tag = 10 + i;
        button.titleLabel.font = FONT(15.0);
        [button setBackgroundColor:[UIColor clearColor]];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bgImageView addSubview:button];
    }
    
    startHeight += buttonHeight + add_y;
}

//添加登录注册按钮
- (void)addLoginAndRegisterButtons
{
    float left_x = 25.0;
    float add_y = 50.0;
    float add_x = 10.0;
    float buttonWidth = 130.0;
    
    UIImage *image = [UIImage imageNamed:@"login_background_btn"];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(left_x, startHeight, image.size.width/2, image.size.height/2) placeholderImage:image];
    imageView.userInteractionEnabled = YES;
    [bgImageView addSubview:imageView];
    
    UIButton *loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(0.0, 0.0, buttonWidth, imageView.frame.size.height) buttonTitle:@"登录" titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"loginButtonPressed:" tagDelegate:self];
    loginButton.showsTouchWhenHighlighted = YES;
    loginButton.titleLabel.font = FONT(15.0);
    [imageView addSubview:loginButton];
    
    UIButton *registerButton = [CreateViewTool createButtonWithFrame:CGRectMake(0.0 + loginButton.frame.size.width + add_x, 0.0, buttonWidth, imageView.frame.size.height) buttonTitle:@"注册" titleColor:[UIColor blackColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"registerButtonPressed:" tagDelegate:self];
    registerButton.showsTouchWhenHighlighted = YES;
    registerButton.titleLabel.font = FONT(15.0);
    [imageView addSubview:registerButton];
    
    startHeight += imageView.frame.size.height + add_y;
    
}

//添加找回密码
- (void)addFindPasswordButton
{
    float buttonHeight = 30.0;
    float buttonWidth = 70.0;
    float left_x = (SCREEN_WIDTH - buttonWidth)/2;
    
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(left_x, startHeight, buttonWidth, buttonHeight) buttonTitle:@"忘记密码" titleColor:[UIColor whiteColor] normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"findPasswordButtonPressed:" tagDelegate:self];
    button.titleLabel.font = FONT(15.0);
    button.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    button.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:button];
    
    startHeight += buttonHeight;
    
    UIImageView *lineImageView = [CreateViewTool  createImageViewWithFrame:CGRectMake(left_x, startHeight, buttonWidth, 1.0) placeholderImage:nil];
    lineImageView.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:lineImageView];
}

#pragma mark 设置数据
- (void)setData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isExited = [[XSH_Application shareXshApplication] isExited];
    NSString *userName = (![userDefaults objectForKey:@"UserName"]) ? @"" : [userDefaults objectForKey:@"UserName"];
    NSString *pwdString = (![userDefaults objectForKey:@"PassWord"]) ? @"" : [userDefaults objectForKey:@"PassWord"];
    userNameTextField.text = (!isExited) ? userName : @"";
    passwordTextField.text = (!isExited) ? pwdString : @"";
    
    if (!isExited)
    {
        if (isAutoLogin)
        {
            [self login];
        }
    }
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float add_y = 0.0;
    
    if (SCREEN_HEIGHT == 480.0)
    {
        add_y = - 50.0 - 60.0;
    }
    [UIView animateWithDuration:.3 animations:^
    {
        if (textField == passwordTextField)
        {
            bgImageView.transform = CGAffineTransformMakeTranslation(0.0, add_y);
        }
        else
        {
            bgImageView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        }
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [UIView animateWithDuration:.3 animations:^
    {
        bgImageView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    }
    completion:^(BOOL finish)
    {
        [textField resignFirstResponder];
    }];
    return YES;
}

#pragma mark 是否可见密码
- (void)seePasswordOrNot:(UITapGestureRecognizer *)gesture
{
    passwordTextField.secureTextEntry = !passwordTextField.secureTextEntry;
    UIImageView *imageView = (UIImageView *)gesture.view;
    imageView.image = (passwordTextField.secureTextEntry) ? [UIImage imageNamed:@"pwd_kj_hide"] : [UIImage imageNamed:@"pwd_bkj_reveal"];
}


#pragma mark 记住密码和自动登录按钮相应事件
- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    UIButton *button = (UIButton *)[bgImageView viewWithTag:sender.tag - 10 + 1];
    button.selected = sender.selected;
    if (sender.tag == 10)
    {
        isAutoLogin = (sender.selected) ? YES : NO;
    }
    if (sender.tag == 11)
    {
        isSavePwd = (sender.selected) ? YES : NO;
    }
}

#pragma mark 登录注册按钮响应事件
- (void)loginButtonPressed:(UIButton *)sender
{
    NSString *message = @"";
    if ([@"" isEqualToString:userNameTextField.text])
    {
        message = @"用户名不能为空";
    }
    else if ([@"" isEqualToString:passwordTextField.text])
    {
        message = @"密码不能为空";
    }
    else if (passwordTextField.text.length < 6)
    {
        message = @"密码不能少于6位";
    }
    
    if (![@"" isEqualToString:message])
    {
        [CommonTool addAlertTipWithMessage:message];
        return;
    }
    [self login];
}

- (void)registerButtonPressed:(UIButton *)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark 找回密码响应事件
- (void)findPasswordButtonPressed:(UIButton *)sender
{
    FindPasswordViewController *findPasswordViewController = [[FindPasswordViewController alloc] init];
    findPasswordViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
}


#pragma mark 登录请求
- (void)login
{
    [SVProgressHUD showWithStatus:@"正在登录..."];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:LOGIN_URL requestParamas:@{@"s_name":userNameTextField.text,@"s_password":[CommonTool md5:passwordTextField.text]} requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"loginResponseDic===%@",responseDic);
        if (responseDic && [responseDic isKindOfClass:[NSDictionary class]] && [responseDic isKindOfClass:[NSMutableDictionary class]])
        {
            [[XSH_Application shareXshApplication] setLoginDic:responseDic];
            [[XSH_Application shareXshApplication] setShopID:[[responseDic objectForKey:@"shop_id"] intValue]];
            [[XSH_Application shareXshApplication] setUserID:[[responseDic objectForKey:@"user_id"] intValue]];
            [[XSH_Application shareXshApplication] setCarID:[[responseDic objectForKey:@"car_id"] intValue]];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setValue:[NSString stringWithFormat:@"%d",isAutoLogin] forKey:@"IsAutoLogin"];
            [userDefault setValue:[NSString stringWithFormat:@"%d",isSavePwd] forKey:@"IsSavePwd"];
            [userDefault setValue:(!isAutoLogin && !isSavePwd) ? @"" : userNameTextField.text forKey:@"UserName"];
            [userDefault setValue:(!isAutoLogin && !isSavePwd) ? @"" : passwordTextField.text forKey:@"PassWord"];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:Nil];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
        }

    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        NSLog(@"error===%@",error);
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}


#pragma mark 注册成功后 自动登录
- (void)registerSucess:(NSNotification *)notification
{
    NSArray *array = (NSArray *)notification.object;
    userNameTextField.text = array[0];
    passwordTextField.text = array[1];
    [self login];
}


#pragma mark ======
- (void)didReceiveMemoryWarning {
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
