//
//  CommonTool.m
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool


//判断是否是Email格式或者手机号
+ (BOOL)isEmailOrPhoneNumber:(NSString*)string
{
    //    NSString *patternPhoneNumber = @"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString *patternPhoneNumber = @"^((1[0-9])|(1[0-9])|(1[0-9]))\\d{9}$";
    NSString *patternEmail = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSError *error = NULL;
    //定义正则表达式
    NSRegularExpression *regexPhoneNumber = [NSRegularExpression regularExpressionWithPattern:patternPhoneNumber options:0 error:&error];
    NSRegularExpression *regexEmail = [NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:&error];
    //使用正则表达式匹配字符
    NSTextCheckingResult *isMatchPhoneNumber = [regexPhoneNumber firstMatchInString:string
                                                                            options:0
                                                                              range:NSMakeRange(0, [string length])];
    NSTextCheckingResult *isMatchEmail = [regexEmail firstMatchInString:string
                                                                options:0
                                                                  range:NSMakeRange(0, [string length])];
    
    if (isMatchPhoneNumber || isMatchEmail)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断身份证是否合格
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


//颜色转图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//计算文字高度
+ (float)labelHeightWithTextLabel:(UILabel *)textLabel textFont:(UIFont *)font
{
    /*
     *  IOS2 - IOS7
     *  CGSize titleBrandSizeForHeight = [textLabel.text sizeWithFont:font];
     *  CGSize titleBrandSizeForLines = [textLabel.text sizeWithFont:font constrainedToSize:CGSizeMake(textLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
     */
    
    //---IOS7开始使用
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize titleBrandSizeForHeight = [textLabel.text sizeWithAttributes:attributeDic];
    CGSize titleBrandSizeForLines = [textLabel.text boundingRectWithSize:CGSizeMake(textLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
    //---
    int number= ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    textLabel.numberOfLines = number;
    float theHeigth=0.0;
    if (number <= 1)
    {
        theHeigth = titleBrandSizeForHeight.height;
    }
    else
    {
        theHeigth = number*titleBrandSizeForHeight.height;
    }
    return theHeigth;
}

+ (float)labelHeightWithText:(NSString *)text textFont:(UIFont*)font labelWidth:(float)width
{
    /*
     *  IOS2 - IOS7
     *  CGSize titleBrandSizeForHeight = [textLabel.text sizeWithFont:font];
     *  CGSize titleBrandSizeForLines = [textLabel.text sizeWithFont:font constrainedToSize:CGSizeMake(textLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
     */
    
    //---IOS7开始使用
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize titleBrandSizeForHeight = [text sizeWithAttributes:attributeDic];
    CGSize titleBrandSizeForLines = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
    //---
    int number= ceil(titleBrandSizeForLines.height/titleBrandSizeForHeight.height);
    float theHeigth=0.0;
    if (number <= 1)
    {
        theHeigth = titleBrandSizeForHeight.height;
    }
    else
    {
        theHeigth = number*titleBrandSizeForHeight.height;
    }
    return theHeigth;
}

//设置图层相关
+ (void)setViewLayer:(UIView *)view withLayerColor:(UIColor *)color bordWidth:(float)width
{
    if (!view)
        return;
    if (color)
        view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = width;
}

//圆角实现
+ (void)clipView:(UIView *)view withCornerRadius:(float)radius
{
    if (!view)
        return;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}


@end
