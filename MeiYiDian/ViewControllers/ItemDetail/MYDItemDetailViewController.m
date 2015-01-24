//
//  MYDItemDetailViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/24.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDItemDetailViewController.h"

@interface MYDItemDetailViewController ()
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@end

@implementation MYDItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)imageButtonAction:(id)sender {
}
@end
