//
//  MYDViewControllerManager.m
//  MeiYiDian
//
//  Created by dai.fy on 15/3/2.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDViewControllerManager.h"
#import "MYDConstants.h"

@implementation MYDViewControllerManager
+(MYDViewControllerManager *)defaultManager
{
    static MYDViewControllerManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc]init];
    });
    
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewNotify) name:kNotificationForLoginView object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeViewNotify) name:kNotificationForHomeView object:nil];
    }
    return self;
}
- (MYDHomeViewController *)homeViewController
{
    //    if (_homeViewController == nil) {
    [[NSNotificationCenter defaultCenter] removeObserver:_homeViewController.navC.viewControllers[0]];
    _homeViewController = [[MYDHomeViewController alloc] init];
    //    }
    return _homeViewController;
}

- (MYDLoginViewController *)loginViewController
{
    if (_loginViewController == nil) {
        _loginViewController = [[MYDLoginViewController alloc] init];
    }
    return _loginViewController;
}

- (void)loginViewNotify
{
    if (![self.window.rootViewController isKindOfClass:NSClassFromString(@"MYDLoginViewController")])
    {
        self.window.rootViewController = self.loginViewController;
    }
}

- (void)homeViewNotify
{
    if (![self.window.rootViewController isKindOfClass:NSClassFromString(@"MYDHomeViewController")])
    {
        self.window.rootViewController = self.homeViewController;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
