//
//  IndexPageCell.m
//  WonHot3
//
//  Created by clei on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExcitingListCell.h"
#import "CommonHeader.h"
#import "CreateViewTool.h"

@interface ExcitingListCell()
{
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIImageView *prevImageView;
}
@end

@implementation ExcitingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        prevImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(4, 5, 78, 50) placeholderImage:[UIImage imageNamed:@"pic_default"]];
        [self.contentView addSubview:prevImageView];
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(96, 4 ,SCREEN_WIDTH - 96 - 30, 20)];
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = FONT(16.0);
        [self.contentView addSubview:titleLabel];
      
        
        contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(96, 25 ,SCREEN_WIDTH - 96 - 30, 35)];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.numberOfLines = 2;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = FONT(14.0);
        [self.contentView addSubview:contentLabel];
    }
    return self;
}


- (void)setCellDataWithImageUrl:(NSString *)imageUrl titleText:(NSString *)title contentText:(NSString *)content
{
    [prevImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pic_default"]];
    titleLabel.text = title;
    contentLabel.text = content;
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{   

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
