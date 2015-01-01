//
//  MobileStoreCell.h
//  XSHCar
//
//  Created by chenlei on 15/1/1.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MobileStoreCell : UITableViewCell

/*
 *  设置表格数据
 *
 *  @pram  imageUrl  图片地址
 *  @pram  title     标题
 *  @pram  content   描述
 *  @pram  price     价格
 */
- (void)setCellDataWithImageUrl:(NSString *)imageUrl titleText:(NSString *)title contentText:(NSString *)content priceText:(NSString *)price;

@end
