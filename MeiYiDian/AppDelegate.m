//
//  AppDelegate.m
//  MeiYiDian
//
//  Created by dfy on 15/1/6.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "AppDelegate.h"
#import "MYDLoginViewController.h"
#import "ViewController.h"
#import "MYDHomeViewController.h"
#import "MYDUIConstant.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[MYDMiddleViewController alloc] init]];
//    
//    MYDLeftViewController *leftVC = [[MYDLeftViewController alloc] init];
//    MYDRightViewController *rightVC = [[MYDRightViewController alloc] init];
//    RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:navi leftMenuViewController:leftVC rightMenuViewController:rightVC];
//    
//    sideMenu.backgroundImage = [UIImage imageNamed:@"Stars"];
//    sideMenu.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
//    sideMenu.delegate = self;
//    sideMenu.contentViewShadowColor = [UIColor blackColor];
//    sideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
//    sideMenu.contentViewShadowOpacity = 0.6;
//    sideMenu.contentViewShadowRadius = 12;
//    sideMenu.contentViewShadowEnabled = YES;
    
//    self.window.rootViewController = [[MYDMainViewController alloc] init];
    self.window.rootViewController = [[MYDLoginViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : kFont_Small} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : kFont_Small} forState:UIControlStateSelected];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
