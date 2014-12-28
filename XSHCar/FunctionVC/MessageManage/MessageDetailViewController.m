//
//  MessageDetailViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/27.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //不在设置偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTextView];
}

- (void)addTextView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, NAV_HEIGHT + 20, SCREEN_WIDTH - 10 * 2, 220)];
    [CommonTool setViewLayer:textView withLayerColor:[UIColor grayColor] bordWidth:.5];
    [CommonTool clipView:textView withCornerRadius:5.0];
    textView.editable = NO;
    textView.textColor = [UIColor grayColor];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.text = self.detailText;
    textView.font = FONT(15.0);
    [self.view addSubview:textView];
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
