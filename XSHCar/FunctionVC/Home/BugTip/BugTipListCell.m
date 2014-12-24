//
//  BugTipListCell.m
//  XSHCar
//
//  Created by chenlei on 14/12/24.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BugTipListCell.h"
#import "CreateViewTool.h"
#import "CommonHeader.h"

@interface BugTipListCell()
{
    UILabel *textLabel;
    UIImageView *bgImageView;
}
@end

@implementation BugTipListCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //初始化UI
        [self createUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)createUI
{
    bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, self.frame.size.height) placeholderImage:nil];
    [CommonTool setViewLayer:bgImageView withLayerColor:[UIColor grayColor] bordWidth:.5];
    [CommonTool clipView:bgImageView withCornerRadius:5.0];
    [self.contentView addSubview:bgImageView];
    
    textLabel = [CreateViewTool createLabelWithFrame:CGRectMake(5, 0, bgImageView.frame.size.width - 5 * 2, bgImageView.frame.size.height) textString:@"" textColor:[UIColor blackColor] textFont:FONT(16.0)];
    [bgImageView addSubview:textLabel];
}

#pragma mark 设置Text
- (void)setLabelTextWithTitle:(NSString *)title contentText:(NSString *)content
{
    NSString *titleStr = (title) ? title : @"";
    NSString *contentStr = (content) ? content : @"";
    NSString *textString = [titleStr stringByAppendingString:contentStr];
    if (![@"" isEqualToString:textString])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textString];
        [attributedString addAttribute:NSFontAttributeName
                                 value:FONT(16.0)
                            range:[textString rangeOfString:titleStr]];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor grayColor]
                                 range:[textString rangeOfString:titleStr]];
        [attributedString addAttribute:NSFontAttributeName
                                 value:FONT(15.0)
                                 range:[textString rangeOfString:contentStr]];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor lightGrayColor]
                                 range:[textString rangeOfString:contentStr]];
        textLabel.attributedText = attributedString;
        float height = [CommonTool labelHeightWithTextLabel:textLabel textFont:FONT(15.0)];
        CGRect frame = bgImageView.frame;
        frame.size.height = height + 20;
        bgImageView.frame = frame;
        textLabel.frame = CGRectMake(5, 0, bgImageView.frame.size.width - 5 * 2, bgImageView.frame.size.height);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
