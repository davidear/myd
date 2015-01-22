//
//  MYDPriceIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDPriceIntroduceViewController.h"
#import "MYDDBManager.h"
#import "SDImageCache.h"
#define kTableViewForProject 10
#define kTableViewForMaterial 20
@interface MYDPriceIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate>
//DATA
@property (strong, nonatomic) NSArray *catalogsArray;
@property (strong, nonatomic) NSArray *projectArray;
@property (strong, nonatomic) NSArray *materialArray;
//UI
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MYDPriceIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
}

- (void)initDataSource
{
    self.catalogsArray = @[@{@"Name":@"项目"},@{@"Name":@"产品"}];
    self.projectArray = [[MYDDBManager getInstant] readProjects];
    self.materialArray = [[MYDDBManager getInstant] readMaterials];
}
- (void)setSubviews
{
    //个性化父类组件
    self.tabBar.frame = CGRectMake(0, 0, 80 * self.catalogsArray.count, 60);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.catalogsArray.count; i++) {
        NSDictionary *dic = [self.catalogsArray objectAtIndex:i];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"Name"] image:nil selectedImage:nil];
        item.tag = i;
        [array addObject:item];
    }
    self.tabBar.items = array;
    self.tabBar.selectedItem = array[0];
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 618);
    self.scrollView.contentSize = CGSizeMake(874 * self.catalogsArray.count, 618);
    
    //添加列表
    for (int i =0; i < self.catalogsArray.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 618)];
        if ([[self.catalogsArray[i] objectForKey:@"Name"] isEqualToString:@"项目"]) {
            tableView.tag = kTableViewForProject;
        }else{
            tableView.tag = kTableViewForMaterial;
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
        
    }
    

}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case kTableViewForMaterial: return self.materialArray.count;
        case kTableViewForProject: return self.projectArray.count;
        default: return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
//    NSDictionary *dic = self.materialdataArray[indexPath.row];
    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"TitlePictureFileName"];
//    cell.textLabel.text = [dic objectForKey:@"Name"];
    return cell;
}
@end
