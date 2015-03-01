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
#import "MYDScrollView.h"
#import "MYDCell1.h"
#import "MYDUIConstant.h"
#define kTableViewForProject 10
#define kTableViewForMaterial 20

@interface MYDPriceIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate>
//DATA
@property (strong, nonatomic) NSArray *catalogsArray;
@property (strong, nonatomic) NSArray *projectArray;
@property (strong, nonatomic) NSArray *materialArray;
//@property (strong, nonatomic) NSArray *priceArray;//包含project和material所有，按照catalogs排序
//整理后的数据字典
@property (strong, nonatomic) NSMutableArray *sortedCatalogIdArray;
@property (strong, nonatomic) NSMutableDictionary *sortedDic;
@property (strong, nonatomic) NSMutableArray *sortedArray;//数组，元素还是数组,对应是每个tableView的数据源,排序按照OrderCode
@property (strong, nonatomic) NSMutableArray *sortedAllArray;//数组，元素是materialEntity的字典，按照sortedArray的次序排列

//UI
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;
//滑动图
@property (strong, nonatomic) MYDScrollView *detailScrollView;
@property (strong, nonatomic) MYDScrollDoneBlock scrollDoneBlock;
@end

@implementation MYDPriceIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubviews];
    [self initBlocks];
}

- (void)initDataSource
{
    self.catalogsArray = @[@{@"Name":@"项目"},@{@"Name":@"产品"}];
    self.projectArray = [[MYDDBManager getInstant] readProjects];
    self.materialArray = [[MYDDBManager getInstant] readMaterials];
    
    self.materialArray = [self.materialArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[NSNumber numberWithInt:[[obj1 objectForKey:@"OrderCode"] intValue]] compare:[NSNumber numberWithInt:[[obj2 objectForKey:@"OrderCode"] intValue]]];
    }];
    self.projectArray = [self.projectArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[NSNumber numberWithInt:[[obj1 objectForKey:@"OrderCode"] intValue]] compare:[NSNumber numberWithInt:[[obj2 objectForKey:@"OrderCode"] intValue]]];
    }];
    
    self.sortedDic = [NSMutableDictionary dictionary];
    self.sortedCatalogIdArray = [NSMutableArray array];
    self.sortedArray = [NSMutableArray array];
    self.sortedAllArray = [NSMutableArray array];
    //    数据处理
    //按照orderCode顺序将catalogId和对应的数组加入字典
    
//    for (NSDictionary *dic  in self.catalogsArray) {
//        [self.sortedCatalogIdArray addObject:[dic objectForKey:@"Id"]];
//    }
    
    [self.sortedDic setValue:self.projectArray forKey:@"项目"];
    [self.sortedDic setValue:self.materialArray forKey:@"产品"];
    [self.sortedArray addObject:self.projectArray];
    [self.sortedArray addObject:self.materialArray];
    [self.sortedAllArray addObjectsFromArray:self.projectArray];
    [self.sortedAllArray addObjectsFromArray:self.materialArray];
//    for (int i = 0; i < self.sortedCatalogIdArray.count; i++) {
//        NSMutableArray *tempArr = [NSMutableArray array];
//        for (NSDictionary *dic in self.materialArray) {
//            if ([[dic objectForKey:@"CatalogId"] isEqualToString:self.sortedCatalogIdArray[i]]) {
//                [tempArr addObject:dic];
//                [self.sortedAllArray addObject:dic];
//            }
//        }
//        [self.sortedDic setValue:tempArr forKey:self.sortedCatalogIdArray[i]];
//        [self.sortedArray addObject:tempArr];
//    }
}
#pragma mark -
- (void)initBlocks
{
    __block MYDPriceIntroduceViewController *blockVC = self;
    self.scrollDoneBlock = ^(NSInteger index){
//        NSDictionary *dic = blockVC.sortedAllArray[index];
//        for (int i = 0; i < blockVC.sortedCatalogIdArray.count; i++) {
//            if ([[dic objectForKey:@"CatalogId"] isEqualToString:blockVC.sortedCatalogIdArray[i]]) {
//                blockVC.tabBar.selectedItem = blockVC.tabBar.items[i];
//            }
//        }
        if (index >= blockVC.projectArray.count) {
            blockVC.tabBar.selectedItem = blockVC.tabBar.items[1];
        }else {
            blockVC.tabBar.selectedItem = blockVC.tabBar.items[0];
        }
    };
}
- (void)setSubviews
{
    //个性化父类组件
    self.tabBar.frame = CGRectMake(0, 0, 120 * self.catalogsArray.count, 60);
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
    
    //添加列表
//    for (NSDictionary *dic in self.catalogsArray) {
    for (int i = 0; i < self.catalogsArray.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 598)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
    }
//        int i = [[dic objectForKey:@"OrderCode"] intValue] - 1;
//    for (int i =0; i < self.catalogsArray.count; i++) {
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(874 * i, 0, 874, 598)];
//        if ([[self.catalogsArray[i] objectForKey:@"Name"] isEqualToString:@"项目"]) {
//            tableView.tag = kTableViewForProject;
//        }else{
//            tableView.tag = kTableViewForMaterial;
//        }
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        if (i == 0) {
////            tableView.backgroundColor = [UIColor blueColor];
//        }else{
////            tableView.backgroundColor = [UIColor greenColor];
//        }
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.scrollView addSubview:tableView];
//    }
    
//    //初始化详情scrollView
//    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598)];
//    self.detailScrollView.delegate = self;
//    self.detailScrollView.contentSize = CGSizeMake(874 * 3, 598);
//    self.detailScrollView.delegate = self;
//    self.detailScrollView.pagingEnabled = YES;
//    self.detailScrollView.showsHorizontalScrollIndicator = NO;
//    self.detailScrollView.showsVerticalScrollIndicator = NO;
//    self.detailScrollView.tag = kDetailScrollView;
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
    MYDCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[MYDCell1 alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCell"];
        cell.textLabel.font = kFont_Normal;
    }
    NSMutableArray *tempArr = self.sortedArray[tableView.tag];
    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[tempArr[indexPath.row] objectForKey:@"TitlePictureFileName"]];
    cell.textLabel.text = [tempArr[indexPath.row] objectForKey:@"Name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RMB：%@",[tempArr[indexPath.row] objectForKey:@"Price"]];
    cell.descriptionLabel.text = [tempArr[indexPath.row] objectForKey:@"Description"];
    return cell;
//    switch (tableView.tag) {
//        case kTableViewForProject:
//        {
//            NSDictionary *dic = [self.projectArray objectAtIndex:indexPath.row];
//            NSString *str = [dic objectForKey:@"TitlePictureFileName"];
////            [self.projectArray[indexPath.row] objectForKey:@"TitlePictureFileName"]
//            cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:str];
//            cell.textLabel.text = [self.projectArray[indexPath.row] objectForKey:@"Name"];
//        }
//            break;
//        case kTableViewForMaterial:
//             cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.materialArray[indexPath.row] objectForKey:@"TitlePictureFileName"]];
//            cell.textLabel.text = [self.materialArray[indexPath.row] objectForKey:@"Name"];
//            break;
//        default:
//            break;
//    }
    

//    cell.textLabel.text = [dic objectForKey:@"Name"];
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.sortedArray[tableView.tag] objectAtIndex:indexPath.row];
    NSInteger index = [self.sortedAllArray indexOfObject:dic];
    self.detailScrollView = [[MYDScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598) index:index];
    [self.view addSubview:self.detailScrollView];
    self.detailScrollView.scrollDoneBlock = self.scrollDoneBlock;
    self.detailScrollView.detailDataList = self.sortedAllArray;
//    switch (tableView.tag) {
//        case kTableViewForProject:
//        {
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.projectArray[indexPath.row] objectForKey:@"TitlePictureFileName"]];
//            self.itemDetailView = [[MYDItemDetailView alloc] initWithImage:image Title:[self.projectArray[indexPath.row] objectForKey:@"Name"] Price:[self.projectArray[indexPath.row] objectForKey:@"Price"] Description:[self.projectArray[indexPath.row] objectForKey:@"Description"]];
//            [self.itemDetailView.imageButton setImage:image forState:UIControlStateNormal];
//            self.itemDetailView.titleLabel.text = [self.projectArray[indexPath.row] objectForKey:@"Name"];
//            self.itemDetailView.descriptionTextView.text = [self.projectArray[indexPath.row] objectForKey:@"Description"];
//            self.itemDetailView.frame = CGRectOffset(self.itemDetailView.frame, 0, 60);
//            [self.view addSubview:self.itemDetailView];
//            
////            UIView * abc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 876, 678)];
////            abc.backgroundColor = [UIColor greenColor];
////            [self.view addSubview:abc];
//        }
//            break;
//        case kTableViewForMaterial:
//        {
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.materialArray[indexPath.row] objectForKey:@"TitlePictureFileName"]];
//            self.itemDetailView = [[MYDItemDetailView alloc] initWithImage:image Title:[self.materialArray[indexPath.row] objectForKey:@"Name"] Price:[self.materialArray[indexPath.row] objectForKey:@"Price"] Description:[self.materialArray[indexPath.row] objectForKey:@"Description"]];
//            self.itemDetailView.frame = CGRectOffset(self.itemDetailView.frame, 0, 60);
//            [self.view addSubview:self.itemDetailView];
//        }
//            break;
//        default:
//            break;
//    }

//    switch (tableView.tag) {
//        case kTableViewForProject:
//        {
//            if (indexPath.row != 0 & indexPath.row != self.projectArray.count - 1) {
//                for (int i = indexPath.row - 1; i<= indexPath.row + 1; i++) {
//                    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.projectArray[i] objectForKey:@"TitlePictureFileName"]];
//                    MYDItemDetailView *view = [[MYDItemDetailView alloc] initWithImage:image Title:[self.projectArray[i] objectForKey:@"Name"] Price:[self.projectArray[i] objectForKey:@"Price"] Description:[self.projectArray[i] objectForKey:@"Description"]];
//                    view.frame = CGRectOffset(view.frame, (i - indexPath.row) * 874, 0);
//                    [self.detailScrollView addSubview:view];
//                }
//            }else if(indexPath.row == 0) {
//                for (int i = 0; i<= indexPath.row + 1; i++) {
//                    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.projectArray[i] objectForKey:@"TitlePictureFileName"]];
//                    MYDItemDetailView *view = [[MYDItemDetailView alloc] initWithImage:image Title:[self.projectArray[i] objectForKey:@"Name"] Price:[self.projectArray[i] objectForKey:@"Price"] Description:[self.projectArray[i] objectForKey:@"Description"]];
//                    view.frame = CGRectOffset(view.frame, (i - indexPath.row) * 874, 0);
//                    [self.detailScrollView addSubview:view];
//                    self.detailScrollView.contentSize = CGSizeMake(874 * 2, 678);
//                }
//            }else if(indexPath.row == self.projectArray.count -1) {
//                for (int i = indexPath.row - 1; i<= indexPath.row; i++) {
//                    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.projectArray[i] objectForKey:@"TitlePictureFileName"]];
//                    MYDItemDetailView *view = [[MYDItemDetailView alloc] initWithImage:image Title:[self.projectArray[i] objectForKey:@"Name"] Price:[self.projectArray[i] objectForKey:@"Price"] Description:[self.projectArray[i] objectForKey:@"Description"]];
//                    view.frame = CGRectOffset(view.frame, (i - indexPath.row) * 874, 0);
//                    [self.detailScrollView addSubview:view];
//                    self.detailScrollView.contentSize = CGSizeMake(874 * 2, 678);
//                }
//            }
//        }
//            break;
//        case kTableViewForMaterial:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
//    
//    [self.view addSubview:self.detailScrollView];
}

#pragma mark - UITabBar
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self.view.subviews containsObject:self.detailScrollView]) {
        [self.detailScrollView removeFromSuperview];
        self.detailScrollView = nil;
    }
    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//    if ([self.view.subviews containsObject:self.itemDetailView]) {
//        [self.itemDetailView removeFromSuperview];
//        self.itemDetailView = nil;
//    }
//    CGFloat offsetX = item.tag * self.scrollView.bounds.size.width;
//    
//    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据scorllView的contentOffset属性，判断当前所在的页数
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 设置TabBar
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
//    switch (scrollView.tag) {
//        case kMainScrollView:
//        {
//            // 根据scorllView的contentOffset属性，判断当前所在的页数
//            NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
//            
//            // 设置TabBar
//            self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
//        }
//            break;
//        case kDetailScrollView:
//        {
//
//            
//        }
//        default:
//            break;
//    }

}

@end
