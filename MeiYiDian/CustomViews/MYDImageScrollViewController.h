//
//  MYDImageScrollViewController.h
//  MeiYiDian
//
//  Created by dfy on 15/1/31.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDBaseViewController.h"

@interface MYDImageScrollViewController : MYDBaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (id)initWithId:(NSString *)IdStr;
@end
