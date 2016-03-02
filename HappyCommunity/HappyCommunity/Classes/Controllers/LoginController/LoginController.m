//
//  LoginController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "LoginController.h"
#import "EMError.h"
#import "EMSDK.h"
#import "HappyTabController.h"
<<<<<<< HEAD
#import "DataBaseTools.h"
=======
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "LeftViewController.h"
#import "MyViewController.h"
>>>>>>> 658d315e0a02bdcb25b6d55bcef60dbb2347c3c1

@interface LoginController ()<RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//设置文本框左视图的占位图标
	self.userField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account@2x"]];
	self.userField.leftViewMode = UITextFieldViewModeAlways;
	
	self.passWordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password@2x"]];
	self.passWordField.leftViewMode = UITextFieldViewModeAlways;
	
}

//注册按钮点击事件
- (IBAction)registerAction:(UIButton *)sender {
	if (![self isEmpty]) {
		//退出键盘
		[self.view endEditing:YES];
		
		if ([self isChinese:self.userField.text]) {
			[self showAlert:@"用户名不支持汉字" title:@"Error"];
			return;
		}
		
		//执行注册
		__weak typeof(self) weakself = self;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			//执行注册语句
			EMError *error = [[EMClient sharedClient] registerWithUsername:self.userField.text password:self.passWordField.text];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if (!error) {
					[weakself showAlert:@"注册成功" title:@"Success"];
				}else{
					
					switch (error.code) {
						case EMErrorServerNotReachable:
							[weakself showAlert:@"连接服务器失败" title:@"Error"];
							break;
						case EMErrorUserAlreadyExist:
							[weakself showAlert:@"用户已存在" title:@"Error"];
							break;
						case EMErrorNetworkUnavailable:
							[weakself showAlert:@"网络连接不可用" title:@"Error"];
							break;
						case EMErrorServerTimeout:
							[weakself showAlert:@"连接服务器超时" title:@"Error"];
							break;
							
						default:
							[weakself showAlert:@"注册失败" title:@"Error"];
							break;
					}
					
				}
			});
			
		});
		
	}
}

//登陆按钮点击事件
- (IBAction)loginAction:(UIButton *)sender {
	
	//异步登陆账号
	__weak typeof(self) weakself = self;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		EMError *error = [[EMClient sharedClient] loginWithUsername:self.userField.text password:self.passWordField.text];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (!error) {
				
				HappyTabController *tab = [[HappyTabController alloc] init];
<<<<<<< HEAD
				[self presentViewController:tab animated:YES completion:nil];
				//打开数据库
				[[DataBaseTools SharedInstance] openDataBase];
=======
                
                LeftViewController *lvc = [[LeftViewController alloc] init];
                
                RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:tab leftMenuViewController:lvc rightMenuViewController:nil];
                sideMenuViewController.mainController = tab;
                sideMenuViewController.menuPreferredStatusBarStyle = 1;
                sideMenuViewController.delegate = self;
                sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
                sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
                sideMenuViewController.contentViewShadowOpacity = 0.6;
                sideMenuViewController.contentViewShadowRadius = 6;
                sideMenuViewController.contentViewShadowEnabled = YES;
                sideMenuViewController.scaleBackgroundImageView = NO;
                
				[self presentViewController:sideMenuViewController animated:YES completion:nil];
>>>>>>> 658d315e0a02bdcb25b6d55bcef60dbb2347c3c1
				
			}else{
				switch (error.code) {
					case EMErrorNetworkUnavailable:
						[weakself showAlert:@"没有网络连接" title:@"Error"];
						break;
					case EMErrorServerNotReachable:
						[weakself showAlert:@"网络连接失败" title:@"Error"];
						break;
					case EMErrorUserAuthenticationFailed:
						[weakself showAlert:@"用户验证失败,请重新输入用户名和密码" title:@"Error"];
						break;
					case EMErrorServerTimeout:
						[weakself showAlert:@"网络连接超时" title:@"Error"];
						break;
						
					default:
						[weakself showAlert:@"登陆失败,请重新输入用户名和密码" title:@"Error"];
						break;
				}
			}
		});
		
	});
	
}

//判断密码和用户输入框是否为空.
- (BOOL)isEmpty{
	BOOL flag = NO;
	NSString *userName = self.userField.text;
	NSString *password = self.passWordField.text;
	if (userName.length==0||password.length==0) {
		flag = YES;
		[self showAlert:@"请输入用户名和密码" title:@"Error"];
	}
	return flag;
}

- (void)showAlert:(NSString *)string title:(NSString *)title{
	UIAlertController *control = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	[control addAction:action];
	[self presentViewController:control animated:YES completion:nil];
}

//判断是否是汉字,如果是汉字返回NO
- (BOOL)isChinese:(NSString *)str
{
	NSString *match = @"(^[\u4e00-\u9fa5]+$)";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
	return [predicate evaluateWithObject:str];
}

//点击屏幕回收键盘
-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
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
