//
//  MYDEnterpriseIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDEnterpriseIntroduceViewController.h"


@interface MYDEnterpriseIntroduceViewController ()<UITabBarDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *introductionCatalogsArray;
@property (strong, nonatomic) NSArray *introductionArray;
@end

@implementation MYDEnterpriseIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
}
- (void)initDataSource
{
    self.introductionCatalogsArray = [[MYDDBManager getInstant] readIntroductionCatalogs];
    self.introductionArray = [[MYDDBManager getInstant] readIntroductions];
}
//- (void)initSubviews
//{
//    self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 80 * self.introductionCatalogsArray.count, 60)];
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < self.introductionCatalogsArray.count; i++) {
//        NSDictionary *dic = [self.introductionCatalogsArray objectAtIndex:i];
//        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"Name"] image:nil selectedImage:nil];
//        item.tag = i;
//        [array addObject:item];
//    }
//    self.tabBar.items = array;
//    self.tabBar.delegate = self;
//    self.tabBar.selectedItem = array[0];
//    [self.view addSubview:self.tabBar];
//    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598)];
//    self.scrollView.contentSize = CGSizeMake(874 * self.introductionCatalogsArray.count, 598);
//    self.scrollView.delegate = self;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    [self.view addSubview:self.scrollView];
//}

- (void)setSubviews
{
    //个性化父类组件
    self.tabBar.frame = CGRectMake(0, 0, 100 * self.introductionCatalogsArray.count, 60);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.introductionCatalogsArray.count; i++) {
        NSDictionary *dic = [self.introductionCatalogsArray objectAtIndex:i];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"Name"] image:[UIImage imageNamed:@"all_icon_3.png"] selectedImage:nil];
        item.tag = i;
        [array addObject:item];
    }
    self.tabBar.items = array;
    self.tabBar.selectedItem = array[0];
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 598);
    self.scrollView.contentSize = CGSizeMake(874 * self.introductionCatalogsArray.count, 598);
    
    
    //加载webView
    for (int i =0; i < self.introductionCatalogsArray.count; i++) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 598)];
        webView.backgroundColor = [UIColor whiteColor];
        NSString *idStr;
        for (NSDictionary *dic in self.introductionArray) {
            if ([[dic objectForKey:@"CatalogId"] isEqualToString:[self.introductionCatalogsArray[i] objectForKey:@"Id"]]) {
                idStr = [dic objectForKey:@"Id"];
            }
        }
        NSString *str = [NSString stringWithFormat:@"http://pad.zmmyd.com/Publics/Introduction.aspx?id=%@",idStr];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.scrollView addSubview:webView];
    }

}
//#pragma mark - UITabBar
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
//    
//    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//
//}
//#pragma mark - UIScrollView
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    // 根据scorllView的contentOffset属性，判断当前所在的页数
//    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
//    
//    // 设置TabBar
//    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
//}
@end