//
//  BookingViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//



#import "BookingViewController.h"
#import "CLPickerView.h"

@interface BookingViewController ()<UITextFieldDelegate>
{
    NSMutableArray *sortArray;
    UIScrollView *scrollView;
}
@property(nonatomic, strong) NSString *timeStr;
@property(nonatomic, retain) NSArray *bookingInfoArray;
@property(nonatomic, retain) NSArray *placeStringArray;
@property(nonatomic, retain) NSArray *titleArray;
@end
 @implementation BookingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //添加右边item
    [self setNavBarItemWithTitle:@"     提交" navItemType:rightItem selectorName:@"commitButtonPressed:"];
    //初始化
    sortArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化数据
    self.titleArray = @[@"车主电话:",@"品       牌:",@"车牌号码:",@"车       系:",@"车       型:",@"预约时间:",@"预约类型"];
    self.placeStringArray = @[@"请输入车主电话",@"请输入品牌类型",@"请输入车牌号码",@"请输入车系",@"请输入车型",@"请选择时间"];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    //获取预约信息
    [self getBookingInfo];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addScrollView];
}

- (void)addScrollView
{
    
    float labelHeight = 30.0;
    float sortHeight  = 25.0;
    float addHeight = 10.0;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    scrollView.pagingEnabled = NO;
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, labelHeight * [self.titleArray count] + addHeight * ([self.titleArray count] + 1) + [self.dataArray count] * (addHeight + sortHeight));
    [self.view addSubview:scrollView];
    
    
    for (int i = 0; i < [self.titleArray count]; i++)
    {
        UILabel *titlelabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, addHeight * (i + 1) + labelHeight * i, 80.0, labelHeight) textString:self.titleArray[i] textColor:[UIColor grayColor] textFont:FONT(15.0)];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:titlelabel];
        
        if (i == [self.titleArray count] - 1)
        {
            break;
        }
        
        UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(titlelabel.frame.size.width ,titlelabel.frame.origin.y, scrollView.frame.size.width - titlelabel.frame.size.width - 10, labelHeight) textColor:[UIColor blackColor] textFont:FONT(16.0) placeholderText:self.placeStringArray[i]];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = i + 1;
        if (i == 0)
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 5)
        {
            CLPickerView *picker = [[CLPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240.0) pickerViewType:PickerViewTypeTime sureBlock:^(UIDatePicker *datePicker,NSDate *date){textField.text = [CommonTool getStringFromDate:date formatterString:@"YYYY-MM-dd hh:mm"];self.timeStr = textField.text; [textField resignFirstResponder];} cancelBlock:^{[textField resignFirstResponder];}];
            [picker setPickViewMinDate];
            textField.inputView = picker;
        }
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = self.bookingInfoArray[i];
        [scrollView addSubview:textField];
    }
    
    float sort_y = labelHeight * [self.titleArray count] + addHeight * ([self.titleArray count] + 1);
    
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(10, sort_y, SCREEN_WIDTH - 10 *2, [self.dataArray count] * (addHeight + sortHeight)) placeholderImage:nil];
    [CommonTool clipView:bgImageView withCornerRadius:5.0];
    bgImageView.userInteractionEnabled = YES;
    [CommonTool setViewLayer:bgImageView withLayerColor:APP_MAIN_COLOR bordWidth:.5];
    [scrollView addSubview:bgImageView];
    
    for (int i = 0; i < [self.dataArray count]; i++)
    {
        UIImage *sortImage = [UIImage imageNamed:@"sort_up.png"];
        UIButton *iconButton = [CreateViewTool createButtonWithFrame:CGRectMake(10, 5 + (sortHeight - sortImage.size.height/2)/2 + (addHeight + sortHeight) * i, sortImage.size.width/2 , sortImage.size.height/2) buttonImage:@"" selectorName:@"" tagDelegate:nil];
        iconButton.tag = 100 + i;
        [iconButton setBackgroundImage:sortImage forState:UIControlStateNormal];
        [iconButton setBackgroundImage:[UIImage imageNamed:@"sort_down.png"] forState:UIControlStateSelected];
        [bgImageView addSubview:iconButton];
        
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(10, 5 + (addHeight + sortHeight) * i, bgImageView.frame.size.width - 10 * 2, sortHeight) buttonImage:@"" selectorName:@"buttonPressed:" tagDelegate:self];
        button.tag = 1000 + i;
        button.titleLabel.font = FONT(15.0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [button setBackgroundColor:[UIColor clearColor]];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitle:self.dataArray[i][1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [bgImageView addSubview:button];
    }
    
}

#pragma mark 获取预约信息
- (void)getBookingInfo
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:BOOKING_PERSONAL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"bookingResponseDic===%@",responseDic);
        if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
        {
            [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
            NSString *phone = ([responseDic objectForKey:@"AM_Telphone"]) ? [responseDic objectForKey:@"AM_Telphone"] : @"";
            NSString *cb_name = ([responseDic objectForKey:@"cb_name"]) ? [responseDic objectForKey:@"cb_name"] : @"";
            NSString *c_plates = ([responseDic objectForKey:@"c_plates"]) ? [responseDic objectForKey:@"c_plates"] : @"";
            NSString *cl_name = ([responseDic objectForKey:@"cl_name"]) ? [responseDic objectForKey:@"cl_name"] : @"";
            NSString *cm_name = ([responseDic objectForKey:@"cm_name"]) ? [responseDic objectForKey:@"cm_name"] : @"";
            weakSelf.bookingInfoArray = @[phone,cb_name,c_plates,cl_name,cm_name,@""];
            weakSelf.dataArray = (NSMutableArray *)[responseDic objectForKey:@"list"];
            [weakSelf createUI];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
            //服务器异常
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
        NSLog(@"error===%@",error);
    }];
}


#pragma mark 提交预约信息
- (void)commitBookingWithPhone:(NSString *)phone acID:(NSString *)ac_id carNumber:(NSString *)carNO
{
    [SVProgressHUD showWithStatus:@"正在提交..."];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"AM_Telphone":phone,@"AM_AppointmentTime":self.timeStr,@"ac_id":ac_id,@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"chepai":carNO};
    NSLog(@"requestDic===%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl1:BOOKING_COMMIT_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"excitingResponseDic===%@",responseDic);
         if (responseDic && ![@"" isEqualToString:responseDic] && ![@"null" isEqualToString:responseDic])
         {
             if ([@"8888" isEqualToString:responseDic])
             {
                 [SVProgressHUD showSuccessWithStatus:@"提交成功"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"提交失败"];
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
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
         NSLog(@"error===%@",error);
    }];
}

#pragma mark 提交按钮响应事件
- (void)commitButtonPressed:(UIButton *)button
{

    NSString *phone = @"";
    NSString *ac_id = @"";
    NSString *carNO = @"";
    for (int i = 0; i < [sortArray count]; i++)
    {
        if (i == 0)
        {
            ac_id = [NSString stringWithFormat:@"%d",[sortArray[i] intValue]];
        }
        else
        {
            ac_id = [ac_id stringByAppendingString:[NSString stringWithFormat:@",%@",sortArray[i]]];
        }
        
    }
    for (int i = 0; i < [self.titleArray count]; i++)
    {
        if (i < [self.titleArray count] - 1)
        {
            UITextField *textField = (UITextField *)[scrollView viewWithTag:i + 1];
            
            if (i == 0)
            {
                if ([textField.text isEqualToString:@""] || ![CommonTool isEmailOrPhoneNumber:textField.text])
                {
                    [CommonTool addAlertTipWithMessage:@"请输入正确的手机号"];
                    return;
                }
                else
                {
                    phone = textField.text;
                }
                
            }
            if (i == 2)
            {
                if ([textField.text isEqualToString:@""])
                {
                    [CommonTool addAlertTipWithMessage:@"请输入车牌号号"];
                    return;
                }
                else
                {
                    carNO = textField.text;
                }

            }
            if (i == [self.titleArray count] - 2)
            {
                if ([@"" isEqualToString:textField.text])
                {
                    NSString *tipString = [NSString stringWithFormat:@"请填写%@",self.titleArray[i]];
                    tipString = @"请选择预约时间";
                    [CommonTool addAlertTipWithMessage:tipString];
                    return;
                }

            }
        }
    }
    
    if ([@"" isEqualToString:ac_id])
    {
        [CommonTool addAlertTipWithMessage:@"请选择预约类型"];
        return;
    }
    
    [self commitBookingWithPhone:phone acID:ac_id carNumber:carNO];
}

#pragma mark 预约类型响应时间
- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    UIButton *button = (UIButton *)[scrollView viewWithTag:sender.tag - (1000 - 100)];
    button.selected = !button.selected;
    if (sender.selected)
    {
        [sortArray addObject:self.dataArray[sender.tag - 1000][0]];
    }
    else
    {
        [sortArray removeObject:self.dataArray[sender.tag - 1000][0]];
    }
}

#pragma mark UITextFieldDelehate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
