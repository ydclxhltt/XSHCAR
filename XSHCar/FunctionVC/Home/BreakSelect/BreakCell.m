//
//  BreakCell.m
//  XSHCar
//
//  Created by clei on 14/11/19.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import "BreakCell.h"

@implementation BreakCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.borderColor = [[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.3] CGColor];
        self.layer.borderWidth = .2;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        // Initialization code
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 75, self.frame.size.height)];
        //_titleLabel.textColor = [UIColor grayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_titleLabel];
        
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, 230, self.frame.size.height)];
        //_descLabel.textColor = [UIColor grayColor];
        _descLabel.numberOfLines = 10000;
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_descLabel];
        
    }
    return self;
}

- (void)setDescLabelFrame
{
    _descLabel.frame = CGRectMake(85, 0, 230, self.frame.size.height);
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
