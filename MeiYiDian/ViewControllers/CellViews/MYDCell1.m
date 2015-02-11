//
//  MYDCell1.m
//  MeiYiDian
//
//  Created by dfy on 15/2/7.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDCell1.h"
#import "MYDUIConstant.h"

@implementation MYDCell1
{
    UIImageView *lineView;
}
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    self.imageView.frame = CGRectMake(20, 15, 120, 120);
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.descriptionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.descriptionLabel];
        lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 149, 874, 1)];
        [self.contentView addSubview:lineView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 15, 120, 120);
    self.textLabel.textColor = kColorForMaroon;
    self.textLabel.frame = CGRectMake(160, 15, 560, 40);
    self.textLabel.font = [UIFont boldSystemFontOfSize:22];
    self.imageView.layer.borderColor = [[UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1] CGColor];
    self.imageView.layer.borderWidth = 1;
    
    self.descriptionLabel.font = [UIFont systemFontOfSize:18];
    self.descriptionLabel.frame = CGRectMake(160, 55, 560, 50);
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.detailTextLabel.frame = CGRectMake(740, 60, 120, 30);
    self.detailTextLabel.textColor = [UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
    
    lineView.backgroundColor = [UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1];
}
@end
