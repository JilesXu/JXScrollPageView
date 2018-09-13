//
//  JXPageContentView.h
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/13.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSegmentTitleView.h"

@class JXPageContentView;

@protocol JXPageContentViewDelegate <NSObject>
@optional

/**
 JXPageContentView开始滑动
 */
- (void)JXPageContentViewWillBeginDragging:(JXPageContentView *)contentView;

/**
 JXPageContentView滑动调用
 @param progress 滑动进度
 */
- (void)JXPageContentViewDidScroll:(JXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 JXPageContentView结束滑动
 */
- (void)JXPageContentViewDidEndDecelerating:(JXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 scrollViewDidEndDragging
 */
- (void)JXPageContentViewDidEndDragging:(JXPageContentView *)contentView;


/**
 自定义的生命周期
 由于addChildViewController后子controller的viewDisappear不能正常调用，所以自定义
 */
- (void)viewWillDisappearForIndex:(NSInteger)index;
- (void)viewDidDisappearForIndex:(NSInteger)index;
@end

@interface JXPageContentView : UIView


- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<JXPageContentViewDelegate>)delegate andSegement:(JXSegmentTitleView *)segmentTitleView;

@property (nonatomic, weak) id<JXPageContentViewDelegate> delegate;

/**
 contentView当前页面index
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end
