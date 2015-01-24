//
//  MYDMainViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/7.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDMainViewController.h"
#import "MYDEnterpriseIntroduceViewController.h"
#import "MYDMaterialIntroduceViewController.h"
#import "MYDPartyIntroduceViewController.h"
#import "MYDPriceIntroduceViewController.h"
#import "MYDProjectIntroduceViewController.h"
#import "MYDWritingIntroduceViewController.h"

@interface MYDMainViewController ()<UITableViewDataSource, UITableViewDelegate>
//UI
@property (strong, nonatomic) MYDEnterpriseIntroduceViewController *enterpriseIntroduceVC;
@property (strong, nonatomic) MYDMaterialIntroduceViewController *materialIntroduceVC;
@property (strong, nonatomic) MYDPartyIntroduceViewController *partyIntroduceVC;
@property (strong, nonatomic) MYDPriceIntroduceViewController *priceIntroduceVC;
@property (strong, nonatomic) MYDProjectIntroduceViewController *projectIntroduceVC;
@property (strong, nonatomic) MYDWritingIntroduceViewController *writingIntroduceVC;



@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int selectedRow;
//DATA
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation MYDMainViewController
static NSString *MyCell = @"MyCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];
    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initViewControllers];
}

//加快加载速度
- (void)initViewControllers
{
    self.enterpriseIntroduceVC = [[MYDEnterpriseIntroduceViewController alloc] init];
    self.materialIntroduceVC = [[MYDMaterialIntroduceViewController alloc] init];
    self.partyIntroduceVC = [[MYDPartyIntroduceViewController alloc] init];
    self.priceIntroduceVC = [[MYDPriceIntroduceViewController alloc] init];
    self.projectIntroduceVC = [[MYDProjectIntroduceViewController alloc] init];
    self.writingIntroduceVC = [[MYDWritingIntroduceViewController alloc] init];
}
- (void)initSubviews
{
}
- (void)initDataSource
{
    self.dataArray = @[@"首页",@"企业介绍",@"价格表",@"项目介绍",@"产品介绍",@"活动方案",@"作品展示"];
    self.selectedRow = -1;
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.imageView.frame = CGRectMake(0, 0, 50, 50);
        cell.imageView.center = CGPointMake(cell.center.x, cell.center.y - 25);
        cell.imageView.backgroundColor = [UIColor blueColor];
        cell.textLabel.center = CGPointMake(cell.center.x, cell.center.y + 8);
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedRow == indexPath.row) {
        return;
    }
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (indexPath.row) {
        case 0:
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        case 1:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.enterpriseIntroduceVC.view];
//            self.contentView = VC.view;
//            [self.view setNeedsDisplay];
        }
            break;
        case 2:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.priceIntroduceVC.view];
        }
            break;
        case 3:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.projectIntroduceVC.view];
        }
            break;
        case 4:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.materialIntroduceVC.view];
        }
            break;
        case 5:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.partyIntroduceVC.view];
        }
            break;
        case 6:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.writingIntroduceVC.view];
        }
            break;
        default:
            break;
    }
    self.selectedRow = indexPath.row;
}


@end