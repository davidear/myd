//
//  MYDScrollView.m
//  MeiYiDian
//
//  Created by dfy on 15/1/27.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDScrollView.h"
#import "MYDItemDetailView.h"
#import "SDImageCache.h"
@interface MYDScrollView ()
// 记录图像数量
@property (assign, nonatomic) NSInteger imageCount;

//记录最初展示的序号
@property (assign, nonatomic) NSInteger index;
// 保存滚动视图显示内容的图像视图数组，数组中一共有三张图片
@property (strong, nonatomic) NSArray *itemDetailViewList;


@end
@implementation MYDScrollView
-(void)setDetailDataList:(NSMutableArray *)detailDataList
{
    _detailDataList = detailDataList;
    
    NSLog(@"%@", _detailDataList);
    
    self.imageCount = detailDataList.count;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    [self.scrollView setContentSize:CGSizeMake((self.imageCount + 2) * width, height)];
    [self setScrollContentWithPage:self.index];
}

#pragma mark 实例化控件
- (id)initWithFrame:(CGRect)frame index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = index;
        // 把原有的loadView中的大部分代码复制到此处
        // 2. 实例化滚动视图
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:scroll];
        self.scrollView = scroll;
        
        // 4. 创建图像视图的数组
        NSMutableArray *itemDetailViewList = [NSMutableArray arrayWithCapacity:3];
        for (NSInteger i = 0; i < 3; i++) {
//            // 注意：全屏子控件的大小，要与其父控件的大小相一致，这样便于移植
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:scroll.bounds];
//            
//            [itemDetailViewList addObject:imageView];
//            // 将三张图像视图添加到scrollView上，后续直接设置位置即可
//            [scroll addSubview:imageView];
            
            
//            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.detailDataList[index] objectForKey:@"TitlePictureFileName"]];
//            MYDItemDetailView *itemDetailView = [[MYDItemDetailView alloc] initWithImage:image Title:[self.detailDataList[index] objectForKey:@"Name"] Price:[self.detailDataList[index] objectForKey:@"Price"] Description:[self.detailDataList[index] objectForKey:@"Description"]];
            MYDItemDetailView *itemDetailView = [[MYDItemDetailView alloc] init];
            
            itemDetailView.frame = scroll.bounds;
            [itemDetailViewList addObject:itemDetailView];
            [scroll addSubview:itemDetailView];

        }
        self.itemDetailViewList = itemDetailViewList;
        
        // 5. 设置滚动视图的属性
        // 1) 设置滚动区域
        CGFloat width = scroll.bounds.size.width;
        
        // 2) 取消弹簧
        [scroll setBounces:NO];
        // 3) 取消水平滚动
        [scroll setShowsHorizontalScrollIndicator:NO];
        // 4) 设置代理
        [scroll setDelegate:self];
        // 5) 设置允许分页
        [scroll setPagingEnabled:YES];
        // 6) 设置偏移位置
        [scroll setContentOffset:CGPointMake(width * (index + 1), 0)];
        
        // 7) 设置当前显示的内容
        // 在一个独立的位置测试，也便于讲解，写一个单独的方法
        // 因为在自定义视图中，将图像名数组抽取之后，以下方法在执行时，
        // 图像名数组尚未被初始化，因此不能在此调用设置滚动图像的操作
    }
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    return self;
}

#pragma mark - 根据页号，设置滚动视图显示内容
// 参数page是从0开始的
- (void)setScrollContentWithPage:(NSInteger)page
{
    //    block
    self.scrollDoneBlock(page);
    
    // 需要page-1 page page+1 三个页面
    // 如果是0：99 0 1
    // 如果是1: 0 1 2
    // 如果是99：98 99 0
    // 需要注意的时第一张图片中为了避免出现负数，可以先与图片总数相加再去模处理
    NSLog(@"%d %d %d", (page + self.imageCount - 1) % self.imageCount, page, (page + 1) % self.imageCount);
    
    // 知道对应的图片文件名的数组下标，可以直接设置imageView数组中的图像
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height = self.scrollView.bounds.size.height;
    
    NSInteger startI = (page + self.imageCount - 1) % self.imageCount;
    for (NSInteger i = 0; i < 3; i++) {
        NSDictionary *dic = self.detailDataList[(startI + i) % self.imageCount];
        
//        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[dic objectForKey:@"TitlePictureFileName"]];
        // 取出图像视图数组中的图像视图
        MYDItemDetailView *itemDetailView = self.itemDetailViewList[i];
//        itemDetailView.delegate = self;
        [itemDetailView reloadDataWithImage:image PictureEntityDic:dic];
        // 设置图像
//        [imageView setImage:image];
        
        // 挪动位置，需要连续设置三张图片的位置
        // 至于图片的内容，可以不用去管了
        // 因为多了两张缓存的页面，因此page=0时，数组中的第0张图片应该显示在1的位置
        [itemDetailView setFrame:CGRectMake((page + i) * width, 0, width, height)];
    }
}

#pragma mark - 滚动视图代理方法
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 1. 计算页号
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 2. 对特殊页号进行处理
    // 2.1 第0页，对应最后一页
    // 2.2 第kImageCount + 1页，对应第0页
    BOOL needAdjust = NO;
    if (0 == pageNo || (self.imageCount + 1) == pageNo) {
        if (0 == pageNo) {
            pageNo = self.imageCount;
        } else {
            pageNo = 1;
        }
        
        // 设置偏移
        needAdjust = YES;
    }
    
    // 注意：其他页面同样需要处理，因为，图片缓存数组中只有三张图片
    // 因此，每次滚动完成之后，都需要做设置页面图像的工作
    [self setScrollContentWithPage:(pageNo - 1)];
    
    // 如果是第一页和最后一页的缓存页面上，需要挪动位置
    if (needAdjust) {
        [scrollView setContentOffset:CGPointMake(pageNo * scrollView.bounds.size.width, 0)];
    }



}
//#pragma MYDItemDetailViewDelegate
//- (void)imageButtonAction:(MYDPictureScrollViewController *)VC
//{
//    [self.delegate itemDetailImageButtonAction:VC];
//}
@end
