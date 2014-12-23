//
//  CLPickerView.m
//  XSHCar
//
//  Created by clei on 14/12/23.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CLPickerView.h"

typedef void (^SureBlock) (UIDatePicker *datePicker, NSDate *date);
typedef void (^CancelBlock) ();

@interface CLPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIDatePicker *datePicker;
}
@property(nonatomic, assign) PickerViewType pickerType;
@property(nonatomic, copy) SureBlock sureBlock;
@property(nonatomic, copy) CancelBlock cancelBlock;
@end

@implementation CLPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)type sureBlock:(void (^)(UIDatePicker *datePicker,NSDate *date))sure cancelBlock:(void (^)())cancel
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.pickerType = type;
        self.cancelBlock = cancel;
        self.sureBlock = sure;
        [self createUIWithPickerViewType:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

#pragma mark 初始化UI
- (void)createUIWithPickerViewType:(PickerViewType)type
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:Nil];
    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(sure)];
    toolBar.items = @[cancelItem,spaceItem,sureItem];
    [self addSubview:toolBar];
    
    if (PickerViewTypeDate == type)
    {
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height,self.frame.size.width, self.frame.size.height - toolBar.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.minimumDate = [NSDate date];
        [self addSubview:datePicker];
    }
    else if (PickerViewTypeCustom == type)
    {
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height,self.frame.size.width, self.frame.size.height - toolBar.frame.size.height)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
    }
}

#pragma mark pickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dataArray count];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [self.dataArray[component] count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}


- (void)cancel
{
    if (self.cancelBlock)
    {
        self.cancelBlock();
    }
}

- (void)sure
{
    if (PickerViewTypeDate == self.pickerType)
    {
        //datePicker.date;
        if (self.sureBlock)
        {
            self.sureBlock(datePicker,datePicker.date);
        }
    }
}


@end
