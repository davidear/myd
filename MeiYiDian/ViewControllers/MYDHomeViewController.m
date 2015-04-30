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
#import "MYDUIConstant.h"
#import "MYDConstants.h"
#define kTagForhorizontalScrollView 10
@interface MYDHomeViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
//UI
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
//@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *annoucementButton;
@property (strong, nonatomic) IBOutlet UIButton *customerInfo;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imageButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *textButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *departmentNameLabels;

//DATA
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *imagesArray;

@end

@implementation MYDHomeViewController
{
    NSUInteger      _imageIndex;    // 图片序号
    NSTimer *_timer;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        [[MYDMediator getInstant] getDataVersionWithDepartmentId:[[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"] success:^(NSString *responseString) {
            //DataVersion不相同或者 baseData中的DataVersion为0，则发起数据更新
            int oldDataVersion = [[MYDDBManager getInstant] readDataVersionFromBaseData];
            int newDataVersion = [[MYDDBManager getInstant] readDataVersionFromLoginResult];
            
            if (oldDataVersion != newDataVersion | oldDataVersion == 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据版本有更新" message:@"重新登录更新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];
    [self initSubviews];
    [self setSubviews];
    [self initControllers];
    [self creatAD];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 全局定时器，定时切换广告
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(adAutoSliding:) userInfo:nil repeats:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
}
- (void)viewDidAppear:(BOOL)animated
{
//    self.horizontalScrollView.frame = CGRectMake(0, 44, self.horizontalScrollView.frame.size.width, 680);
    [super viewDidAppear:animated];
}

- (void)initControllers
{
    self.navC = [[UINavigationController alloc] initWithRootViewController:[[MYDMainViewController alloc] init]];
    self.navC.navigationBarHidden = YES;
}
- (void)initDataSource
{
    self.dataArray = [[MYDDBManager getInstant] readScrollPictures];
    if (self.dataArray == nil) {
        return;
    }
    self.imagesArray = [NSMutableArray array];
    
    for (NSDictionary *dic in self.dataArray) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKey:@"FileName"]];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        if (image != nil) {
            [self.imagesArray addObject:image];
        }
    }
}

- (void)initSubviews
{
    for (UILabel *label in self.departmentNameLabels) {
        label.text = [NSString stringWithFormat:@"%@欢迎您",[[[[MYDDBManager getInstant] readLoginUser] objectAtIndex:0] objectForKey:@"DepartmentName"]];
    }
}
- (void)setSubviews
{
    //设置圆角
    self.annoucementButton.layer.cornerRadius = 8;
    self.annoucementButton.layer.borderColor = kColorForBorder;
    self.annoucementButton.layer.borderWidth = 1;
    self.customerInfo.layer.cornerRadius = 12;
    self.customerInfo.layer.borderWidth = 1;
    self.customerInfo.layer.borderColor = kColorForBorder;
    for (UIButton *btn in self.textButtons) {
        btn.layer.cornerRadius = 8;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = kColorForBorder;
    }
    for (UIButton *btn in self.imageButtons) {
        btn.layer.cornerRadius = 12;
        btn.layer.borderColor = [[UIColor whiteColor] CGColor];
        btn.layer.borderWidth = 10;
        btn.clipsToBounds = YES;
    }
    
    
    //有两个scrollView，所有使用tag标记
    self.horizontalScrollView.tag = kTagForhorizontalScrollView;
    
    ////设置horizontalScrollView
    // 1. 实例化视图
    // 2. 创建滚动视图
    // 3. 初始化数据
    // 将建立好的图像数组添加到scrollView中
    // 1) for (NSInteger idx = 0; idx < 5; idx ++)
    // 2) for (UIImageView obj in array)
//    [self.imageViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        // 1) 从数组取出imageView
//        UIImageView *imageView = obj;
//        // 2) 设置图像视图的frame
//        [imageView setFrame:CGRectMake(idx * self.horizontalScrollView.frame.size.width, 0, self.horizontalScrollView.frame.size.width, self.horizontalScrollView.frame.size.height)];
//        // 3) 将图像视图添加到scrollView
//        [self.horizontalScrollView addSubview:imageView];
//    }];
    
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
    MYDMainViewController *mainVC = (MYDMainViewController *)self.navC.topViewController;
    mainVC.selectedRow = 1;
    [self presentViewController:self.navC animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:[[MYDMainViewController alloc] init] animated:YES];
}
- (IBAction)projectIntroduce:(id)sender {
    MYDMainViewController *mainVC = (MYDMainViewController *)self.navC.topViewController;
    mainVC.selectedRow = 3;
    [self presentViewController:self.navC animated:YES completion:^{
        
    }];
}
- (IBAction)priceIntroduce:(id)sender {
    MYDMainViewController *mainVC = (MYDMainViewController *)self.navC.topViewController;
    mainVC.selectedRow = 2;
    [self presentViewController:self.navC animated:YES completion:^{
        
    }];
}
- (IBAction)materialIntroduce:(id)sender {
    MYDMainViewController *mainVC = (MYDMainViewController *)self.navC.topViewController;
    mainVC.selectedRow = 4;
    [self presentViewController:self.navC animated:YES completion:^{
        
    }];
}
- (IBAction)partyIntroduce:(id)sender {
    MYDMainViewController *mainVC = (MYDMainViewController *)self.navC.topViewController;
    mainVC.selectedRow = 5;
    [self presentViewController:self.navC animated:YES completion:^{
        
    }];
}
- (IBAction)writingIntroduce:(id)sender {
    MYDMainViewController *mainVC = (MYDMainViewController *)self.navC.topViewController;
    mainVC.selectedRow = 6;
    [self presentViewController:self.navC animated:YES completion:^{
        
    }];
}


#pragma mark - 1.2.1、创建广告栏
- (void)creatAD
{
    // 广告栏
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.bounds.size.width * 3, 0);
    self.horizontalScrollView.contentOffset = CGPointMake(self.horizontalScrollView.bounds.size.width, 0);
    
    for (int i = 0; i < 3; i++){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imagesArray[i]];
        imageView.tag = i + 1;
        imageView.userInteractionEnabled = YES;
        imageView.frame = (CGRect){self.horizontalScrollView.bounds.size.width * i, 0, self.horizontalScrollView.frame.size};
        [self.horizontalScrollView addSubview:imageView];
    }
    _imageIndex = 0;
}
#pragma mark 1.2.1.1、广告栏自动滑动
- (void)adAutoSliding:(id)timer
{
    [UIView animateWithDuration:0.5 animations:^{
        self.horizontalScrollView.contentOffset = CGPointMake(self.horizontalScrollView.bounds.size.width * 2.0, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.horizontalScrollView];
    }];
}

//#pragma mark - PageControl
//- (IBAction)pageChanged:(UIPageControl *)sender {
//    NSLog(@"分页了 %d", sender.currentPage);
//    // 根据变化到的页数，计算scrollView的contentOffset
//    CGFloat offsetX = sender.currentPage * self.horizontalScrollView.bounds.size.width;
//    
//    [self.horizontalScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//}
#pragma mark - ScrollView Delegate
#pragma mark 滚动视图减速事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == kTagForhorizontalScrollView) {
        UIImageView *image0 = (UIImageView *)[scrollView viewWithTag:1];
        UIImageView *image1 = (UIImageView *)[scrollView viewWithTag:2];
        UIImageView *image2 = (UIImageView *)[scrollView viewWithTag:3];
        NSUInteger count = self.imagesArray.count;
        if (scrollView.contentOffset.x > self.horizontalScrollView.bounds.size.width * 1.5) {                   // 往后滑动，后推一张图片
            _imageIndex = ++_imageIndex % count;
        } else if (scrollView.contentOffset.x < self.horizontalScrollView.bounds.size.width * 0.5){             // 往前滑动，前推一张图片
            _imageIndex = (_imageIndex + count - 1) % count;
        } else return;
        
        // 更换图片
        image0.image = self.imagesArray[_imageIndex % count];
        image1.image = self.imagesArray[(_imageIndex + 1) % count];
        image2.image = self.imagesArray[(_imageIndex + 2) % count];
        self.horizontalScrollView.contentOffset = CGPointMake(self.horizontalScrollView.bounds.size.width, 0);
    }

}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoginView object:nil];
    }
}
@end
