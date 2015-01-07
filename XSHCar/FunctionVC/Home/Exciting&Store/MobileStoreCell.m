//
//  MobileStoreCell.m
//  XSHCar
//
//  Created by chenlei on 15/1/1.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "MobileStoreCell.h"
#import "CreateViewTool.h"
#import "CommonHeader.h"

@interface MobileStoreCell()
{
    UILabel *titleLabel;
    UILabel *contentLabel;
    UILabel *priceLable;
    UIImageView *prevImageView;
}
@end


@implementation MobileStoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        prevImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(5, 5, 78, 60) placeholderImage:[UIImage imageNamed:@"pic_default"]];
        prevImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:prevImageView];
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(96, 4 ,SCREEN_WIDTH - 96 - 30, 20)];
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = FONT(16.0);
        [self.contentView addSubview:titleLabel];
        
        
        contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(96, 25 ,SCREEN_WIDTH - 96 - 30, 20)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.numberOfLines = 1;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = FONT(14.0);
        [self.contentView addSubview:contentLabel];
        
        priceLable=[[UILabel alloc]initWithFrame:CGRectMake(96, 45 ,SCREEN_WIDTH - 96 - 30, 20)];
        priceLable.backgroundColor=[UIColor clearColor];
        priceLable.textColor = [UIColor grayColor];
        priceLable.font = FONT(14.0);
        [self.contentView addSubview:priceLable];
    }
    return self;
}


- (void)setCellDataWithImageUrl:(NSString *)imageUrl titleText:(NSString *)title contentText:(NSString *)content priceText:(NSString *)price
{
    [prevImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pic_default"]];
    prevImageView.contentMode = UIViewContentModeScaleAspectFit;
    priceLable.text = price;
    titleLabel.text = title;
    contentLabel.text = content;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
