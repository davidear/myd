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
#import "MBProgressHUD.h"
#import "MYDNetwork.h"
#import "MYDConstants.h"
@interface MYDLoginViewController ()<MBProgressHUDDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *userNameRememberedView;
@property (strong, nonatomic) IBOutlet UIView *passwordRememberedView;
@property (weak, nonatomic) IBOutlet UILabel *prompLabel;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL isSelected;
@end

@implementation MYDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置头像图像
//    self.userHeaderImageView.layer.cornerRadius = 84;
//    self.userHeaderImageView.clipsToBounds = YES;
    
    //设置登录按钮
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.clipsToBounds = YES;
    //设置记住用户名和记住密码两个view
    UITapGestureRecognizer *rememberUserNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remenberUserName:)];
    UITapGestureRecognizer *rememberPasswordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remenberPassword:)];
    [self.passwordRememberedView addGestureRecognizer:rememberPasswordTap];
    [self.userNameRememberedView addGestureRecognizer:rememberUserNameTap];
    [((UIButton *)[self.userNameRememberedView viewWithTag:1]) setImage:[UIImage imageNamed:@"btn_noSelected.png"] forState:UIControlStateNormal];
    [((UIButton *)[self.userNameRememberedView viewWithTag:1]) setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
    [((UIButton *)[self.passwordRememberedView viewWithTag:1]) setImage:[UIImage imageNamed:@"btn_noSelected.png"] forState:UIControlStateNormal];
    [((UIButton *)[self.passwordRememberedView viewWithTag:1]) setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //从NSUserDefault取值并赋值给两个view
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"remenberUserName"] isKindOfClass:[NSNumber class]]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"remenberUserName"] boolValue]) {
            ((UIButton *)[self.userNameRememberedView viewWithTag:1]).selected = YES;
            self.userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserName"];
        }else{
            self.userNameTextField.text = nil;
        }
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"remenberPassword"] isKindOfClass:[NSNumber class]]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"remenberPassword"] boolValue]) {
            ((UIButton *)[self.passwordRememberedView viewWithTag:1]).selected = YES;
            self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginPassword"];
        }else{
            self.passwordTextField.text = nil;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationForPictureDownload object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮事件
- (void)remenberUserName:(UIView *)sender
{
    ((UIButton *)[self.userNameRememberedView viewWithTag:1]).selected = !((UIButton *)[self.userNameRememberedView viewWithTag:1]).isSelected;
    if (!((UIButton *)[self.userNameRememberedView viewWithTag:1]).isSelected) {
        ((UIButton *)[self.passwordRememberedView viewWithTag:1]).selected = NO;
    }

}
- (void)remenberPassword:(UIView *)sender
{
    if (((UIButton *)[self.userNameRememberedView viewWithTag:1]).isSelected) {
        ((UIButton *)[self.passwordRememberedView viewWithTag:1]).selected = !((UIButton *)[self.passwordRememberedView viewWithTag:1]).isSelected;
    }
}
//在点击按钮时做初始化
- (IBAction)loginButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if (self.isSelected == YES) {
        return;
    }
    if (self.userNameTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写用户名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else if (self.passwordTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[MYDMediator getInstant] loginWithUserName:self.userNameTextField.text password:self.passwordTextField.text success:^(NSString *responseString) {
        //登录成功，将记住密码和记住用户名,密码和用户名四个参数都存入NSUserDefault
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:((UIButton *)[self.userNameRememberedView viewWithTag:1]).isSelected] forKey:@"remenberUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:((UIButton *)[self.passwordRememberedView viewWithTag:1]).isSelected] forKey:@"remenberPassword"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextField.text forKey:@"loginUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"loginPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //DataVersion不相同或者 baseData中的DataVersion为0，则发起数据更新
        int oldDataVersion = [[MYDDBManager getInstant] readDataVersionFromBaseData];
        int newDataVersion = [[MYDDBManager getInstant] readDataVersionFromLoginResult];
        
        if (oldDataVersion != newDataVersion | oldDataVersion == 0 ) {
            [[MYDMediator getInstant] getBaseDataWithDepartmentId:[[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"] success:^(NSString *responseString) {
                self.prompLabel.text = @"数据更新中，请稍后.....";
                [self downloadPictures];
            } failure:^(NSError *error) {
                
            }];
        }else{
            self.prompLabel.text = @"数据更新中，请稍后.....";
            [self downloadPictures];
        }
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@,请重试",error.domain] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        self.isSelected = NO;
        self.userNameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        self.prompLabel.hidden = YES;
    }];
    
    self.isSelected = YES;
    self.userNameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.prompLabel.text = @"检查服务器更新.....";
    self.prompLabel.hidden = NO;
}
#pragma mark -
- (void)downloadDone
{
    [self.hud hide:YES];
    
    self.isSelected = NO;
    self.userNameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.prompLabel.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForHomeView object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
//    [[MYDProgressManager getInstant] showInView:self.view];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    [[MYDNetwork getInstant] setProgressDelegate:self.hud];
    self.hud.delegate = self;
    self.hud.labelText = @"Loading..";
    [self.hud show:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDone) name:kNotificationForPictureDownload object:nil];
}

#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

//-(void) myProgressTask{
//    float progress = 0.0f;
//    while (progress < 1.0f) {
//        progress += 0.01f;
//        self.hud.progress = progress;
//        usleep(50000);
//    }  
//    
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
//            [textField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
            break;
        case 2:
//            if (self.userNameTextField.text.length == 0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写用户名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }else if (self.passwordTextField.text.length == 0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }else {
                [textField resignFirstResponder];
                [self loginButtonPressed:nil];
//            }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - Notification Action
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0, -(CGRectGetMaxY(self.loginButton.frame) - keyboardRect.origin.y), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    self.view.frame = CGRectOffset(self.view.frame, 0, -(CGRectGetMaxY(self.loginButton.frame) - keyboardRect.origin.y));
    
    [UIView commitAnimations];  
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = self.view.bounds;
    
    [UIView commitAnimations];  
}
@end
