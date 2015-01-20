//
//  MYDHomeViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/16.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDHomeViewController.h"
#import "MYDMainViewController.h"
#import "MYDMediator.h"
#import "MYDDBManager.h"
#import "SDImageCache.h"
#define kTagForhorizontalScrollView 10
@interface MYDHomeViewController ()<UIScrollViewDelegate>
//UI
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
//DATA
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end

@implementation MYDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];
    [self initSubviews];
    [self setSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
//    self.horizontalScrollView.frame = CGRectMake(0, 44, self.horizontalScrollView.frame.size.width, 680);
    [super viewDidAppear:animated];
}

- (void)initDataSource
{
    
    self.dataArray = [[MYDDBManager getInstant] readScrollPictures];
    if (self.dataArray == nil) {
        return;
    }
    self.imageArray = [NSMutableArray array];
    
    for (NSDictionary *dic in self.dataArray) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"FileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:[[[[MYDDBManager getInstant] readLoginUser] lastObject] objectForKey:@"DepartmentId"] typeCode:@"03" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

- (void)initSubviews
{
    
}
- (void)setSubviews
{
    //有两个scrollView，所有使用tag标记
    self.horizontalScrollView.tag = kTagForhorizontalScrollView;
    
    ////设置horizontalScrollView
    // 1. 实例化视图
    // 2. 创建滚动视图
    // 3. 初始化数据
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.dataArray.count];
    for (NSInteger i = 0; i < 5; i++) {
        // 1) 创建图片的文件名
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i + 1];
        // 2) 建立图像视图
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        // 3) 将图像视图添加到数组
        [array addObject:imageView];
    }
    // 将建立好的图像数组添加到scrollView中
    // 1) for (NSInteger idx = 0; idx < 5; idx ++)
    // 2) for (UIImageView obj in array)
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // 1) 从数组取出imageView
        UIImageView *imageView = obj;
        // 2) 设置图像视图的frame
        [imageView setFrame:CGRectMake(idx * self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height)];
        // 3) 将图像视图添加到scrollView
        [self.horizontalScrollView addSubview:imageView];
    }];
    
    // 5. 设置滚动视图属性
    // 1) 允许分页
    // 2) 关闭弹簧效果
    // 3) 关闭水平滚动条
    // 4) 设置滚动区域大小
    [self.horizontalScrollView setContentSize:CGSizeMake(self.horizontalScrollView.bounds.size.width * 5, self.horizontalScrollView.bounds.size.height)];
    // 5) 设置代理
    
    ////设置scrollView
    // 1. 实例化视图
    // 2. 创建滚动视图
    // 5. 设置滚动视图属性
    // 1) 允许分页
    // 2) 关闭弹簧效果
    // 3) 关闭水平滚动条
    // 4) 设置滚动区域大小
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    // 5) 设置代理
    
}
#pragma mark - 界面按钮事件
- (IBAction)enterpriseIntroduce:(id)sender {
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:[[MYDMainViewController alloc] init]];
    navC.navigationBarHidden = YES;
    [self presentViewController:navC animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:[[MYDMainViewController alloc] init] animated:YES];
}
- (IBAction)projectIntroduce:(id)sender {
}
- (IBAction)priceIntroduce:(id)sender {
}
- (IBAction)materialIntroduce:(id)sender {
}
- (IBAction)partyIntroduce:(id)sender {
}
- (IBAction)writingIntroduce:(id)sender {
}


#pragma mark - PageControl
- (IBAction)pageChanged:(UIPageControl *)sender {
    NSLog(@"分页了 %d", sender.currentPage);
    // 根据变化到的页数，计算scrollView的contentOffset
    CGFloat offsetX = sender.currentPage * self.horizontalScrollView.bounds.size.width;
    
    [self.horizontalScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark - ScrollView Delegate
#pragma mark 滚动视图减速事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == kTagForhorizontalScrollView) {
        NSLog(@"页面滚动停止 ");
        // 根据scorllView的contentOffset属性，判断当前所在的页数
        NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
        
        // 设置页码
        [self.pageControl setCurrentPage:pageNo];
    }else {
        
    }

}

@end