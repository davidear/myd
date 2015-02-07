//
//  MYDPictureScrollViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/2/4.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDPictureScrollViewController.h"
#import "MPTextReavealLabel.h"
#import "SDImageCache.h"
#import "MYDConstants.h"

static NSString *kCell=@"cell";
@interface MYDPictureScrollViewController ()
@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation MYDPictureScrollViewController
- (id)initWithImageArray:(NSArray *)imageArray
{
    self = [super init];
    if (self) {
        self.imageArray = imageArray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    
    MPParallaxLayout *layout=[[MPParallaxLayout alloc] init];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.pagingEnabled=YES;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [_collectionView registerClass:[MPParallaxCollectionViewCell class] forCellWithReuseIdentifier:kCell];
    [self.view addSubview:_collectionView];
    
}


#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MPParallaxCollectionViewCell* cell =  (MPParallaxCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
//    cell.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li",(long)indexPath.item%5+1]];
//    cell.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[indexPath.row]];
    cell.delegate=self;
    
//    NSString *text;
//    
//    NSInteger index=indexPath.row%5;
//    
//    switch (index) {
//        case 0:
//            text=@"THAT";
//            break;
//        case 1:
//            text=@"LOOKS";
//            break;
//        case 2:
//            text=@"PRETTY";
//            break;
//        case 3:
//            text=@"GOOD";
//            break;
//        case 4:
//            text=@"!!!!!";
//            break;
//        default:
//            break;
//            
//    }
    NSString *text = @"美易点出品的master";
    
    // that shit just to not make dirty MPParallaxCollectionViewCell ... I add that only to demonstrate how to use the percent driven stuff
    if (![cell viewWithTag:3838]) {
        MPTextReavealLabel *label=[[MPTextReavealLabel alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 80, 280, 60)];
        label.tag=3838;
        label.lineWidth=3;
        [cell addSubview:label];
        
    }
    
    MPTextReavealLabel *label=(MPTextReavealLabel *)[cell viewWithTag:3838];
    label.frame=CGRectMake(20, self.view.bounds.size.height - 80, 280, 60);
    label.attributedText=[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-light" size:18]}];
    
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - MPParallaxCollectionView Delegate
- (void)cell:(MPParallaxCollectionViewCell *)cell changeParallaxValueTo:(CGFloat)value{
    
    NSLog(@"%f",value);
    
    MPTextReavealLabel *label=(MPTextReavealLabel *)[cell viewWithTag:3838];
    CGFloat val=1-(value<0 ? -value : value);
    [label drawToValue:val*val];
}


@end
