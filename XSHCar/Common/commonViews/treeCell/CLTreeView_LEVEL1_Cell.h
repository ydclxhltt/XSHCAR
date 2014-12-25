//
//  CLTreeView_LEVEL1_Cell.h
//  这个cell可以作为树形列表的根节点或者第二层节点
//
//  Created by clei on 14-9-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTreeViewNode.h"

@interface CLTreeView_LEVEL1_Cell : UITableViewCell

@property (retain,strong,nonatomic) CLTreeViewNode *node;//data
@property (strong,nonatomic) IBOutlet UIImageView *arrowView;//箭头
@property (strong,nonatomic) IBOutlet UILabel *sonCount;//叶子数
@property (strong,nonatomic) IBOutlet UILabel *name;

@end


