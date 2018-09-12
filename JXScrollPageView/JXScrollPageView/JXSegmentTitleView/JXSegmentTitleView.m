//
//  JXSegmentTitleView.m
//  JXScrollPageView
//
//  Created by 徐沈俊杰 on 2018/9/11.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXSegmentTitleView.h"
#import "JXUtilities.h"
#import "Masonry.h"

#define kSCALE [UIScreen mainScreen].bounds.size.width/375
#define kTO_SCALE(x) kSCALE*x

/**
 segment各item宽度类型

 - ItemWidthTypeChange: segment各item选中与未选中字体大小自适应宽度
 - ItemWidthTypeStatic: segment各item指定相同宽度
 */
typedef NS_OPTIONS(NSUInteger, ItemWidthType) {
    ItemWidthTypeChange = 1 << 0,
    ItemWidthTypeStatic = 1 << 1,
};

@interface JXSegmentTitleView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 titlesArray设置后，根据数据初始化button存入数组
 */
@property (nonatomic, strong) NSMutableArray *itemBtnArray;
/**
 标题数组 存储segment上的各项标题
 */
@property (nonatomic, strong) NSArray *titlesArray;
/**
 下方滑块
 */
@property (nonatomic, strong) UIView *indicatorView;
/**
 segment各item宽度类型
 */
@property (nonatomic, assign) ItemWidthType itemWidthType;

@end


@implementation JXSegmentTitleView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArray delegate:(id<JXSegmentTitleViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setSegmentProperty];
        if ([JXUtilities isValidArray:titlesArray]) {
            self.titlesArray = titlesArray;
        }
        
        self.delegate = delegate;
        
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXSegmentTitleViewWillBeginDragging:)]) {
        [self.delegate JXSegmentTitleViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXSegmentTitleViewWillEndDragging:)]) {
        [self.delegate JXSegmentTitleViewWillEndDragging:self];
    }
}

#pragma mark - Events Response
- (void)segmentTitleButtonPressed:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    if (index == self.selectIndex) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXSegmentTitleView:startIndex:endIndex:)]) {
        [self.delegate JXSegmentTitleView:self startIndex:self.selectIndex endIndex:index];
    }
    
    self.selectIndex = index;
}

#pragma mark - Method
/**
 默认属性值
 */
- (void)setSegmentProperty {
    self.itemMargin = kTO_SCALE(20);
    self.selectIndex = 0;
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:kTO_SCALE(15)];
    self.titleSelectFont = self.titleFont;
    self.isShowIndicator = YES;
    self.indicatorColor = self.titleSelectColor;
    self.itemCornerRadius = 0;
    self.itemNormalBGColor = [UIColor clearColor];
    self.itemSelectBGColor = [UIColor clearColor];
    self.segmentCornerRadius = 0;
}

- (void)addSubviews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.indicatorView];
}

- (void)setupFrame {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    
    [self setSegmentLayout];
}

- (void)setSegmentLayout {
    if (![JXUtilities isValidArray:self.itemBtnArray] || ![JXUtilities isValidArray:self.titlesArray]) {
        return;
    }
    
    __block CGFloat totalBtnWidth = 0.0;//所有button宽度及其margin的总宽度
    __block UIFont *titleFont = self.titleFont;
    
    if (self.itemWidth == 0) {
        //字体大小，选中与未选中自适应宽度
        self.itemWidthType = ItemWidthTypeChange;
    } else {
        //根据itemWidth是否有值决定item大小，如果有值根据值设置item宽度，如果为0，则根据文字长度计算item宽度
        self.itemWidthType = ItemWidthTypeStatic;
    }
    
    //计算所有button总宽度totalBtnWidth
    //分：选中与未选中的字体大小 相同，不同，和指定固定宽度，从而决定scrollview是否可以滑动
    if (self.itemWidthType == ItemWidthTypeStatic) {
        [self.titlesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            CGFloat itemBtnWidth = self.itemWidth + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }];
        
    } else {
        [self.titlesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIButton *btn = self.itemBtnArray[idx];
            titleFont = btn.isSelected ? self.titleSelectFont : self.titleFont;
            //根据字体大小获取每个button的宽度，并加上margin
            CGFloat itemBtnWidth = [JXSegmentTitleView getWidthWithString:self.titlesArray[idx] font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }];
    }
    
    //减去多加的一个margin 例：2个button1个margin，3个button2个margin
    totalBtnWidth -= self.itemMargin;
    
    //设置scrollView是否可以左右滑动
    if (totalBtnWidth <= CGRectGetWidth(self.bounds)) {//不能滑动
        //item宽度=(父宽度-(button数量-1)*margin)/button数量
        CGFloat itemBtnWidth = (CGRectGetWidth(self.bounds)-(self.itemBtnArray.count-1)*self.itemMargin)/self.itemBtnArray.count;
        CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
        //重制各个Button的位置和宽度
        [self.itemBtnArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            
            obj.frame = CGRectMake(idx * (itemBtnWidth + self.itemMargin), 0, itemBtnWidth, itemBtnHeight);
        }];
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollView.bounds));
        
    } else {
        //button总宽度超出父View 可以滑动
        //重制各个Button的位置和宽度
        
        //itemWidth指定的情况
        __block CGFloat currentX = 0;
        
        if (self.itemWidthType == ItemWidthTypeStatic) {
            [self.titlesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                UIButton *btn = self.itemBtnArray[idx];
                titleFont = btn.isSelected ? self.titleSelectFont : self.titleFont;
                CGFloat itemBtnWidth = self.itemWidth;
                CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
                btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
                currentX += itemBtnWidth + self.itemMargin;
            }];
            
        } else {//itemWidth自适应的情况
            
            [self.titlesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                UIButton *btn = self.itemBtnArray[idx];
                titleFont = btn.isSelected ? self.titleSelectFont : self.titleFont;
                CGFloat itemBtnWidth = [JXSegmentTitleView getWidthWithString:self.titlesArray[idx] font:titleFont];
                CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
                btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
                currentX += itemBtnWidth + self.itemMargin;
            }];
        }
        
        self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
    }
    
    [self moveIndicatorView:YES];
}

- (void)moveIndicatorView:(BOOL)animated {
    UIFont *titleFont = self.titleFont;
    UIButton *selectBtn = self.itemBtnArray[self.selectIndex];
    titleFont = selectBtn.isSelected ? self.titleSelectFont : self.titleFont;
    CGFloat indicatorWidth = self.itemWidth == 0 ? [JXSegmentTitleView getWidthWithString:self.titlesArray[self.selectIndex] font:titleFont] : self.itemWidth;
    
    [UIView animateWithDuration:(animated?0.5:0) animations:^{
        self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
        self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth, 2);
    } completion:^(BOOL finished) {
        [self scrollSelectBtnCenter:animated];
    }];
}

/**
 scrollview滑动至可以显示当前button的位置
 */
- (void)scrollSelectBtnCenter:(BOOL)animated {
    UIButton *selectBtn = self.itemBtnArray[self.selectIndex];
    
    CGRect centerRect = CGRectMake(selectBtn.center.x- CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView scrollRectToVisible:centerRect animated:animated];
}

/**
 计算字符串长度
 */
+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

#pragma mark - Setting And Getting
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray*)itemBtnArray {
    if (!_itemBtnArray) {
        _itemBtnArray = [[NSMutableArray alloc] init];
    }
    return _itemBtnArray;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    if ([JXUtilities isValidArray:self.itemBtnArray]) {
        [self.itemBtnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.itemBtnArray = nil;
    }
    
    [titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx + 1000;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.titleFont;
        [btn addTarget:self action:@selector(segmentTitleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
        if (idx == self.selectIndex) {
            btn.selected = YES;
        }
        [self.itemBtnArray addObject:btn];
    }];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (_selectIndex == selectIndex || selectIndex < 0 || selectIndex > self.itemBtnArray.count - 1) {
        return;
    }
    //还原前一个选中按钮的状态
    UIButton *lastBtn = [self.scrollView viewWithTag:_selectIndex + 1000];
    lastBtn.selected = NO;
    lastBtn.titleLabel.font = self.titleFont;
    [UIView animateWithDuration:0.5 animations:^{
        [lastBtn setBackgroundColor:self.itemNormalBGColor];
    }];
    
    _selectIndex = selectIndex;
    UIButton *currentBtn = [self.scrollView viewWithTag:_selectIndex + 1000];
    currentBtn.selected = YES;
    currentBtn.titleLabel.font = self.titleSelectFont;
    [UIView animateWithDuration:0.5 animations:^{
        [currentBtn setBackgroundColor:self.itemSelectBGColor];
    }];
    
    [self moveIndicatorView:YES];
}

/**
 标题文字间距，默认20
 */
- (void)setItemMargin:(CGFloat)itemMargin {
    _itemMargin = itemMargin;
    [self setSegmentLayout];
}

/**
 标题宽度, 默认为0并根据字体自动计算宽度
 */
- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [self setSegmentLayout];
}

/**
 标题字体大小
 */
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    for (UIButton *btn in self.itemBtnArray) {
        btn.titleLabel.font = titleFont;
    }
}

/**
 选中标题字体大小
 */
- (void)setTitleSelectFont:(UIFont *)titleSelectFont {
    if (self.titleFont == titleSelectFont) {
        _titleSelectFont = self.titleFont;
        return;
    }
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.itemBtnArray) {
        btn.titleLabel.font = btn.isSelected ? titleSelectFont : self.titleFont;
    }
}

/**
 标题正常颜色
 */
- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

/**
 标题选中颜色，默认red
 */
- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

/**
 是否显示导航条，默认YES
 */
- (void)setIsShowIndicator:(BOOL)isShowIndicator {
    _isShowIndicator = isShowIndicator;
    if (isShowIndicator) {
        [self.indicatorView setHidden:NO];
    } else {
        [self.indicatorView setHidden:YES];
    }
}

/**
 导航条颜色
 */
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

/**
 标题正常背景颜色，默认无色
 */
- (void)setItemNormalBGColor:(UIColor *)itemNormalBGColor {
    _itemNormalBGColor = itemNormalBGColor;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setBackgroundColor:itemNormalBGColor];
    }
}

/**
 标题选中背景颜色，默认无色
 */
- (void)setItemSelectBGColor:(UIColor *)itemSelectBGColor {
    _itemSelectBGColor = itemSelectBGColor;
    for (UIButton *btn in self.itemBtnArray) {
        if (btn.selected) {
            [btn setBackgroundColor:itemSelectBGColor];
        }
    }
}

/**
 标题圆角，默认为0
 */
- (void)setItemCornerRadius:(CGFloat)itemCornerRadius {
    _itemCornerRadius = itemCornerRadius;
    for (UIButton *btn in self.itemBtnArray) {
        btn.layer.cornerRadius = itemCornerRadius;
    }
}

/**
 标题边框颜色，默认无色
 */
- (void)setItemBorderColor:(UIColor *)itemBorderColor {
    _itemBorderColor = itemBorderColor;
    for (UIButton *btn in self.itemBtnArray) {
        btn.layer.borderColor = itemBorderColor.CGColor;
    }
}

/**
 标题边框宽度，默认为0
 */
- (void)setItemBorderWidth:(CGFloat)itemBorderWidth {
    _itemBorderWidth = itemBorderWidth;
    for (UIButton *btn in self.itemBtnArray) {
        btn.layer.borderWidth = itemBorderWidth;
    }
}

/**
 容器圆角，默认为0
 */
- (void)setSegmentCornerRadius:(CGFloat)segmentCornerRadius {
    _segmentCornerRadius = segmentCornerRadius;
    self.layer.cornerRadius = segmentCornerRadius;
}

/**
 容器边框颜色，默认无色
 */
- (void)setSegmentBorderColor:(UIColor *)segmentBorderColor {
    _segmentBorderColor = segmentBorderColor;
    self.layer.borderColor = segmentBorderColor.CGColor;
}

/**
 容器边框宽度，默认为0
 */
- (void)setSegmentBorderWidth:(CGFloat)segmentBorderWidth {
    _segmentBorderWidth = segmentBorderWidth;
    self.layer.borderWidth = segmentBorderWidth;
}
@end
