//
//  MYDCollectionViewCell.h
//  MeiYiDian
//
//  Created by dfy on 15/2/11.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYDCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@end
