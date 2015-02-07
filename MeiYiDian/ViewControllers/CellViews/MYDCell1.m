//
//  MYDCell1.m
//  MeiYiDian
//
//  Created by dfy on 15/2/7.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDCell1.h"

@implementation MYDCell1
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    self.imageView.frame = CGRectMake(20, 15, 120, 120);
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 15, 120, 120);
}
@end
