//
//  HomeViewController.h
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/11.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSegmentTitleView.h"
#import "JXPageContentView.h"

@interface MainViewController : UIViewController

/*****必要属性******/

@property (nonatomic, strong) JXSegmentTitleView *segmentTitleView;
@property (nonatomic, strong) JXPageContentView *pageContentView;
/**
 子Controller数组
 */
@property (nonatomic, strong) NSArray *childVCsArray;
/*****************/

@property (nonatomic, assign) NSInteger currentIndex;

@end
