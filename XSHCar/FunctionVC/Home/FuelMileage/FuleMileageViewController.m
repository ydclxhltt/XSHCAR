//
//  FuleMileageViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "FuleMileageViewController.h"
#import "LineView.h"
#import "CLPickerView.h"

@interface FuleMileageViewController ()
{
    UIButton *leftButton,*rightButton;
    LineView *lineView1,*lineView2;
    UIImageView *bgImageView;
    CLPickerView *pickView;
    BOOL isLeft;
}
@end

@implementation FuleMileageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加反悔item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //获取数据
    [self getData];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addDateButotns];
    [self addLabels];
    [self addLineView];
}

- (void)addDateButotns
{
    startHeight = NAV_HEIGHT;
    float label_width = 20.0;
    float left_x = (SCREEN_WIDTH - label_width)/2;
    float label_heigh = 35.0;
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, startHeight, label_width, label_heigh) textString:@"至" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    float buttonWidth = 140.0;
    float leftButton_left_x = left_x - buttonWidth;
    float add_y = 5.0;
    float left_y = startHeight + add_y;
    NSDate *nowDate = [NSDate date];
    NSDate *lastDate = [NSDate dateWithTimeInterval:- 30 * 24 * 60 * 60 sinceDate:nowDate];
    leftButton = [CreateViewTool createButtonWithFrame:CGRectMake(leftButton_left_x, left_y, buttonWidth, label_heigh - add_y) buttonTitle:[CommonTool getStringFromDate:lastDate formatterString:@"yyyy-MM-dd"] titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"dateButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:leftButton withLayerColor:APP_MAIN_COLOR bordWidth:.5];
    [CommonTool clipView:leftButton withCornerRadius:5.0];
    [self.view addSubview:leftButton];
    
    float rightButton_left_x = left_x + label_width;
    rightButton = [CreateViewTool createButtonWithFrame:CGRectMake(rightButton_left_x, left_y, buttonWidth, label_heigh - add_y) buttonTitle:[CommonTool getStringFromDate:nowDate formatterString:@"yyyy-MM-dd"] titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"dateButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:rightButton withLayerColor:APP_MAIN_COLOR bordWidth:.5];
    [CommonTool clipView:rightButton withCornerRadius:5.0];
    [self.view addSubview:rightButton];
    
    startHeight += label_heigh + 3;
}

- (void)addPickView
{
    if (pickView)
    {
        [UIView animateWithDuration:.3 animations:^{pickView.frame = CGRectMake(0, SCREEN_HEIGHT - 240.0, SCREEN_WIDTH, 240.0);}];
        return;
    }
   pickView =  [[CLPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 240.0, SCREEN_WIDTH, 240.0) pickerViewType:PickerViewTypeDate sureBlock:^(UIDatePicker *datePicker,NSDate *date)
    {
        NSDate *rightDate;
        NSDate *leftDate;
        if (isLeft)
        {
            rightDate = [date dateByAddingTimeInterval:30 * 24 * 60 * 60];
            if ([rightDate compare:[NSDate date]] != NSOrderedAscending)
            {
                rightDate = [NSDate date];
            }
            leftDate =date;
        }
        else
        {
            leftDate = [date dateByAddingTimeInterval:- 30 * 24 * 60 * 60];
            rightDate = date;
            
        }
        [leftButton setTitle:[CommonTool getStringFromDate:leftDate formatterString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [rightButton setTitle:[CommonTool getStringFromDate:rightDate formatterString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{pickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240.0);}];
        [self getData];
    }
    cancelBlock:^
    {
        [UIView animateWithDuration:.3 animations:^{pickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240.0);}];
    }];
    [pickView setPickViewMaxDate];
    [self.view addSubview:pickView];
}

- (void)addLabels
{
    UIImage *image = [UIImage imageNamed:@"towline"];
    float height = image.size.height/2;
    height = (SCREEN_WIDTH/320.0)*height;
    bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH, height) placeholderImage:image];
    [self.view addSubview:bgImageView];
    
    float labelHeight = height/2;
    float labelWidth = bgImageView.frame.size.width/2;
    
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(j * labelWidth , i * labelHeight, labelWidth, labelHeight) textString:@"" textColor:[UIColor blackColor] textFont:FONT(15.0)];
            //label.textAlignment = NSTextAlignmentCenter;
            label.tag = i * 2 + j + 1;
            [bgImageView addSubview:label];
        }
    }
    
    startHeight += height + 10.0;
}

- (void)addLineView
{
    float add_height = 10.0;
    float height = (SCREEN_HEIGHT - startHeight - add_height * 2)/2;
    
    lineView1 = [[LineView alloc]initWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH, height)];
    lineView1.backgroundColor =[UIColor clearColor];
    [self.view addSubview:lineView1];

    startHeight += height + add_height;
    
    lineView2 = [[LineView alloc]initWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH,height)];
    lineView2.backgroundColor =[UIColor clearColor];
    [self.view addSubview:lineView2];
}

#pragma mark 获取油耗数据
- (void)getData
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"carId":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]],@"beginDate":[leftButton titleForState:UIControlStateNormal],@"endDate":[rightButton titleForState:UIControlStateNormal]};
    NSLog(@"requestDic====%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:FULEMILEAGE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"fulemileageResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             weakSelf.dataArray = [NSMutableArray arrayWithArray:responseDic];
             [weakSelf setFuleMileageData];
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


#pragma mark 设置数据
- (void)setFuleMileageData
{
    [self setLabelsData];
    [self setLineViewData];
}

- (void)setLabelsData
{
    float totleCount = 0.0;
    float totleFuleMileage = 0.0;
    
    for (NSArray *array in self.dataArray)
    {
        if ([array count] == 4)
        {
            totleCount += [[array objectAtIndex:1] floatValue];
            totleFuleMileage += [[array objectAtIndex:2] floatValue];
        }
    }
    
    float perMileage = totleCount/[self.dataArray count];
    float perFule = totleFuleMileage/[self.dataArray count];
    
    NSString *totleString = [NSString stringWithFormat:@"   里程: %.2f km",totleCount];
    NSString *totleFuleString = [NSString stringWithFormat:@"   油耗: %.2f L",totleFuleMileage];
    NSString *perMileageString = [NSString stringWithFormat:@"   %.2f km/日",perMileage];
    NSString *perFuleString = [NSString stringWithFormat:@"   %.2f L/100Km",perFule];
    NSArray *array = @[totleString,perMileageString,totleFuleString,perFuleString];
    
    for (int i = 1; i < 5; i++)
    {
        UILabel *label = (UILabel *)[bgImageView  viewWithTag:i];
        label.text = array[i - 1];
    }
}

- (void)setLineViewData
{
    NSMutableArray *fuleArray = [NSMutableArray array];
    NSMutableArray *mileageArray = [NSMutableArray array];
    for (NSArray *array in self.dataArray)
    {
        if ([array count] == 4)
        {
            NSString *fuleString = [NSString stringWithFormat:@"%@:%@",array[3],array[2]];
            NSString *MileageString = [NSString stringWithFormat:@"%@:%@",array[3],array[1]];
            [fuleArray addObject:fuleString];
            [mileageArray addObject:MileageString];
        }
    }
    NSLog(@"mileageArray===%@",mileageArray);
    [lineView1 drawXCoors:mileageArray title:@"里程统计表(日期格式,年/日/月,单位)" flag:0];
    [lineView2 drawXCoors:fuleArray title:@"油耗统计表(日期格式,年/日/月,单位)" flag:0];
}

#pragma mark date按钮响应事件
- (void)dateButtonPressed:(UIButton *)sender
{
    isLeft = (sender == leftButton) ? YES : NO;
    [self addPickView];
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
