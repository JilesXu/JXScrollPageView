//
//  JXSegmentExtraModel.h
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/27.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXSegmentExtraModel : NSObject

/**
 插入位置
 */
@property (nonatomic, assign) NSInteger insertLocation;
/**
 item名称
 */
@property (nonatomic, strong) NSString *title;

@end
