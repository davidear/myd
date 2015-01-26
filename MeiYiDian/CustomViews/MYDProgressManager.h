//
//  MYDProgressManager.h
//  MeiYiDian
//
//  Created by dfy on 15/1/26.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYDProgressManager : NSObject
@property (strong, nonatomic) UIProgressView *progressView;

+(MYDProgressManager *)getInstant;


- (void)showInView:(UIView *)view;
- (void)dismiss;
@end
