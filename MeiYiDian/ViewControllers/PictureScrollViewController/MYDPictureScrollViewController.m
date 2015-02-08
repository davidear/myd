//
//  MYDPictureScrollViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/2/4.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDPictureScrollViewController.h"
//#import "MPTextReavealLabel.h"
#import "SDImageCache.h"
#import "MYDConstants.h"

static NSString *kCell=@"cell";
@interface MYDPictureScrollViewController ()<UIScrollViewDelegate,iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) NSArray *imageArray;
@property (nonatomic, assign) BOOL wrap;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

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
    //configure carousel
    self.carousel.type = iCarouselTypeCoverFlow2;

//    MPParallaxLayout *layout=[[MPParallaxLayout alloc] init];
//    
//    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    _collectionView.delegate=self;
//    _collectionView.dataSource=self;
//    _collectionView.showsHorizontalScrollIndicator=NO;
//    _collectionView.pagingEnabled=YES;
//    _collectionView.backgroundColor=[UIColor whiteColor];
//    [_collectionView registerClass:[MPParallaxCollectionViewCell class] forCellWithReuseIdentifier:kCell];
//    [self.view addSubview:_collectionView];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.imageArray count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 658)];
        ((UIImageView *)view).image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[index]];
        view.contentMode = UIViewContentModeCenter;
    }
    else
    {
        //get a reference to the label in the recycled view
        ((UIImageView *)view).image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[index]];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 658)];
        ((UIImageView *)view).image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[index]];
        view.contentMode = UIViewContentModeCenter;
    }
    else
    {
        //get a reference to the label in the recycled view
        ((UIImageView *)view).image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[index]];
    }
//    ((UIImageView *)view).image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[index]];
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
//    NSNumber *item = (self.items)[(NSUInteger)index];
    NSLog(@"Tapped view number: %d", index);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}

//#pragma mark - CollectionView Delegate
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    
//    return self.imageArray.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    MPParallaxCollectionViewCell* cell =  (MPParallaxCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
//    
////    cell.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li",(long)indexPath.item%5+1]];
////    cell.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
//    cell.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageArray[indexPath.row]];
//    cell.delegate=self;
//
//    NSString *text = @"美易点出品";
//    
//    // that shit just to not make dirty MPParallaxCollectionViewCell ... I add that only to demonstrate how to use the percent driven stuff
//    if (![cell viewWithTag:3838]) {
//        MPTextReavealLabel *label=[[MPTextReavealLabel alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 40, 280, 30)];
//        label.tag=3838;
//        label.lineWidth=3;
//        [cell addSubview:label];
//        
//    }
//    
//    MPTextReavealLabel *label=(MPTextReavealLabel *)[cell viewWithTag:3838];
//    label.frame=CGRectMake(20, self.view.bounds.size.height - 40, 280, 30);
//    label.attributedText=[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-light" size:30],NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1]}];
////    label.attributedText = [[NSAttributedString alloc] initWithString:text];
//    
//    return cell;
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//}
//#pragma mark - MPParallaxCollectionView Delegate
//- (void)cell:(MPParallaxCollectionViewCell *)cell changeParallaxValueTo:(CGFloat)value{
//    
//    NSLog(@"%f",value);
//    
//    MPTextReavealLabel *label=(MPTextReavealLabel *)[cell viewWithTag:3838];
//    CGFloat val=1-(value<0 ? -value : value);
//    [label drawToValue:val*val];
//}


@end
