//
//  HomeViewController.m
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/11.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

#define navHeight self.navigationController.navigationBar.frame.size.height
#define statusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kSegmentHeight 50

@interface MainViewController ()<JXSegmentTitleViewDelegate, JXPageContentViewDelegate>

@property (nonatomic, strong) FirstViewController *firstVC;
@property (nonatomic, strong) SecondViewController *secondVC;
@property (nonatomic, strong) ThirdViewController *thirdVC;

@end

@implementation MainViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self setupFrame];
    
    [self setCurrentContentIndex:self.currentIndex];
}

#pragma mark - JXSegmentTitleViewDelegate
- (void)JXSegmentTitleView:(JXSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        self.currentIndex = endIndex;
        self.pageContentView.contentViewCurrentIndex = endIndex;
    }];
}

#pragma mark - JXPageContentViewDelegate
- (void)JXPageContentViewDidEndDecelerating:(JXSegmentTitleView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        self.currentIndex = endIndex;
        self.segmentTitleView.selectIndex = endIndex;
    }];
}

- (void)JXPageContentViewDidScroll:(JXSegmentTitleView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress {
    self.segmentTitleView.selectIndex = endIndex;
}

#pragma mark - Method
- (void)setCurrentContentIndex:(NSInteger)index {
    self.segmentTitleView.selectIndex = index;
    self.pageContentView.contentViewCurrentIndex = index;
}

- (void)addSubviews {
    [self.view addSubview:self.segmentTitleView];
    [self.view addSubview:self.pageContentView];
}

- (void)setupFrame {
    [self.segmentTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(statusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kSegmentHeight);
    }];
    
    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentTitleView.mas_bottom);
        make.left.right.and.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setting And Getting
- (JXSegmentTitleView *)segmentTitleView {
    if (!_segmentTitleView) {
        CGRect segmentFrame = CGRectMake(0,
                                         statusHeight,
                                         CGRectGetWidth(self.view.bounds),
                                         kSegmentHeight);
        _segmentTitleView = [[JXSegmentTitleView alloc] initWithFrame:segmentFrame titles:self.scrollPageModel.segementTitleArray delegate:self];
        _segmentTitleView.titleSelectFont = [UIFont systemFontOfSize:14];
        _segmentTitleView.titleFont = [UIFont systemFontOfSize:14];
        _segmentTitleView.itemMargin = 0;
        _segmentTitleView.titleNormalColor = [UIColor whiteColor];
        _segmentTitleView.titleSelectColor = [UIColor blueColor];
        _segmentTitleView.itemNormalBGColor = [UIColor greenColor];
        _segmentTitleView.itemSelectBGColor = [UIColor orangeColor];
        _segmentTitleView.isShowIndicator = YES;
        _segmentTitleView.indicatorColor = [UIColor blackColor];
        _segmentTitleView.segmentCornerRadius = segmentFrame.size.height/2;
        _segmentTitleView.segmentBorderColor = [UIColor whiteColor];
        _segmentTitleView.segmentBorderWidth = 1;
        _segmentTitleView.itemBorderWidth = 0.5;
        _segmentTitleView.itemBorderColor = [UIColor whiteColor];
        _segmentTitleView.backgroundColor = [UIColor grayColor];
    }
    
    return _segmentTitleView;
}

- (JXPageContentView *)pageContentView {
    if (!_pageContentView) {
        _pageContentView = [[JXPageContentView alloc] initWithFrame:
                            CGRectMake(0,
                                       CGRectGetHeight(self.segmentTitleView.bounds),
                                       CGRectGetWidth(self.view.bounds),
                                       CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.segmentTitleView.bounds))
                                                           childVCs:self.scrollPageModel.childVCsArray
                                                           parentVC:self
                                                           delegate:self
                                                        andSegement:self.segmentTitleView];
        _pageContentView.contentViewCurrentIndex = 2;
    }

    return _pageContentView;
}

- (JXScrollPageModel *)scrollPageModel {
    if (!_scrollPageModel) {
        _scrollPageModel = [[JXScrollPageModel alloc] init];
        _scrollPageModel.childVCsArray = [NSArray arrayWithObjects:self.firstVC, self.secondVC, self.thirdVC, nil];
        _scrollPageModel.segementTitleArray = @[@"通信",@"生活",@"营业厅"];
        
        JXSegmentExtraModel *model = [[JXSegmentExtraModel alloc] init];
        model.insertLocation = 2;
        model.title = @"插入位置";
        
        _scrollPageModel.segementExtraArray = @[model];
    }
    
    return _scrollPageModel;
}

- (FirstViewController *)firstVC {
    if (!_firstVC) {
        _firstVC = [[FirstViewController alloc] init];
        _firstVC.view.backgroundColor = [UIColor redColor];
    }
    
    return _firstVC;
}

- (SecondViewController *)secondVC {
    if (!_secondVC) {
        _secondVC = [[SecondViewController alloc] init];
        _secondVC.view.backgroundColor = [UIColor greenColor];
    }
    
    return _secondVC;
}

- (ThirdViewController *)thirdVC {
    if (!_thirdVC) {
        _thirdVC = [[ThirdViewController alloc] init];
        _thirdVC.view.backgroundColor = [UIColor blueColor];
    }
    
    return _thirdVC;
}
@end
