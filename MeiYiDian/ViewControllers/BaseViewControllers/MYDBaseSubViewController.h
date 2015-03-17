//
//  MYDBaseSubViewController.h
//  MeiYiDian
//
//  Created by dfy on 15/1/22.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDBaseViewController.h"
#import "MYDDBManager.h"
#import "MYDTitleSwitchView.h"
#import "MYDScrollView.h"

@interface MYDBaseSubViewController : MYDBaseViewController<UITabBarDelegate,UIScrollViewDelegate,MYDTitleSwitchViewDelegate>
//UI
//@property (strong, nonatomic) UITabBar *tabBar;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic)MYDTitleSwitchView *titleSwitchView;
@property (strong, nonatomic) MYDScrollView *detailScrollView;

- (id)init;
- (void)initDataSource;
- (void)initSubviews;
@end
