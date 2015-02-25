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
//#import "MYDItemDetailView.h"
#import "MYDScrollView.h"
#import "MYDUIConstant.h"
#import "MYDCollectionViewCell2.h"
#import "MYDConstants.h"

@interface MYDWritingIntroduceViewController()<UICollectionViewDelegate,UICollectionViewDataSource>


//DATA
@property (strong, nonatomic) NSArray *catalogsArray;
@property (strong, nonatomic) NSArray *writingArray;

//整理后的数据字典
@property (strong, nonatomic) NSMutableArray *sortedCatalogIdArray;
@property (strong, nonatomic) NSMutableDictionary *sortedDic;
@property (strong, nonatomic) NSMutableArray *sortedArray;//数组，元素还是数组，排序按照OrderCode
@property (strong, nonatomic) NSMutableArray *sortedAllArray;//数组，元素是materialEntity的字典，按照sortedArray的次序排列
//UI
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollView;
//滑动图
@property (strong, nonatomic) MYDScrollView *detailScrollView;
@property (strong, nonatomic) MYDScrollDoneBlock scrollDoneBlock;
@end

@implementation MYDWritingIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
    [self initBlocks];
}
#pragma mark 继承父类方法
- (void)initSubviews
{
    [super initSubviews];
}
- (void)initDataSource
{
    [super initDataSource];
    self.catalogsArray = [[MYDDBManager getInstant] readWritingCatalogs];
    self.writingArray = [[MYDDBManager getInstant] readWritings];
    //整理序列,从小到大orderCode
    self.catalogsArray = [self.catalogsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[NSNumber numberWithInt:[[obj1 objectForKey:@"OrderCode"] intValue]] compare:[NSNumber numberWithInt:[[obj2 objectForKey:@"OrderCode"] intValue]]];
    }];
    self.writingArray = [self.writingArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[NSNumber numberWithInt:[[obj1 objectForKey:@"OrderCode"] intValue]] compare:[NSNumber numberWithInt:[[obj2 objectForKey:@"OrderCode"] intValue]]];
    }];
    
    self.sortedDic = [NSMutableDictionary dictionary];
    self.sortedCatalogIdArray = [NSMutableArray array];
    self.sortedArray = [NSMutableArray array];
    self.sortedAllArray = [NSMutableArray array];
    //    数据处理
    //按照orderCode顺序将catalogId和对应的数组加入字典
    for (NSDictionary *dic  in self.catalogsArray) {
        [self.sortedCatalogIdArray addObject:[dic objectForKey:@"Id"]];
    }
    
    for (int i = 0; i < self.sortedCatalogIdArray.count; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dic in self.writingArray) {
            if ([[dic objectForKey:@"CatalogId"] isEqualToString:self.sortedCatalogIdArray[i]]) {
                [tempArr addObject:dic];
                [self.sortedAllArray addObject:dic];
            }
        }
        [self.sortedDic setValue:tempArr forKey:self.sortedCatalogIdArray[i]];
        [self.sortedArray addObject:tempArr];
    }
    
}
#pragma mark -
- (void)initBlocks
{
    __block MYDWritingIntroduceViewController *blockVC = self;
    self.scrollDoneBlock = ^(NSInteger index){
        NSDictionary *dic = blockVC.sortedAllArray[index];
        for (int i = 0; i < blockVC.sortedCatalogIdArray.count; i++) {
            if ([[dic objectForKey:@"CatalogId"] isEqualToString:blockVC.sortedCatalogIdArray[i]]) {
                blockVC.tabBar.selectedItem = blockVC.tabBar.items[i];
            }
        }
    };
}
//- (void)initDataSource
//{
//    [super initDataSource];
//    self.catalogsArray = [[MYDDBManager getInstant] readWritingCatalogs];
//    self.writingArray = [[MYDDBManager getInstant] readWritings];
//    
//    self.sortedDic = [NSMutableDictionary dictionary];
//    self.sortedCatalogIdArray = [NSMutableArray array];
//    self.sortedArray = [NSMutableArray array];
//    //    数据处理
//    //按照orderCode顺序将catalogId和对应的数组加入字典
//    for (int i = 0; i < self.catalogsArray.count; i++) {
//        for (NSDictionary *dic  in self.catalogsArray) {
//            if ([[dic objectForKey:@"OrderCode"] intValue] - 1 == i) {
//                [self.sortedCatalogIdArray addObject:[dic objectForKey:@"Id"]];
//            }
//        }
//    }
//    
//    for (int i = 0; i < self.sortedCatalogIdArray.count; i++) {
//        NSMutableArray *tempArr = [NSMutableArray array];
//        for (NSDictionary *dic in self.writingArray) {
//            if ([[dic objectForKey:@"CatalogId"] isEqualToString:self.sortedCatalogIdArray[i]]) {
//                [tempArr addObject:dic];
//            }
//        }
//        [self.sortedDic setValue:tempArr forKey:self.sortedCatalogIdArray[i]];
//        [self.sortedArray addObject:tempArr];
//    }
//    
//    //
//    //    for (NSDictionary *dic in self.writingArray) {
//    //        if ([[dic objectForKey:@"CatalogId"] isEqualToString:catalogId]) {
//    //            cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKey:@"TitlePictureFileName"]];
//    //            cell.textLabel.text = [dic objectForKey:@"Name"];
//    //        }
//    //    }
//    
//}

- (void)setSubviews
{
    //    //初始化navigationController
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    //    navigationController.navigationBarHidden = YES;
    
    //个性化父类组件
    self.tabBar.frame = CGRectMake(0, 0, 100 * self.catalogsArray.count, 60);
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
    
//    //添加列表
//    
//    for (NSDictionary *dic in self.catalogsArray) {
//        int i = [[dic objectForKey:@"OrderCode"] intValue] - 1;
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 598)];
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.tag = i;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.scrollView addSubview:tableView];
//    }
    //添加列表
    
    for (NSDictionary *dic in self.catalogsArray) {
        int i = [[dic objectForKey:@"OrderCode"] intValue] - 1;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(250, 280);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(874 * i + 30, 0 + 10, 874 - 60, 598 - 20) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.tag = i;
        [collectionView registerNib:[UINib nibWithNibName:@"MYDCollectionViewCell2" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionView"];
        [self.scrollView addSubview:collectionView];
    }
}
#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSMutableArray *)self.sortedArray[collectionView.tag]).count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYDCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionView" forIndexPath:indexPath];
    NSMutableArray *tempArr = self.sortedArray[collectionView.tag];
    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[tempArr[indexPath.row] objectForKey:@"TitlePictureFileName"]];
    cell.label.text = [tempArr[indexPath.row] objectForKey:@"Title"];
    cell.label.font = kFont_Small;
    cell.label.textColor = kColorForOrangeRed;
    //    cell.label.text = [NSString stringWithFormat:@"index %d",collectionView.tag];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //之前有一个详情页面
//    NSDictionary *dic = [self.sortedArray[collectionView.tag] objectAtIndex:indexPath.row];
//    NSInteger index = [self.sortedAllArray indexOfObject:dic];
//    self.detailScrollView = [[MYDScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598) index:index];
//    [self.view addSubview:self.detailScrollView];
//    self.detailScrollView.scrollDoneBlock = self.scrollDoneBlock;
    self.detailScrollView.detailDataList = self.sortedAllArray;
    //详情页面完毕
    
    //直接跳转到图片展示页面
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *array = [[MYDDBManager getInstant] readMaterialPictures];
    [array addObjectsFromArray:[[MYDDBManager getInstant] readProjectPictures]];
    [array addObjectsFromArray:[[MYDDBManager getInstant] readWritingPictures]];
    if (array == nil) {
        return;
    }
    for (NSDictionary *dic in array) {
        if ([[self.sortedAllArray[indexPath.row] objectForKey:@"Id"] isEqualToString:[dic objectForKey:@"FKId"]]) {
            [tempArr addObject:[dic objectForKey:@"FileName"]];
        }
    }
    if (tempArr.count == 0) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForImageButtonAction object:tempArr];
    //直接跳转到图片展示页面
}


//#pragma mark - UITableView
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 200;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return ((NSMutableArray *)self.sortedArray[tableView.tag]).count;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
//        cell.textLabel.font = kFont_Normal;
//    }
//    //    NSDictionary *dic = self.materialdataArray[indexPath.row];
//    
//    
//    
//    
//    
//    
//    //    //取出该tableView对应的catalogId
//    //    NSString *catalogId;
//    //    for (NSDictionary *dic  in self.catalogsArray) {
//    //        if ([[dic objectForKey:@"OrderCode"] intValue] - 1 == tableView.tag) {
//    //            catalogId = [dic objectForKey:@"Id"];
//    //        }
//    //    }
//    //
//    //    for (NSDictionary *dic in self.writingArray) {
//    //        if ([[dic objectForKey:@"CatalogId"] isEqualToString:catalogId]) {
//    //            cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKey:@"TitlePictureFileName"]];
//    //            cell.textLabel.text = [dic objectForKey:@"Name"];
//    //        }
//    //    }
//    
//    NSMutableArray *tempArr = self.sortedArray[tableView.tag];
//    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[tempArr[indexPath.row] objectForKey:@"TitlePictureFileName"]];
//    cell.textLabel.text = [tempArr[indexPath.row] objectForKey:@"Title"];
//    //
//    //
//    //    cell.textLabel.text = [dic objectForKey:@"Name"];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dic = [self.sortedArray[tableView.tag] objectAtIndex:indexPath.row];
//    NSInteger index = [self.sortedAllArray indexOfObject:dic];
//    self.detailScrollView = [[MYDScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598) index:index];
//    [self.view addSubview:self.detailScrollView];
//    self.detailScrollView.scrollDoneBlock = self.scrollDoneBlock;
//    self.detailScrollView.detailDataList = self.sortedAllArray;
//}


#pragma mark - UITabBar
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self.view.subviews containsObject:self.detailScrollView]) {
        [self.detailScrollView removeFromSuperview];
        self.detailScrollView = nil;
    }
    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    if ([self.view.subviews containsObject:self.itemDetailView]) {
//        [self.itemDetailView removeFromSuperview];
//        self.itemDetailView = nil;
//    }
//    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
//    
//    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//    
//}
#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        // 根据scorllView的contentOffset属性，判断当前所在的页数
        NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
        
        // 设置TabBar
        self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
    }
    
}

@end
