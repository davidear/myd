//
//  MYDCollectionViewCell2.m
//  MeiYiDian
//
//  Created by dfy on 15/2/11.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDCollectionViewCell2.h"
#import "MYDUIConstant.h"

@implementation MYDCollectionViewCell2

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = kColorForBorder;
}
@end
