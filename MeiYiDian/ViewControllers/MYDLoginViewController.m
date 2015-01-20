//
//  MYDLoginViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/16.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "MYDLoginViewController.h"
#import "MYDHomeViewController.h"
#import "MYDMediator.h"
#import "MYDDBManager.h"

@interface MYDLoginViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation MYDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//在点击按钮时做初始化
- (IBAction)loginButtonPressed:(id)sender {
    [[MYDMediator getInstant] loginWithUserName:@"myd001" password:@"myd001" success:^(NSString *responseString) {
        //DataVersion不相同或者 baseData中的DataVersion为0，则发起数据更新
        int oldDataVersion = [[MYDDBManager getInstant] readDataVersionFromBaseData];
        int newDataVersion = [[MYDDBManager getInstant] readDataVersionFromLoginResult];
        if (oldDataVersion != newDataVersion | oldDataVersion == 0 ) {
            [[MYDMediator getInstant] getBaseDataWithDepartmentId:[[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"] success:^(NSString *responseString) {
                
                [self downloadPictures];
                [self presentViewController:[[MYDHomeViewController alloc] init] animated:YES completion:^{
                    
                }];
            } failure:^(NSError *error) {
                
            }];
        }else{
            [self presentViewController:[[MYDHomeViewController alloc] init] animated:YES completion:^{
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    [self downloadPictures];
}

- (void)downloadPictures
{
    NSString *DepartmentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"];
    NSArray *picArr;
    //获取01产品图片
    picArr = [[MYDDBManager getInstant] readMaterialPictures];
    for (NSDictionary *dic in picArr) {
        [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"01" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
            NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    //获取03滚动图片
    picArr = [[MYDDBManager getInstant] readScrollPictures];
    for (NSDictionary *dic in picArr) {
        [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"03" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
            NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    //获取04作品图片
    picArr = [[MYDDBManager getInstant] readWritingPictures];
    for (NSDictionary *dic in picArr) {
        [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"03" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
            NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
        } failure:^(NSError *error) {
            
        }];
    }
    
    //获取05项目图片
    picArr = [[MYDDBManager getInstant] readProjectPictures];
    for (NSDictionary *dic in picArr) {
        [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"03" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
            NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
        } failure:^(NSError *error) {
            
        }];
    }
    
    //获取06团队图片

    
}



@end
