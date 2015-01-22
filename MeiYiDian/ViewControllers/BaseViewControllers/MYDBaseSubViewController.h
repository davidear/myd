//
//  MYDBaseSubViewController.h
//  MeiYiDian
//
//  Created by dfy on 15/1/22.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDBaseViewController.h"
#import "MYDDBManager.h"

@interface MYDBaseSubViewController : MYDBaseViewController<UITabBarDelegate,UIScrollViewDelegate>
//UI
@property (strong, nonatomic) UITabBar *tabBar;
@property (strong, nonatomic) UIScrollView *scrollView;

- (id)init;
- (void)initDataSource;
- (void)initSubviews;
@end
