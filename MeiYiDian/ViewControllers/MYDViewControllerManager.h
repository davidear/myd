//
//  MYDViewControllerManager.h
//  MeiYiDian
//
//  Created by dai.fy on 15/3/2.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYDLoginViewController.h"
#import "MYDHomeViewController.h"

@interface MYDViewControllerManager : NSObject
@property (nonatomic, weak) UIWindow *window;
@property (strong, nonatomic) MYDHomeViewController *homeViewController;
@property (strong, nonatomic) MYDLoginViewController *loginViewController;

/**
 *	@brief	此单例作为程序ViewController的根容器，
 *  可以在此类中处理全局的页面跳转，如：收到呼叫、挤下线等；
 *  几个属性用于各个子页面访问根Controller
 *
 *	@return	defaultManager
 */
+ (MYDViewControllerManager *)defaultManager;
@end
