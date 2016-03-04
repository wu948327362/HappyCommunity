//
//  AddFriendController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "AddFriendController.h"
#import "EMSDK.h"
#import "EMError.h"

@interface AddFriendController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation AddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.addBtn.layer.masksToBounds = YES;
	self.addBtn.layer.cornerRadius = 5;
	self.cancelBtn.layer.masksToBounds = YES;
	self.cancelBtn.layer.cornerRadius = 5;
	
}

- (IBAction)addAction:(UIButton *)sender {
	
	if (self.flag==0){
		if (!self.nameField.text.length==0) {
			[self.view endEditing:YES];
			
			__weak typeof(self) weakself = self;
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				EMError *error = [[EMClient sharedClient].contactManager addContact:self.nameField.text message:self.messageField.text];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					if (!error) {
						[weakself showAlert:@"好友请求已发送" title:@"成功"];
						self.nameField.text = @"";
						self.messageField.text = @"";
					}else{
						[weakself showAlert:@"添加失败" title:@"失败"];
					}
				});
				
			});
			
		}else{
			[self showAlert:@"请输入用户名" title:@"Error"];
		}
	}else if (self.flag==1){
		if (!self.nameField.text.length==0) {
			[self.view endEditing:YES];
			
			__weak typeof(self) weakself = self;
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				EMError *error = nil;
				EMGroupOptions *options = [[EMGroupOptions alloc] init];
				options.maxUsersCount = 100;
				options.style = EMGroupStylePublicJoinNeedApproval;
				[[EMClient sharedClient].groupManager createGroupWithSubject:self.nameField.text description:self.messageField.text invitees:nil message:self.messageField.text setting:options error:&error];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					if (!error) {
						[weakself showAlert:@"创建群聊成功" title:@"成功"];
						self.nameField.text = @"";
						self.messageField.text = @"";
					}else{
						[weakself showAlert:@"创建群聊失败" title:@"失败"];
					}
				});
				
			});
			
		}else{
			[self showAlert:@"请输入群名称" title:@"Error"];
		}
	}
	
	
}

//回收键盘.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
}

- (IBAction)cancelAction:(UIButton *)sender {
	[self.view endEditing:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

//显示提示信息.
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
