//
//  MYDLoginViewController.m
//  MeiYiDian
//
//  Created by dfy on 15/1/16.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//
//在每次更新baseData之后更新数据库的dataVersion
//每次都调用加载图片，然后自检是否存在，不存在则发起下载
#import "MYDLoginViewController.h"
#import "MYDHomeViewController.h"
#import "MYDMediator.h"
#import "MYDDBManager.h"
#import "SDImageCache.h"
#import "MYDProgressManager.h"

@interface MYDLoginViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;


@end

@implementation MYDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PicturesDone" object:nil];
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
            } failure:^(NSError *error) {
                
            }];
        }else{
            [self downloadPictures];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)downloadDone
{
    [self presentViewController:[[MYDHomeViewController alloc] init] animated:YES completion:^{
        
    }];
}

- (void)downloadPictures
{
    NSString *DepartmentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"];
    NSArray *picArr;
    //获取01产品图片
    picArr = [[MYDDBManager getInstant] readMaterialPictures];
    for (NSDictionary *dic in picArr) {         
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"FileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"01" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
        
    }
    
    //获取03滚动图片
    picArr = [[MYDDBManager getInstant] readScrollPictures];
    for (NSDictionary *dic in picArr) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"FileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"03" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    //获取04作品图片
    picArr = [[MYDDBManager getInstant] readWritingPictures];
    for (NSDictionary *dic in picArr) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"FileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"04" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
        
    }
    
    //获取05项目图片
    picArr = [[MYDDBManager getInstant] readProjectPictures];
    for (NSDictionary *dic in picArr) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"FileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"05" fileName:[dic objectForKey:@"FileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"FileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
        
    }
    
    //获取06团队图片
    
//!!!比较坑的来了，上面的图片不是其类中包含图片，比如说05取的图不是在porjects中的图片字段所指的图，那么，所有类中出现的图也必须下载
    picArr = [[MYDDBManager getInstant] readProjects];
    for (NSDictionary *dic in picArr) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"TitlePictureFileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"05" fileName:[dic objectForKey:@"TitlePictureFileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"TitlePictureFileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    picArr = [[MYDDBManager getInstant] readMaterials];
    for (NSDictionary *dic in picArr) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"TitlePictureFileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"01" fileName:[dic objectForKey:@"TitlePictureFileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"TitlePictureFileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    picArr = [[MYDDBManager getInstant] readWritings];
    for (NSDictionary *dic in picArr) {
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:[dic objectForKey:@"TitlePictureFileName"]]) {
            [[MYDMediator getInstant] getPictureWithDepartmentId:DepartmentId typeCode:@"04" fileName:[dic objectForKey:@"TitlePictureFileName"] success:^(NSString *responseString) {
                NSLog(@"download %@ done!",[dic objectForKey:@"TitlePictureFileName"]);
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
    [[MYDProgressManager getInstant] showInView:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDone) name:@"PicturesDone" object:nil];
}



@end
