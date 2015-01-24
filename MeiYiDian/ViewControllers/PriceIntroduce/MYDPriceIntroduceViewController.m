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
#import "MYDItemDetailView.h"
#import "MYDItemDetailViewController.h"
#define kTableViewForProject 10
#define kTableViewForMaterial 20

#define kMainScrollView 100
#define kDetailScrollView 200
@interface MYDPriceIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate>
//DATA
@property (strong, nonatomic) NSArray *catalogsArray;
@property (strong, nonatomic) NSArray *projectArray;
@property (strong, nonatomic) NSArray *materialArray;
//UI
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *detailScrollView;
@property (strong, nonatomic) MYDItemDetailView *itemDetailView;
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
    
    self.scrollView.frame = CGRectMake(0, 60, 874, 618);
    self.scrollView.contentSize = CGSizeMake(874 * self.catalogsArray.count, 618);
    self.scrollView.tag = kMainScrollView;
    
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
        if (i == 0) {
//            tableView.backgroundColor = [UIColor blueColor];
        }else{
//            tableView.backgroundColor = [UIColor greenColor];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
    }
    
//    //初始化详情scrollView
//    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 874, 618)];
//    self.detailScrollView.delegate = self;
//    self.detailScrollView.contentSize = CGSizeMake(874 * 3, 618);
//    self.detailScrollView.delegate = self;
//    self.detailScrollView.pagingEnabled = YES;
//    self.detailScrollView.showsHorizontalScrollIndicator = NO;
//    self.detailScrollView.showsVerticalScrollIndicator = NO;
//    self.detailScrollView.tag = kDetailScrollView;
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case kTableViewForProject: return self.projectArray.count;
        case kTableViewForMaterial: return self.materialArray.count;
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
    switch (tableView.tag) {
        case kTableViewForProject:
        {
            NSDictionary *dic = [self.projectArray objectAtIndex:indexPath.row];
            NSString *str = [dic objectForKey:@"TitlePictureFileName"];
//            [self.projectArray[indexPath.row] objectForKey:@"TitlePictureFileName"]
            cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:str];
            cell.textLabel.text = [self.projectArray[indexPath.row] objectForKey:@"Name"];
        }
            break;
        case kTableViewForMaterial:
             cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.materialArray[indexPath.row] objectForKey:@"TitlePictureFileName"]];
            cell.textLabel.text = [self.materialArray[indexPath.row] objectForKey:@"Name"];
            break;
        default:
            break;
    }
    

//    cell.textLabel.text = [dic objectForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case kTableViewForProject:
        {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.projectArray[indexPath.row] objectForKey:@"TitlePictureFileName"]];
            self.itemDetailView = [[MYDItemDetailView alloc] initWithImage:image Title:[self.projectArray[indexPath.row] objectForKey:@"Name"] Price:[self.projectArray[indexPath.row] objectForKey:@"Price"] Description:[self.projectArray[indexPath.row] objectForKey:@"Description"]];
            [self.itemDetailView.imageButton setImage:image forState:UIControlStateNormal];
            self.itemDetailView.titleLabel.text = [self.projectArray[indexPath.row] objectForKey:@"Name"];
            self.itemDetailView.descriptionTextView.text = [self.projectArray[indexPath.row] objectForKey:@"Description"];
            self.itemDetailView.frame = CGRectOffset(self.itemDetailView.frame, 0, 60);
            [self.view addSubview:self.itemDetailView];
            
//            UIView * abc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 876, 678)];
//            abc.backgroundColor = [UIColor greenColor];
//            [self.view addSubview:abc];
        }
            break;
        case kTableViewForMaterial:
        {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.materialArray[indexPath.row] objectForKey:@"TitlePictureFileName"]];
            self.itemDetailView = [[MYDItemDetailView alloc] initWithImage:image Title:[self.materialArray[indexPath.row] objectForKey:@"Name"] Price:[self.materialArray[indexPath.row] objectForKey:@"Price"] Description:[self.projectArray[indexPath.row] objectForKey:@"Description"]];
            self.itemDetailView.frame = CGRectOffset(self.itemDetailView.frame, 0, 60);
            [self.view addSubview:self.itemDetailView];
        }
            break;
        default:
            break;
    }

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
    
    switch (scrollView.tag) {
        case kMainScrollView:
        {
            // 根据scorllView的contentOffset属性，判断当前所在的页数
            NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
            
            // 设置TabBar
            self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:pageNo];
        }
            break;
        case kDetailScrollView:
        {

            
        }
        default:
            break;
    }

}

@end
