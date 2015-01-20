//
//  MYDPriceIntroduceViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/19.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDPriceIntroduceViewController.h"
#import "MYDDBManager.h"

@interface MYDPriceIntroduceViewController ()<UITableViewDataSource, UITableViewDelegate>
//DATA
@property (strong, nonatomic) NSArray *materialdataArray;
@property (strong, nonatomic) NSArray *projectDataArray;
//UI
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MYDPriceIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];

}
- (void)initDataSource
{
    self.materialdataArray = [[MYDDBManager getInstant] readMaterials];
    self.projectDataArray = [[MYDDBManager getInstant] readProjects];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    return cell;
}
@end
