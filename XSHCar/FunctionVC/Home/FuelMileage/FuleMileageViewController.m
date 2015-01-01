//
//  FuleMileageViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "FuleMileageViewController.h"

@interface FuleMileageViewController ()
{
    UIButton *leftButton,*rightButton;
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
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addDateButotns];
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
    rightButton = [CreateViewTool createButtonWithFrame:CGRectMake(rightButton_left_x, left_y, buttonWidth, label_heigh - add_y) buttonTitle:[CommonTool getStringFromDate:nowDate formatterString:@"yyyy_MM_dd"] titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"dateButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:rightButton withLayerColor:APP_MAIN_COLOR bordWidth:.5];
    [CommonTool clipView:rightButton withCornerRadius:5.0];
    [self.view addSubview:rightButton];
    
    startHeight += label_heigh;
}


#pragma mark date按钮响应事件
- (void)dateButtonPressed:(UIButton *)sender
{
    
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
