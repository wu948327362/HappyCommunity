//
//  SettingsController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/7.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "SettingsController.h"

#import "RESideMenu.h"
#import "BirdFlyViewController.h"
#import "EMSDK.h"
#import "MyEMManager.h"
#import "LoginController.h"
#import "DataBaseTools.h"

@interface SettingsController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UISwitch *isAutoLogin;

@property (weak, nonatomic) IBOutlet UIButton *smallGame;

@property (weak, nonatomic) IBOutlet UIButton *logOut;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)UIImagePickerController *picker;

@property(nonatomic,strong)NSString *picturePath;

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [[EMClient sharedClient] currentUsername];
    self.versionLabel.text = [[EMClient sharedClient] version];
    
    // 初始化照片选择控制器
    self.picker = [[UIImagePickerController alloc] init];
    // 指定代理
    self.picker.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(presentLeftMenuViewController:)];
	
	//获取缓存的图片
	self.imageView.image = [[DataBaseTools SharedInstance] getCachePicture];
	if (self.imageView.image==nil) {
		self.imageView.image = [UIImage imageNamed:@"chatListCellHead@2x"];
	}
	
}

#pragma mark - Configuring the view’s layout behavior
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//设置是否免打扰
- (IBAction)isAutoLoginAction:(UISwitch *)sender {
	
	if (sender.isOn) {
		[[EMClient sharedClient].pushOptions setNoDisturbStatus:EMPushNoDisturbStatusDay];
	}else{
		[[EMClient sharedClient].pushOptions setNoDisturbStatus:EMPushNoDisturbStatusClose];
	}
	
	
}

//小游戏
- (IBAction)smallGameAction:(UIButton *)sender {
    
    // 在跳转界面后隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    BirdFlyViewController *bfvc = [[BirdFlyViewController alloc] init];
    [self.navigationController pushViewController:bfvc animated:YES];
    
    // 将hidesBottomBarWhenPushed设置为NO
    self.hidesBottomBarWhenPushed = NO;
}

//注销
- (IBAction)logOutAction:(UIButton *)sender {
	
	[[MyEMManager shareInstance] logoutWithFinish:^(EMError *err) {
		if (err!=nil) {
			[self showAlert:@"注销失败" title:@"Error"];
		}else{
			[[LoginController shareInstance] clearPassword];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}];
	
}

//选取头像
- (IBAction)imagePickAction:(UIButton *)sender {
	
	self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	self.picker.allowsEditing = YES;
	[self presentViewController:self.picker animated:YES completion:nil];
	
	
}

//完成选取图片时执行
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
	self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[self.picker dismissViewControllerAnimated:YES completion:nil];
	//缓存图片
	[[DataBaseTools SharedInstance] cachePictureWithImage:self.imageView.image];
}

//点击取消是执行
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self.picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert:(NSString *)string title:(NSString *)title{
	UIAlertController *control = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	[control addAction:action];
	[self presentViewController:control animated:YES completion:nil];
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

@end
