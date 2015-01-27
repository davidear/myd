//
//  MYDScrollView.h
//  MeiYiDian
//
//  Created by dfy on 15/1/27.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYDScrollView : UIView<UIScrollViewDelegate>
// entity字典的数组，按照要显示的顺序保存数据文件
@property (strong, nonatomic) NSMutableArray *detailDataList;

- (id)initWithFrame:(CGRect)frame index:(int)index;
@end
