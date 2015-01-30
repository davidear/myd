//
//  MYDWritingIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDWritingIntroduceViewController.h"

#import "MYDDBManager.h"
#import "SDImageCache.h"
#import "MYDItemDetailView.h"

#define kMainScrollView 100
#define kDetailScrollView 200
@interface MYDWritingIntroduceViewController()<UITableViewDataSource, UITableViewDelegate>

//DATA
@property (strong, nonatomic) NSArray *catalogsArray;
@property (strong, nonatomic) NSArray *writingArray;

//整理后的数据字典
@property (strong, nonatomic) NSMutableArray *sortedCatalogIdArray;
@property (strong, nonatomic) NSMutableDictionary *sortedDic;
@property (strong, nonatomic) NSMutableArray *sortedArray;//数组，元素还是数组，排序按照OrderCode
//UI
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *detailScrollView;
@property (strong, nonatomic) MYDItemDetailView *itemDetailView;
@end

@implementation MYDWritingIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
}

- (void)initDataSource
{
    self.catalogsArray = [[MYDDBManager getInstant] readWritingCatalogs];
    self.writingArray = [[MYDDBManager getInstant] readWritings];
    
    self.sortedDic = [NSMutableDictionary dictionary];
    self.sortedCatalogIdArray = [NSMutableArray array];
    self.sortedArray = [NSMutableArray array];
    //    数据处理
    //按照orderCode顺序将catalogId和对应的数组加入字典
    for (int i = 0; i < self.catalogsArray.count; i++) {
        for (NSDictionary *dic  in self.catalogsArray) {
            if ([[dic objectForKey:@"OrderCode"] intValue] - 1 == i) {
                [self.sortedCatalogIdArray addObject:[dic objectForKey:@"Id"]];
            }
        }
    }
    
    for (int i = 0; i < self.sortedCatalogIdArray.count; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dic in self.writingArray) {
            if ([[dic objectForKey:@"CatalogId"] isEqualToString:self.sortedCatalogIdArray[i]]) {
                [tempArr addObject:dic];
            }
        }
        [self.sortedDic setValue:tempArr forKey:self.sortedCatalogIdArray[i]];
        [self.sortedArray addObject:tempArr];
    }
    
    //
    //    for (NSDictionary *dic in self.writingArray) {
    //        if ([[dic objectForKey:@"CatalogId"] isEqualToString:catalogId]) {
    //            cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKey:@"TitlePictureFileName"]];
    //            cell.textLabel.text = [dic objectForKey:@"Name"];
    //        }
    //    }
    
}

- (void)setSubviews
{
    //    //初始化navigationController
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    //    navigationController.navigationBarHidden = YES;
    
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
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 598);
    self.scrollView.contentSize = CGSizeMake(874 * self.catalogsArray.count, 598);
    self.scrollView.tag = kMainScrollView;
    
    //添加列表
    
    for (NSDictionary *dic in self.catalogsArray) {
        int i = [[dic objectForKey:@"OrderCode"] intValue] - 1;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 598)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
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
    
    return ((NSMutableArray *)self.sortedArray[tableView.tag]).count;
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
    
    
    
    
    
    
    //    //取出该tableView对应的catalogId
    //    NSString *catalogId;
    //    for (NSDictionary *dic  in self.catalogsArray) {
    //        if ([[dic objectForKey:@"OrderCode"] intValue] - 1 == tableView.tag) {
    //            catalogId = [dic objectForKey:@"Id"];
    //        }
    //    }
    //
    //    for (NSDictionary *dic in self.writingArray) {
    //        if ([[dic objectForKey:@"CatalogId"] isEqualToString:catalogId]) {
    //            cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKey:@"TitlePictureFileName"]];
    //            cell.textLabel.text = [dic objectForKey:@"Name"];
    //        }
    //    }
    
    NSMutableArray *tempArr = self.sortedArray[tableView.tag];
    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[tempArr[indexPath.row] objectForKey:@"TitlePictureFileName"]];
    cell.textLabel.text = [tempArr[indexPath.row] objectForKey:@"Title"];
    //
    //
    //    cell.textLabel.text = [dic objectForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempArr = self.sortedArray[tableView.tag];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[tempArr[indexPath.row] objectForKey:@"TitlePictureFileName"]];
    self.itemDetailView = [[MYDItemDetailView alloc] initWithImage:image Title:[tempArr[indexPath.row] objectForKey:@"Name"] Price:[tempArr[indexPath.row] objectForKey:@"Price"] Description:[tempArr[indexPath.row] objectForKey:@"Description"]];
    self.itemDetailView.frame = CGRectOffset(self.itemDetailView.frame, 0, 60);
    [self.view addSubview:self.itemDetailView];
    
}

#pragma mark - UITabBar
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self.view.subviews containsObject:self.itemDetailView]) {
        [self.itemDetailView removeFromSuperview];
        self.itemDetailView = nil;
    }
    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    // 根据scorllView的contentOffset属性，判断当前所在的页数
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 设置TabBar
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
    
}

@end
