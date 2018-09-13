//
//  JXPageContentView.m
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/13.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXPageContentView.h"
#import "Masonry.h"

#define kCollectionViewCell @"kCollectionViewCell"

@interface JXPageContentView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UIViewController *parentVC;//父视图
@property (nonatomic, strong) NSArray *childsVCs;//子视图数组
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) BOOL isSelectBtn;//是否是滑动

@end

@implementation JXPageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<JXPageContentViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentVC = parentVC;
        self.childsVCs = childVCs;
        self.delegate = delegate;
        
        [self addSubViews];
        [self setupFrame];
    }
    return self;
}

#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childsVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //让数组中的每个元素 都调用removeFromSuperview
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *childVc = self.childsVCs[indexPath.row];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self willDisappearWithIndex:indexPath.row];
    [self didDisappearWithIndex:indexPath.row];
}

- (void)willDisappearWithIndex:(NSInteger)index {
    UIViewController<JXPageContentViewDelegate> *controller = self.childsVCs[index];
    if (controller) {
        if ([controller respondsToSelector:@selector(viewWillDisappearForIndex:)]) {
            [controller viewWillDisappearForIndex:index];
        }
    }
    
}

- (void)didDisappearWithIndex:(NSInteger)index {
    UIViewController<JXPageContentViewDelegate> *controller = self.childsVCs[index];
    if (controller) {
        if ([controller respondsToSelector:@selector(viewDidDisappearForIndex:)]) {
            [controller viewDidDisappearForIndex:index];
        }
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isSelectBtn = NO;
    self.startOffsetX = scrollView.contentOffset.x;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXPageContentViewWillBeginDragging:)]) {
        [self.delegate JXPageContentViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isSelectBtn) {
        return;
    }
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(self.startOffsetX/scrollView_W);//floor向下取整  4.9 = 4
    NSInteger endIndex;
    CGFloat progress;
    if (currentOffsetX > self.startOffsetX) {//左滑left
        progress = (currentOffsetX - self.startOffsetX)/scrollView_W;
        endIndex = startIndex + 1;
        if (endIndex > self.childsVCs.count - 1) {
            endIndex = self.childsVCs.count - 1;
        }
    } else if (currentOffsetX == self.startOffsetX){//没滑过去
        progress = 0;
        endIndex = startIndex;
    } else {//右滑right
        progress = (_startOffsetX - currentOffsetX)/scrollView_W;
        endIndex = startIndex - 1;
        endIndex = endIndex < 0 ? 0 : endIndex;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXPageContentViewDidScroll:startIndex:endIndex:progress:)]) {
        [self.delegate JXPageContentViewDidScroll:self startIndex:startIndex endIndex:endIndex progress:progress];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(self.startOffsetX/scrollView_W);
    NSInteger endIndex = floor(currentOffsetX/scrollView_W);
    
    self.contentViewCurrentIndex = endIndex;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXPageContentViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate JXPageContentViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(JXPageContentViewDidEndDragging:)]) {
            [self.delegate JXPageContentViewDidEndDragging:self];
        }
    }
}

#pragma mark - Method
- (void)addSubViews {
    self.startOffsetX = 0;
    self.isSelectBtn = NO;
    self.contentViewCanScroll = YES;
    
    for (UIViewController *childVC in self.childsVCs) {
        [self.parentVC addChildViewController:childVC];
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}

- (void)setupFrame {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
}

#pragma mark - Setting And Getting
- (UICollectionViewLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCell];
    }
    
    return _collectionView;
}

- (void)setContentViewCurrentIndex:(NSInteger)contentViewCurrentIndex {
    if (contentViewCurrentIndex < 0 || contentViewCurrentIndex > self.childsVCs.count-1) {
        return;
    }
    self.isSelectBtn = YES;
    _contentViewCurrentIndex = contentViewCurrentIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:contentViewCurrentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setContentViewCanScroll:(BOOL)contentViewCanScroll {
    _contentViewCanScroll = contentViewCanScroll;
    _collectionView.scrollEnabled = _contentViewCanScroll;
}

@end
