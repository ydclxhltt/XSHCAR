//
//  BreakSelectViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define SEGMENT_HEIGHT 40.0

#import "BreakSelectViewController.h"
#import "SDSegmentedControl.h"

@interface BreakSelectViewController ()
{
    SDSegmentedControl *segmentView;
    UIScrollView *contentScrollView;
    UIView *selectView,*recordView,*dealView;
    UIButton *cityButton;
}
@end

@implementation BreakSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addSegmentView];
    [self addScrollView];
    [self addContentViewWithIndex:0];
}

- (void)addSegmentView
{
    NSMutableArray *itemsArray = (NSMutableArray *)@[@"违章查询",@"违章记录",@"违章处理"];
    segmentView = [[SDSegmentedControl alloc] initWithItems:itemsArray];
    [segmentView addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SEGMENT_HEIGHT);
    [self.view addSubview:segmentView];
}

- (void)addScrollView
{
    float start_y = segmentView.frame.size.height + segmentView.frame.origin.y;
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, start_y, SCREEN_WIDTH, SCREEN_HEIGHT - start_y)];
    contentScrollView.backgroundColor = [UIColor clearColor];
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, contentScrollView.frame.size.height);
    [self.view addSubview:contentScrollView];
}


#pragma mark 点击分段控件
- (void)segmentedValueChanged:(SDSegmentedControl *)segment
{
    [self addContentViewWithIndex:segment.selectedSegmentIndex];
}

#pragma mark 添加视图
- (void)addContentViewWithIndex:(int)index
{
    [contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0)];
    switch (index)
    {
        case 0:
            [self addSelectView];
            break;
        case 1:
            [self addRecordView];
            break;
        case 2:
            [self addDealView];
            break;
        default:
            break;
    }
}

- (void)addSelectView
{
    if (!selectView)
    {
        NSArray *titleArray = @[@"车牌号码:",@"车架号码:",@"发动机号:"];
        NSArray *deArray = @[@"请输入后台后6位",@"请输入车架号后6位",@"请输入完整发动机号"];
        selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, contentScrollView.frame.size.height)];

        float height = 0.0;
        
        for (int i = 0; i < [titleArray count]; i++)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,5 + (35 + 9)*i, 80, 35)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16.0];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = titleArray[i];
            [selectView addSubview:label];
            
            float x = label.frame.origin.x + label.frame.size.width;
            float w = 200;
            if (i == 0)
            {
                UIImage *image = [UIImage imageNamed:@"arrow.png"];
                cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
                cityButton.frame = CGRectMake(label.frame.size.width - 5, label.frame.origin.y, image.size.width/4, image.size.height/4);
                [cityButton setTitle:@"粤" forState:UIControlStateNormal];
                //[cityButton addTarget:self action:@selector(showCity) forControlEvents:UIControlEventTouchUpInside];
                [cityButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [selectView addSubview:cityButton];
                x += 32.0;
                w = 190.0;
            }
            else
            {
                w = 225.0;
            }
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(x,label.frame.origin.y, w, 35)];
            textField.background=[UIImage imageNamed:@"框"];
            textField.tag = i + 1;
            textField.placeholder = [deArray objectAtIndex:i];
            textField.returnKeyType =  UIReturnKeyDone;
            textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            UIView *left  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, textField.frame.size.height)];
            textField.leftView = left;
            textField.font = [UIFont systemFontOfSize:14.0];
            textField.leftViewMode = UITextFieldViewModeAlways;
            //[textField addTarget:self action:@selector(exitEvent:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [selectView addSubview:textField];
            
            UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, textField.frame.origin.y + textField.frame.size.height + 4,SCREEN_WIDTH , .5)];
            lineImageView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7];
            [selectView addSubview:lineImageView];
            
            
            height = label.frame.origin.y + 35 + 15;
        }
        UIImage *image = [UIImage imageNamed:@"btn_bg"];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 2*image.size.width/3)/2, height, 2*image.size.width/3, 2*image.size.height/3)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"开始查询" forState:UIControlStateNormal];
        //[button addTarget:self action:@selector(commitButtonPressed) forControlEvents:UIControlEventTouchDown];
        [selectView addSubview:button];
        
        [contentScrollView addSubview:selectView];
    }
}

- (void)addRecordView
{
    
}

- (void)addDealView
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
