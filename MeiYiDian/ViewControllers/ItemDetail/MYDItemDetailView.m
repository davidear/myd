//
//  MYDItemDetailView.m
//  MeiYiDian
//
//  Created by dfy on 15/1/24.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDItemDetailView.h"
#import "MYDDBManager.h"
#import "SDImageCache.h"
#import "MYDConstants.h"
#import "MYDUIConstant.h"
@interface MYDItemDetailView()
@property (strong, nonatomic) NSDictionary *pictureEntityDic;
@end

@implementation MYDItemDetailView
- (id)initWithImage:(UIImage *)image Title :(NSString *)title Price:(NSNumber *)price Description:(NSString *)descriptioin PictureEntityDic:(NSDictionary *)dic
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MYDItemDetailView" owner:nil options:nil] lastObject];
    if (self) {
        [self.imageButton setImage:image forState:UIControlStateNormal];
        self.titleLabel.text = title;
        self.priceLabel.text = [NSString stringWithFormat:@"RMB：%@",price];
        self.descriptionTextView.text = descriptioin;
        self.descriptionTextView.font = kFont_Normal;
        self.descriptionTextView.textColor = kColorForMaroon;
        self.pictureEntityDic = dic;
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
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *array = [[MYDDBManager getInstant] readMaterialPictures];
    [array addObjectsFromArray:[[MYDDBManager getInstant] readProjectPictures]];
    [array addObjectsFromArray:[[MYDDBManager getInstant] readWritingPictures]];
    [array addObjectsFromArray:[[MYDDBManager getInstant] readTeamPictures]];
    if (array == nil) {
        return;
    }
    for (NSDictionary *dic in array) {
        if ([[self.pictureEntityDic objectForKey:@"Id"] isEqualToString:[dic objectForKey:@"FKId"]]) {
            [tempArr addObject:[dic objectForKey:@"FileName"]];
        }
    }
    if (tempArr.count == 0) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForImageButtonAction object:tempArr];
}

- (void)reloadDataWithImage:(UIImage *)image PictureEntityDic:(NSDictionary *)dic
{
    self.pictureEntityDic = dic;
    [self.imageButton setImage:image forState:UIControlStateNormal];
    self.titleLabel.text = [dic objectForKey:@"Name"];
    self.priceLabel.text = [NSString stringWithFormat:@"RMB：%@",[dic objectForKey:@"Price"]];
    self.descriptionTextView.text = [dic objectForKey:@"Description"];
    self.descriptionTextView.font = kFont_Normal;
    self.descriptionTextView.textColor = kColorForMaroon;
    
    self.Id = [dic objectForKey:@"Id"];
}
@end
