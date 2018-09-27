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
#import "JXScrollPageModel.h"
#import "JXSegmentExtraModel.h"

@interface MainViewController : UIViewController

/*****必要属性******/

@property (nonatomic, strong) JXSegmentTitleView *segmentTitleView;
@property (nonatomic, strong) JXPageContentView *pageContentView;
@property (nonatomic, strong) JXScrollPageModel *scrollPageModel;
/*****************/

@property (nonatomic, assign) NSInteger currentIndex;

@end
