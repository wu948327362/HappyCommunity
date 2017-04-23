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
#import "DataBaseTools.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "LeftViewController.h"
#import "MyViewController.h"
#import "MyEMManager.h"
#import "LoginAnimatino.h"

static LoginController *loginController;
@interface LoginController ()<RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordLine;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//设置文本框左视图的占位图标
	self.userField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account@2x"]];
	self.userField.leftViewMode = UITextFieldViewModeAlways;
	
	self.passWordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password@2x"]];
	self.passWordField.leftViewMode = UITextFieldViewModeAlways;
	
	_nameLabelLine.constant = 0;
	_passwordLine.constant = 0;
	
	self.registerBtn.transform = CGAffineTransformMakeTranslation(-200, 0);
	self.loginBtn.transform = CGAffineTransformMakeTranslation(400, 0);
	
}

//单例方法
+ (instancetype)shareInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		loginController = [[LoginController alloc] init];
	});
	return loginController;
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	//两条线从中间开始变长
	[LoginAnimatino labelAnimationWithLabel:_nameLabelLine view:self.view];
	[LoginAnimatino labelAnimationWithLabel:_passwordLine view:self.view];
	
	//两个btn从两边开始进入
	[LoginAnimatino btnAnimationWithBtn:self.registerBtn view:self.view];
	[LoginAnimatino btnAnimationWithBtn:self.loginBtn view:self.view];
	
}
- (void)justTestSomething{
    //这仅仅是一个测试。
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
		[[MyEMManager shareInstance] RegisterWithName:self.userField.text password:self.passWordField.text finish:^(EMError *err) {
			if (!err) {
				[weakself showAlert:@"注册成功" title:@"Success"];
			}else{
				
				switch (err.code) {
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
		}];
		
	}
}

//登陆按钮点击事件
- (IBAction)loginAction:(UIButton *)sender {
	
	//异步登陆账号
	__weak typeof(self) weakself = self;
	
	[[MyEMManager shareInstance] LoginWithName:self.userField.text password:self.passWordField.text finish:^(EMError *err) {
		if (!err) {
			HappyTabController *tab = [[HappyTabController alloc] init];
			//打开数据库
			[[DataBaseTools SharedInstance] openDataBase];
			
			
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
		}else{
			switch (err.code) {
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
	}];
	
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

//将密码输入框置为空
- (void)clearPassword{
	self.passWordField.text = @"";
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
