//
//  MYDProgressManager.m
//  MeiYiDian
//
//  Created by dfy on 15/1/26.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDProgressManager.h"

@implementation MYDProgressManager
#pragma mark - 单例
static MYDProgressManager *instant = nil;
+(MYDProgressManager *)getInstant
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instant=[[[self class] alloc] init];
    });
    return instant;
}

- (id)init{
    self = [super init];
    if (self) {
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.backgroundColor = [UIColor blueColor];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if(instant==nil)
    {
        instant=[super allocWithZone:zone];
    }
    return instant;
}

-(id)copyWithZone:(NSZone *)zone
{
    return instant;
}

#pragma mark - 具体方法
- (void)showInView:(UIView *)view
{
    self.progressView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height * 2 / 3);
    [view addSubview:self.progressView];
}
- (void)dismiss
{
    [self.progressView removeFromSuperview];
}
@end
