//
//  MYDTitleSwitchView.m
//  MeiYiDian
//
//  Created by dai.fy on 15/3/9.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDTitleSwitchView.h"
#import "MYDUIConstant.h"
@implementation MYDTitleSwitchView
{
    NSInteger _selectedIndex;
}

- (void)setDataArray:(NSArray *)dataArray
{
    if (dataArray != nil) {
        _dataArray = dataArray;
        [self setSubviews];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        //设置scrollView
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

- (id)initWithTitleArray:(NSArray *)dataArray frame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setSubviews
{
    //设置scrollView
    _scrollView.contentSize = CGSizeMake(kWidthForTitleScrollViewItem * self.dataArray.count, 60);
    //设置button
    for (int i = 0; i < self.dataArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.dataArray[i] objectForKey:@"Name"] forState:UIControlStateNormal];
        button.frame = CGRectMake(i * kWidthForTitleScrollViewItem, 0, kWidthForTitleScrollViewItem, 60);
        button.tag = i + 1;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:kColorForDardRed forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    [self selectIndex:0];
}

- (void)didSelected:(UIButton *)button
{
    if ([[self viewWithTag:_selectedIndex] isKindOfClass:[UIButton class]]) {
        ((UIButton *)[self viewWithTag:_selectedIndex]).selected = NO;
    }
    button.selected = YES;
    [self.delegate titleSwitchView:self DidSelected:button.tag - 1];
    _selectedIndex = button.tag;
}

- (void)selectIndex:(NSInteger)index
{
    if ([[self viewWithTag:_selectedIndex] isKindOfClass:[UIButton class]]) {
        ((UIButton *)[self viewWithTag:_selectedIndex]).selected = NO;
    }
    if ([[self viewWithTag:index + 1] isKindOfClass:[UIButton class]]) {
        ((UIButton *)[self viewWithTag:index + 1]).selected = YES;
    }
    _selectedIndex = index + 1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
