//
//  LoginViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/24.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *userNameTextField,*passwordTextField;
    UIImageView *bgImageView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化UI
    [self createUI];
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

- (void)addBgView
{
    bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) placeholderImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:bgImageView];
    
    UIImage *image = [UIImage imageNamed:@"login_logo"];
    UIImageView *logoImageView = [CreateViewTool createImageViewWithFrame:CGRectMake( (SCREEN_WIDTH - image.size.width/2)/2, 50.0, image.size.width/2 , image.size.height/2) placeholderImage:image];
    [bgImageView addSubview:logoImageView];
    
     startHeight = logoImageView.frame.origin.y + logoImageView.frame.size.height + 10;
    
    UIImage *titleImage = [UIImage imageNamed:@"logo_title"];
    UIImageView *logoTitleImageView = [CreateViewTool createImageViewWithFrame:CGRectMake( (SCREEN_WIDTH - titleImage.size.width/2)/2, startHeight, titleImage.size.width/2 , titleImage.size.height/2) placeholderImage:titleImage];
    [bgImageView addSubview:logoTitleImageView];
    
    startHeight = logoTitleImageView.frame.origin.y + logoTitleImageView.frame.size.height + 25.0;
}

- (void)addTextFieldAndButtons
{
    float left_x = 25.0;
    float add_y = 15.0;
    userNameTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(left_x, startHeight, SCREEN_WIDTH - left_x * 2, 35.0) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入用户名"];
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.returnKeyType = UIReturnKeyDone;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.delegate = self;
    userNameTextField.leftView = [self addLeftViewWithImageName:@"user_name"];
    [bgImageView addSubview:userNameTextField];
    
    startHeight += userNameTextField.frame.size.height + add_y;
    
    passwordTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(left_x, startHeight, SCREEN_WIDTH - left_x * 2, userNameTextField.frame.size.height) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入密码"];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.leftView = [self addLeftViewWithImageName:@"login_password"];
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    passwordTextField.delegate = self;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.rightView = [self addLeftViewWithImageName:@"pwd_kj_hide"];
    [bgImageView addSubview:passwordTextField];
    
    startHeight += passwordTextField.frame.size.height + add_y;
    
    NSArray *arrary = @[NSStringFromCGRect(CGRectMake(left_x, startHeight, 110.0, 25.0)) ,NSStringFromCGRect(CGRectMake(SCREEN_WIDTH - left_x - 110.0, startHeight, 110.0, 25.0))];
    
    for (int i = 0; i < [arrary count]; i++)
    {
//        CGRect frame = CGRectFromString(arrary[0]);
//        UIImage *sortImage = [UIImage imageNamed:@"sort_up.png"];
//        
//        UIButton *iconButton = [CreateViewTool createButtonWithFrame:CGRectMake(25, startHeight + (25 - sortImage.size.height/2)/2 + (addHeight + sortHeight) * i, sortImage.size.width/2 , sortImage.size.height/2) buttonImage:@"" selectorName:@"" tagDelegate:nil];
//        iconButton.tag = 100 + i;
//        [iconButton setBackgroundImage:sortImage forState:UIControlStateNormal];
//        [iconButton setBackgroundImage:[UIImage imageNamed:@"sort_down.png"] forState:UIControlStateSelected];
//        [bgImageView addSubview:iconButton];
//        
//        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(10, 5 + (addHeight + sortHeight) * i, bgImageView.frame.size.width - 10 * 2, sortHeight) buttonImage:@"" selectorName:@"buttonPressed:" tagDelegate:self];
//        button.tag = 1000 + i;
//        button.titleLabel.font = FONT(15.0);
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
//        [button setBackgroundColor:[UIColor clearColor]];
//        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [button setTitle:self.dataArray[i][1] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [bgImageView addSubview:button];
    }
    
    
}




- (UIImageView *)addLeftViewWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2) placeholderImage:image];
    return imageView;
}

- (UIImageView *)addRightViewWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2) placeholderImage:image];
    return imageView;
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float add_y = 0.0;
    if (SCREEN_HEIGHT == 568.0)
    {
        add_y = -30.0;
    }
    else if (SCREEN_HEIGHT == 480.0)
    {
        add_y = -50.0 - 117.0;
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
