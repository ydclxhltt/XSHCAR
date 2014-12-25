//
//  CLTreeView_LEVEL2_Model.h
//  CLTreeView
//
//  Created by clei on 14-9-9.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTreeView_LEVEL2_Model : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *signture;
@property (strong,nonatomic) NSString *headImgPath;//本地图片名,若不为空则优先于远程图片加载
@property (strong,nonatomic) NSURL *headImgUrl;//远程图片链接

@end

