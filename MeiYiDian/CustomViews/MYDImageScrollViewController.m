//
//  MYDImageScrollViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/31.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDImageScrollViewController.h"
#import "MYDDBManager.h"

@interface MYDImageScrollViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *IdStr;
@end

@implementation MYDImageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];
    [self setSubviews];
}
- (void)initDataSource
{
    self.dataArray = [NSMutableArray array];
    NSArray *array = [[MYDDBManager getInstant] readMaterials];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"Id"] isEqualToString:self.IdStr]) {
            for (NSDictionary *dic in [[MYDDBManager getInstant] readMaterialPictures]) {
                if ([[dic objectForKey:@"Id"] isEqualToString:self.IdStr]) {
                    [self.dataArray addObject:dic];
                }
            }
        }
    }
    
    array = [[MYDDBManager getInstant] readProjects];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"Id"] isEqualToString:self.IdStr]) {
            for (NSDictionary *dic in [[MYDDBManager getInstant] readProjectPictures]) {
                if ([[dic objectForKey:@"Id"] isEqualToString:self.IdStr]) {
                    [self.dataArray addObject:dic];
                }
            }
        }
    }

}
- (void)setSubviews
{
    for (int i = 0;i < self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        imageView.image = [UIImage imageNamed:[dic objectForKey:@"TitlePictureFileName"]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * self.dataArray.count, self.scrollView.bounds.size.height);
}

- (id)initWithId:(NSString *)IdStr
{
    self = [super init];
    if (self != nil) {
        self.IdStr = IdStr;
    }
    return self;
}
#pragma mark - ScrollView
@end
