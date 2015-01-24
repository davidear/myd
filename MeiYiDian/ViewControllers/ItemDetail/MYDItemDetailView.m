//
//  MYDItemDetailView.m
//  MeiYiDian
//
//  Created by dfy on 15/1/24.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDItemDetailView.h"

@implementation MYDItemDetailView
- (id)initWithImage:(UIImage *)image Title :(NSString *)title Price:(NSNumber *)price Description:(NSString *)descriptioin
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MYDItemDetailView" owner:nil options:nil] lastObject];
    if (self) {
        [self.imageButton setImage:image forState:UIControlStateNormal];
        self.titleLabel.text = title;
        self.priceLabel.text = [NSString stringWithFormat:@"价格：%@元",price];
        self.descriptionTextView.text = descriptioin;
    }
    return self;
}

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MYDItemDetailView" owner:nil options:nil] lastObject];
    if (self) {
    }
    return self;
}
- (IBAction)imageButtonAction:(id)sender {
}
@end
