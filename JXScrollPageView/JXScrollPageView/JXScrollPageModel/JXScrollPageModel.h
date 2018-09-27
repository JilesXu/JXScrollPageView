//
//  JXScrollPageModel.h
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/27.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXSegmentExtraModel.h"

@interface JXScrollPageModel : NSObject

/**
 PageContent中的子Controller
 */
@property (nonatomic, strong) NSArray *childVCsArray;
/**
 segementTitle数组
 */
@property (nonatomic, strong) NSArray *segementTitleArray;
/**
 不对应子controller的segement'item,即点击后只有点击事件，没有controller滑动
 */
@property (nonatomic, strong) NSArray<JXSegmentExtraModel *> *segementExtraArray;

@end
