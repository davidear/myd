//
//  MYDPartyIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//http://pad.zmmyd.com/Publics/Party.aspx?id=活动方案Id

#import "MYDPartyIntroduceViewController.h"

@interface MYDPartyIntroduceViewController ()
////UI
//@property (strong, nonatomic) UITabBar *tabBar;
//@property (strong, nonatomic) UIScrollView *scrollView;
//DATA
@property (strong, nonatomic) NSArray *partiesArray;
//@property (strong, nonatomic) NSArray *introductionArray;
@end

@implementation MYDPartyIntroduceViewController
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self initDataSource];
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [self setSubviews];
//}
- (void)initDataSource
{
    self.partiesArray = [[MYDDBManager getInstant] readParties];
//    self.introductionArray = [[MYDDBManager getInstant] readIntroductions];
}


- (void)setSubviews
{
    //个性化父类组件
    self.tabBar.frame = CGRectMake(0, 0, 80 * self.partiesArray.count, 60);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.partiesArray.count; i++) {
        NSDictionary *dic = [self.partiesArray objectAtIndex:i];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"Name"] image:nil selectedImage:nil];
        item.tag = i;
        [array addObject:item];
    }
    self.tabBar.items = array;
    self.tabBar.selectedItem = array[0];
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 618);
    self.scrollView.contentSize = CGSizeMake(874 * self.partiesArray.count, 618);
    
    
    //加载webView
    for (int i =0; i < self.partiesArray.count; i++) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 618)];
        NSString *idStr = [self.partiesArray[i] objectForKey:@"Id"];
        NSString *str = [NSString stringWithFormat:@"http://pad.zmmyd.com/Publics/Party.aspx?id=%@",idStr];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.scrollView addSubview:webView];
    }
}
@end
