//
//  MYDScrollView.h
//  MeiYiDian
//
//  Created by dfy on 15/1/27.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^MYDScrollDoneBlock)(NSInteger index);
@interface MYDScrollView : UIView<UIScrollViewDelegate>
// entity字典的数组，按照要显示的顺序保存数据文件
@property (strong, nonatomic) NSMutableArray *detailDataList;
@property (strong, nonatomic) MYDScrollDoneBlock scrollDoneBlock;//每次滑动后的block
- (id)initWithFrame:(CGRect)frame index:(NSInteger)index;
@end
