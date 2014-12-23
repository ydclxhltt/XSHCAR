//
//  IndexPageCell.h
//  WonHot3
//
//  Created by clei on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface ExcitingListCell : UITableViewCell

/*
 *  设置表格数据
 *
 *  @pram  imageUrl  图片地址
 *  @pram  title     标题
 *  @pram  content   描述
 */
- (void)setCellDataWithImageUrl:(NSString *)imageUrl titleText:(NSString *)title contentText:(NSString *)content;

@end
