//
//  JXSegmentTitleView.h
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/11.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXSegmentTitleView;

@protocol JXSegmentTitleViewDelegate <NSObject>
@optional
/**
 切换标题
 
 @param startIndex 点击之前的index
 @param endIndex 点击之后的index
 */
- (void)JXSegmentTitleView:(JXSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;
/**
 将要开始滑动
 */
- (void)JXSegmentTitleViewWillBeginDragging:(JXSegmentTitleView *)titleView;

/**
 将要停止滑动
 */
- (void)JXSegmentTitleViewWillEndDragging:(JXSegmentTitleView *)titleView;
@end

@interface JXSegmentTitleView : UIView

@property (nonatomic, weak) id <JXSegmentTitleViewDelegate> delegate;

/**
 标题文字间距，默认20
 */
@property (nonatomic, assign) CGFloat itemMargin;
/**
 选中标题index
 */
@property (nonatomic, assign) NSInteger selectIndex;
/**
 标题字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 选中标题字体大小
 */
@property (nonatomic, strong) UIFont *titleSelectFont;
/**
 标题正常颜色
 */
@property (nonatomic, strong) UIColor *titleNormalColor;
/**
 标题选中颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectColor;
/**
 是否显示导航条，默认YES
 */
@property (nonatomic, assign) BOOL isShowIndicator;
/**
 导航条颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;
/**
 标题正常背景颜色，默认无色
 */
@property (nonatomic, strong) UIColor *itemNormalBGColor;
/**
 标题选中背景颜色，默认无色
 */
@property (nonatomic, strong) UIColor *itemSelectBGColor;
/**
 标题圆角，默认为0
 */
@property (nonatomic, assign) CGFloat itemCornerRadius;
/**
 标题边框颜色，默认无色
 */
@property (nonatomic, strong) UIColor *itemBorderColor;
/**
 标题边框宽度，默认为0
 */
@property (nonatomic, assign) CGFloat itemBorderWidth;

/**
 标题宽度, 默认为0并根据字体自动计算宽度
 */
@property (nonatomic, assign) CGFloat itemWidth;
/**
 容器圆角，默认为0
 */
@property (nonatomic, assign) CGFloat segmentCornerRadius;
/**
 容器边框颜色，默认无色
 */
@property (nonatomic, strong) UIColor *segmentBorderColor;
/**
 容器边框宽度，默认为0
 */
@property (nonatomic, assign) CGFloat segmentBorderWidth;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray delegate:(id<JXSegmentTitleViewDelegate>)delegate;

@end
