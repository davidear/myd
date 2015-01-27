//
//  MYDItemDetailView.h
//  MeiYiDian
//
//  Created by dfy on 15/1/24.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYDItemDetailView : UIView
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

- (id)initWithImage:(UIImage *)image Title:(NSString *)title Price:(NSNumber *)price Description:(NSString *)descriptioin;

//刷新界面
- (void)reloadDataWithImage:(UIImage *)image Title :(NSString *)title Price:(NSNumber *)price Description:(NSString *)descriptioin;
@end
