//
//  MYDPartyIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//http://pad.zmmyd.com/Publics/Party.aspx?id=活动方案Id

#import "MYDPartyIntroduceViewController.h"

@interface MYDPartyIntroduceViewController ()
@property (strong, nonatomic) NSArray *partiesArray;
@end

@implementation MYDPartyIntroduceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
}

- (void)initDataSource
{
    self.partiesArray = [[MYDDBManager getInstant] readParties];
}


- (void)setSubviews
{
    //个性化父类组件
    self.tabBar.frame = CGRectMake(0, 0, 120 * self.partiesArray.count, 60);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.partiesArray.count; i++) {
        NSDictionary *dic = [self.partiesArray objectAtIndex:i];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"Name"] image:nil selectedImage:nil];
        item.tag = i;
        [array addObject:item];
    }
    self.tabBar.items = array;
    self.tabBar.selectedItem = array[0];
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 598);
    self.scrollView.contentSize = CGSizeMake(874 * self.partiesArray.count, 598);
    
    
    //加载webView
    for (int i =0; i < self.partiesArray.count; i++) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 598)];
        webView.scrollView.alwaysBounceVertical = NO;
        webView.backgroundColor = [UIColor whiteColor];
        NSString *idStr = [self.partiesArray[i] objectForKey:@"Id"];
        NSString *str = [NSString stringWithFormat:@"http://pad.zmmyd.com/Publics/Party.aspx?id=%@",idStr];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.scrollView addSubview:webView];
    }
}
@end
