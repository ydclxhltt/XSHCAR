//
//  CorrectTipViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/28.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CorrectTipViewController.h"

@interface CorrectTipViewController ()

@end

@implementation CorrectTipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"保养矫正提示";
    //添加返回item
    [self addBackItem];
    //获取矫正信息
    [self getCorrectInfo];
    // Do any additional setup after loading the view.
}

#pragma mark 获取矫正信息
- (void)getCorrectInfo
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    [request requestWithUrl1:CORRECT_TIP_INFO_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"correctInfoResponse===%@",responseDic);
        if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
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
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
    }];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addLabelsAndTextFields];
    [self addCommitButton];
}


- (void)addLabelsAndTextFields
{
    NSArray *array = @[@"仪表里程数据:",@"上次保养里程:",@"保养里程间隔:"];
    for (int i = 0; i < 3; i++)
    {
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(10, NAV_HEIGHT + 10 + (35 + 5) * i, 100, 35) textString:array[i] textColor:[UIColor grayColor] textFont:FONT(15.0)];
        [self.view addSubview:label];
        
        float start_x = label.frame.origin.x + label.frame.size.width + 20;
        UITextField *textField = [CreateViewTool  createTextFieldWithFrame:CGRectMake(start_x, label.frame.origin.y, SCREEN_WIDTH - start_x - 20, label.frame.size.height) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入相关数据"];
        textField.tag = i + 1;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(exitField:) forControlEvents:UIControlEventEditingDidEndOnExit];
        if (self.dataArray && [self.dataArray count] == 4 )
        {
            if (![@"" isEqualToString:self.dataArray[i]] && ![@"0" isEqualToString:self.dataArray[i]] )
            {
                textField.text = self.dataArray[i];
                if (i < 2)
                {
                    textField.userInteractionEnabled = NO;
                }
            }
        }
        
        [self.view addSubview:textField];
        
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, textField.frame.origin.y + textField.frame.size.height + 2,SCREEN_WIDTH , .5)];
        lineImageView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7];
        [self.view addSubview:lineImageView];
        
        startHeight = lineImageView.frame.origin.y + lineImageView.frame.size.height + 20;
    }

}


- (void)addCommitButton
{
    UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(20, startHeight, SCREEN_WIDTH - 20 * 2, 35) buttonTitle:@"提交" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"commitButtonPressed" tagDelegate:self];
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = FONT(16.0);
    [CommonTool clipView:button withCornerRadius:5.0];
    [self.view addSubview:button];
}

#pragma mark textField取消第一相应
- (void)exitField:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark 点击提交按钮
- (void)commitButtonPressed
{
    for (int i = 1; i < 4; i++)
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
    
    NSString *string1 = ((UITextField *)[self.view viewWithTag:1]).text;
    NSString *string2 = ((UITextField *)[self.view viewWithTag:2]).text;
    NSString *string3 = ((UITextField *)[self.view viewWithTag:3]).text;
    
    NSString *message = @"";
    if (!string1 || [@"" isEqualToString:string1])
    {
        message = @"请输入仪表里程数据";
    }
    else if (!string2 || [@"" isEqualToString:string2])
    {
        message = @"请输入上次保养里程";
    }
    else if (!string3 || [@"" isEqualToString:string3])
    {
        message = @"请输入保养里程间隔";
    }
    
    if (![@"" isEqualToString:message])
    {
        [CommonTool addAlertTipWithMessage:message];
        return;
    }
    
    [self commitCorrectTipWithLastmileage:string1 machineMileage:string2 intervalMileage:string3];
}


#pragma mark 提交矫正设置
- (void)commitCorrectTipWithLastmileage:(NSString *)lastmileage machineMileage:(NSString *)machinemileage intervalMileage:(NSString *)intervalmileage
{
    [SVProgressHUD showWithStatus:@"正在保存..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"udmtLastmileage":[NSNumber numberWithInt:[lastmileage intValue]],@"udmtMachinemileage":[NSNumber numberWithInt:[machinemileage intValue]],@"udmtIntervalmileage":[NSNumber numberWithInt:[intervalmileage intValue]],@"udmt_id":[NSNumber numberWithInt:[self.dataArray[3] intValue]],@"car_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]],@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]]};
    [request requestWithUrl1:COMMIT_CORRECT_INFO_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"commitCorrectInfoResponse===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
         {
             if ([@"8888" isEqualToString:responseDic])
             {
                 [SVProgressHUD showSuccessWithStatus:@"设置成功"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"修改失败"];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error====%@",[error description]);
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
