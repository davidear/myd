//
//  MYDProjectIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDProjectIntroduceViewController.h"

#import "MYDDBManager.h"
#import "SDImageCache.h"
#import "MYDScrollView.h"
#import "MYDCell1.h"
#import "MYDUIConstant.h"

#define kMainScrollView 100
#define kDetailScrollView 200
@interface MYDProjectIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate>

//DATA
@property (strong, nonatomic) NSArray *catalogsArray;
@property (strong, nonatomic) NSArray *projectArray;

//整理后的数据字典
@property (strong, nonatomic) NSMutableArray *sortedCatalogIdArray;
@property (strong, nonatomic) NSMutableDictionary *sortedDic;
@property (strong, nonatomic) NSMutableArray *sortedArray;//数组，元素还是数组，排序按照OrderCode
@property (strong, nonatomic) NSMutableArray *sortedAllArray;//数组，元素是materialEntity的字典，按照sortedArray的次序排列

//UI
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;
//滑动图
@property (strong, nonatomic) MYDScrollView *detailScrollView;
@property (strong, nonatomic) MYDScrollDoneBlock scrollDoneBlock;
@end

@implementation MYDProjectIntroduceViewController

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
    self.catalogsArray = [[MYDDBManager getInstant] readProjectCatalogs];
    self.projectArray = [[MYDDBManager getInstant] readProjects];
    //整理序列,从小到大orderCode
    self.catalogsArray = [self.catalogsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
    for (NSDictionary *dic  in self.catalogsArray) {
        [self.sortedCatalogIdArray addObject:[dic objectForKey:@"Id"]];
    }
    
    for (int i = 0; i < self.sortedCatalogIdArray.count; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dic in self.projectArray) {
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
    __block MYDProjectIntroduceViewController *blockVC = self;
    self.scrollDoneBlock = ^(NSInteger index){
        NSDictionary *dic = blockVC.sortedAllArray[index];
        for (int i = 0; i < blockVC.sortedCatalogIdArray.count; i++) {
            if ([[dic objectForKey:@"CatalogId"] isEqualToString:blockVC.sortedCatalogIdArray[i]]) {
                blockVC.tabBar.selectedItem = blockVC.tabBar.items[i];
            }
        }
    };
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
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"Name"] image:[UIImage imageNamed:@"all_icon_3.png"] selectedImage:nil];
        item.tag = i;
        [array addObject:item];
    }
    self.tabBar.items = array;
    self.tabBar.selectedItem = array[0];
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 598);
    self.scrollView.contentSize = CGSizeMake(874 * self.catalogsArray.count, 598);
    
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
        cell = [[MYDCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        cell.textLabel.font = kFont_Normal;
    }
    NSMutableArray *tempArr = self.sortedArray[tableView.tag];
    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[tempArr[indexPath.row] objectForKey:@"TitlePictureFileName"]];
    cell.textLabel.text = [tempArr[indexPath.row] objectForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.sortedArray[tableView.tag] objectAtIndex:indexPath.row];
    NSInteger index = [self.sortedAllArray indexOfObject:dic];
    self.detailScrollView = [[MYDScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 598) index:index];
    [self.view addSubview:self.detailScrollView];
    self.detailScrollView.scrollDoneBlock = self.scrollDoneBlock;
    self.detailScrollView.detailDataList = self.sortedAllArray;
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
