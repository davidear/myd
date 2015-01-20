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
}

- (void)initDataSource
{
    self.dataArray = @[@"首页",@"企业介绍",@"价格表",@"项目介绍",@"产品介绍",@"活动方案",@"作品展示"];
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
            break;
        case 1:
        {
            MYDEnterpriseIntroduceViewController *VC = [[MYDEnterpriseIntroduceViewController alloc] init];
            [self.contentView addSubview:VC.view];
        }
            break;
        case 2:
        {
            MYDMaterialIntroduceViewController *VC = [[MYDMaterialIntroduceViewController alloc] init];
            [self.contentView addSubview:VC.view];
        }
            break;
        case 3:
        {
            MYDPartyIntroduceViewController *VC = [[MYDPartyIntroduceViewController alloc] init];
            [self.contentView addSubview:VC.view];
        }
            break;
        case 4:
        {
            MYDPriceIntroduceViewController *VC = [[MYDPriceIntroduceViewController alloc] init];
            [self.contentView addSubview:VC.view];
        }
            break;
        case 5:
        {
            MYDProjectIntroduceViewController *VC = [[MYDProjectIntroduceViewController alloc] init];
            [self.contentView addSubview:VC.view];
        }
            break;
        case 6:
        {
            MYDWritingIntroduceViewController *VC = [[MYDWritingIntroduceViewController alloc] init];
            [self.contentView addSubview:VC.view];
        }
            break;
        default:
            break;
    }
    self.selectedRow = indexPath.row;
}
@end