//
//  CLPickerView.h
//  XSHCar
//
//  Created by clei on 14/12/23.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PickerViewTypeDate,
    PickerViewTypeCustom,
} PickerViewType;

@interface CLPickerView : UIView

@property(nonatomic, retain) NSArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(PickerViewType)type sureBlock:(void (^)(UIDatePicker *datePicker,NSDate *date))sure cancelBlock:(void (^)())cancel;

@end
