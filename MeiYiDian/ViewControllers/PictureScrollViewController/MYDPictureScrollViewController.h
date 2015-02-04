//
//  MYDPictureScrollViewController.h
//  MeiYiDian
//
//  Created by dfy on 15/2/4.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDBaseViewController.h"
#import "MPParallaxLayout.h"
#import "MPParallaxCollectionViewCell.h"

@interface MYDPictureScrollViewController : MYDBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,MPParallaxCellDelegate>
{
    UICollectionView *_collectionView;
}


- (id)initWithImageArray:(NSArray *)imageArray;
@end
