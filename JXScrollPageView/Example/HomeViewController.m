//
//  HomeViewController.m
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/11.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "HomeViewController.h"
#import "JXSegmentTitleView.h"
#import "Masonry.h"

#define statusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kSegmentHeight 50

@interface HomeViewController ()<JXSegmentTitleViewDelegate>

@property (nonatomic, strong) JXSegmentTitleView *segmentTitleView;

@end

@implementation HomeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self setupFrame];
}

#pragma mark - Method
- (void)addSubviews {
    [self.view addSubview:self.segmentTitleView];
}

- (void)setupFrame {
    [self.segmentTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(statusHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kSegmentHeight);
    }];
    
//    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationView.mas_bottom);
//        make.left.right.and.bottom.equalTo(self.view);
//    }];
}

- (JXSegmentTitleView *)segmentTitleView {
    if (!_segmentTitleView) {
        CGRect segmentFrame = CGRectMake(0,
                                         statusHeight,
                                         CGRectGetWidth(self.view.bounds),
                                         kSegmentHeight);
        _segmentTitleView = [[JXSegmentTitleView alloc] initWithFrame:segmentFrame titles:@[@"通信",@"生活",@"营业厅"] delegate:self];
        _segmentTitleView.titleSelectFont = [UIFont systemFontOfSize:14];
        _segmentTitleView.titleFont = [UIFont systemFontOfSize:14];
        _segmentTitleView.itemMargin = 0;
        _segmentTitleView.titleNormalColor = [UIColor whiteColor];
        _segmentTitleView.itemNormalBGColor = [UIColor greenColor];
        _segmentTitleView.itemSelectBGColor = [UIColor whiteColor];
        _segmentTitleView.isShowIndicator = NO;
        _segmentTitleView.segmentCornerRadius = segmentFrame.size.height/2;
        _segmentTitleView.segmentBorderColor = [UIColor whiteColor];
        _segmentTitleView.segmentBorderWidth = 1;
        _segmentTitleView.itemBorderWidth = 0.5;
        _segmentTitleView.itemBorderColor = [UIColor whiteColor];
        _segmentTitleView.backgroundColor = [UIColor grayColor];
    }
    
    return _segmentTitleView;
}
@end
