//
//  MYDBaseSubViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/22.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDBaseSubViewController.h"


@implementation MYDBaseSubViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initDataSource];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubviews];
}

- (void)initDataSource
{
    
}

- (void)initSubviews
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 874, 60)];
//    view.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
//    [self.view addSubview:view];
//    self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 874, 60)];
////    self.tabBar.layer.borderWidth = 1;
////    self.tabBar.layer.borderColor = [UIColor blueColor].CGColor;
//    self.tabBar.delegate = self;
//    [self.view addSubview:self.tabBar];
    self.titleSwitchView = [[MYDTitleSwitchView alloc] initWithFrame:CGRectMake(0, 0, 874, 60)];
    self.titleSwitchView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    self.titleSwitchView.delegate = self;
    [self.view addSubview:self.titleSwitchView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598)];
    self.scrollView.contentSize = CGSizeMake(874, 598);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

//#pragma mark - UITabBar
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
//    
//    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//    
//}
#pragma mark - MYDTitle
#pragma mark - UIScrollViewSwitchViewDelegate
- (void)titleSwitchView:(MYDTitleSwitchView *)titleSwitchView DidSelected:(NSInteger)index
{
    CGFloat offsetX = index * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据scorllView的contentOffset属性，判断当前所在的页数
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 设置TabBar
//    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
    [self.titleSwitchView selectIndex:pageNo];
}
@end