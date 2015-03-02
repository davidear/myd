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
#import "MYDPictureScrollViewController.h"

#import "MYDConstants.h"
#import "MYDUIConstant.h"

@interface MYDMainViewController ()<UITableViewDataSource, UITableViewDelegate>
//UI
@property (strong, nonatomic) MYDEnterpriseIntroduceViewController *enterpriseIntroduceVC;
@property (strong, nonatomic) MYDMaterialIntroduceViewController *materialIntroduceVC;
@property (strong, nonatomic) MYDPartyIntroduceViewController *partyIntroduceVC;
@property (strong, nonatomic) MYDPriceIntroduceViewController *priceIntroduceVC;
@property (strong, nonatomic) MYDProjectIntroduceViewController *projectIntroduceVC;
@property (strong, nonatomic) MYDWritingIntroduceViewController *writingIntroduceVC;
@property (strong, nonatomic) IBOutlet UILabel *departmentNameLabel;

@property (strong, nonatomic) UINavigationController *navigationController;



@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

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
    
    [self initViewControllers];
    [self swithContentViewWithIndex:self.selectedRow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPictureScrollViewController:) name:kNotificationForImageButtonAction object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self swithContentViewWithIndex:self.selectedRow];
}
//- (void)viewDidAppear:(BOOL)animated
//{
////    [self initViewControllers];
//    [super viewDidAppear:animated];
//    [self swithContentViewWithIndex:self.tableIndex];
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPictureScrollViewController:) name:kNotificationForImageButtonAction object:nil];
//}

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
    self.departmentNameLabel.text = [NSString stringWithFormat:@"%@欢迎您",[[[[MYDDBManager getInstant] readLoginUser] objectAtIndex:0] objectForKey:@"DepartmentName"]];
}
- (void)initDataSource
{
    self.dataArray = @[@"首页",@"企业介绍",@"价格表",@"项目介绍",@"产品介绍",@"活动方案",@"作品展示"];
}
#pragma mark - Button Action
- (IBAction)logoutAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoginView object:nil];
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
//        cell.imageView.backgroundColor = [UIColor blueColor];
        cell.textLabel.center = CGPointMake(cell.center.x, cell.center.y + 8);
        cell.textLabel.textColor = [UIColor colorWithRed:255.0/255 green:102.0/255 blue:102.0/255 alpha:1];
        cell.textLabel.font = kFont_Small;
    }
    NSString *imageName = [NSString stringWithFormat:@"0%d_icon.png",indexPath.row+1];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    if (self.selectedRow == indexPath.row) {
        return;
    }
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (indexPath.row == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self swithContentViewWithIndex:indexPath.row];
    }
    
//    switch (indexPath.row) {
//        case 0:
//        {
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }
//            break;
//        case 1:
//        {
//            if (self.contentView.subviews.count != 0) {
//                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
//            }
//            [self.contentView addSubview:self.enterpriseIntroduceVC.view];
//        }
//            break;
//        case 2:
//        {
//            if (self.contentView.subviews.count != 0) {
//                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
//            }
//            [self.contentView addSubview:self.priceIntroduceVC.view];
//        }
//            break;
//        case 3:
//        {
//            if (self.contentView.subviews.count != 0) {
//                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
//            }
//            [self.contentView addSubview:self.projectIntroduceVC.view];
//        }
//            break;
//        case 4:
//        {
//            if (self.contentView.subviews.count != 0) {
//                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
//            }
//            [self.contentView addSubview:self.materialIntroduceVC.view];
//        }
//            break;
//        case 5:
//        {
//            if (self.contentView.subviews.count != 0) {
//                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
//            }
//            [self.contentView addSubview:self.partyIntroduceVC.view];
//        }
//            break;
//        case 6:
//        {
//            if (self.contentView.subviews.count != 0) {
//                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
//            }
//            [self.contentView addSubview:self.writingIntroduceVC.view];
//        }
//            break;
//        default:
//            break;
//    }
    self.selectedRow = indexPath.row;
}
- (void)swithContentViewWithIndex:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    switch (index) {
        case 1:
        {
            if (self.contentView.subviews.count != 0) {
                [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
            }
            [self.contentView addSubview:self.enterpriseIntroduceVC.view];
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
}

#pragma mark - Notification Action
- (void)presentPictureScrollViewController:(NSNotification *)notification
{
    MYDPictureScrollViewController *pictureScrollVC = [[MYDPictureScrollViewController alloc] initWithImageArray:notification.object];
    [self presentViewController:pictureScrollVC animated:YES completion:^{
        
    }];
}
@end