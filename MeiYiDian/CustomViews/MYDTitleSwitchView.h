//
//  MYDTitleSwitchView.h
//  MeiYiDian
//
//  Created by dai.fy on 15/3/9.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYDTitleSwitchView;
@protocol MYDTitleSwitchViewDelegate
- (void)titleSwitchView:(MYDTitleSwitchView *)titleSwitchView DidSelected:(NSInteger)index;
@end
@interface MYDTitleSwitchView : UIView
{
    UIScrollView *_scrollView;
}
@property (weak, nonatomic) id<MYDTitleSwitchViewDelegate> delegate;
@property (strong, nonatomic) NSArray *dataArray;
- (id)initWithTitleArray:(NSArray *)dataArray frame:(CGRect)frame;
- (void)selectIndex:(NSInteger)index;
@end




