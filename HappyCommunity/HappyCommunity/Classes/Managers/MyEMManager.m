//
//  MyEMManager.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/5.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "MyEMManager.h"
#import "DataBaseTools.h"
#import "HappyTabController.h"
#import "RESideMenu.h"
#import "LeftViewController.h"
#import "EMError.h"


static MyEMManager *manager = nil;
@implementation MyEMManager

+ (instancetype)shareInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[MyEMManager alloc] init];
	});
	return manager;
}

//添加好友进群
- (UIAlertController *)addToGroup:(NSString *)receiveId{
	UIAlertController *control = [UIAlertController alertControllerWithTitle:@"添加好友进群" message:[NSString stringWithFormat:@"%@邀请你加入群聊",[[EMClient sharedClient] currentUsername]] preferredStyle:UIAlertControllerStyleAlert];
	
	__block NSString *name = nil;
	[control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"请输入好友名字";
		textField.adjustsFontSizeToFitWidth = YES;
		name = textField.text;
	}];
	
	//得到group
	NSArray *arr = [receiveId componentsSeparatedByString:@":"];
	
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[[EMClient sharedClient].groupManager addOccupants:@[name] toGroup:[arr firstObject] welcomeMessage:[NSString stringWithFormat:@"%@邀请你加入群聊",[[EMClient sharedClient] currentUsername]] error:nil];
	}];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[control addAction:ok];
	[control addAction:cancel];
	
	return control;
}

//发送消息
- (void)sendMessageWithReceiveId:(NSString *)receiveId message:(NSString *)messge flag:(NSInteger)flag finish:(void(^)())finish{
	//发送消息为空则返回.
	if (messge.length==0) {
		return;
	}
	EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:messge];
	NSString *sendUser = [[EMClient sharedClient] currentUsername];
	
	if (flag==0) {
		EMMessage *message  = [[EMMessage alloc] initWithConversationID:receiveId from:sendUser to:receiveId body:body ext:nil];
		message.chatType = EMChatTypeChat;
		
		[[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
			
		} completion:^(EMMessage *message, EMError *error) {
			if (!error) {
				//保存聊天记录到coreData
				[[DataBaseTools SharedInstance] saveMessageModelWith:message];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					finish();
				});
			}
		}];
		
	}else if (flag==1||flag==2){
		//获取所要发送的群组的ID
		NSArray *arr = [receiveId componentsSeparatedByString:@":"];
		
		EMMessage *message = [[EMMessage alloc] initWithConversationID:[arr firstObject] from:sendUser to:[arr firstObject] body:body ext:nil];
		message.chatType = EMChatTypeGroupChat;
		
		[[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
			
		} completion:^(EMMessage *message, EMError *error) {
			if (!error) {
				//保存聊天记录到coreData
				[[DataBaseTools SharedInstance] saveMessageModelWith:message];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					finish();
				});
			}
		}];
		
	}
}

//登陆
- (void)LoginWithName:(NSString *)name password:(NSString *)password finish:(void(^)(EMError *err))finish{
	
	//异步登陆账号
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		EMError *error = [[EMClient sharedClient] loginWithUsername:name password:password];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			finish(error);
		});
		
	});
}

//注册
- (void)RegisterWithName:(NSString *)name password:(NSString *)password finish:(void (^)(EMError *err))finish{
	//执行注册
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//执行注册语句
		EMError *error = [[EMClient sharedClient] registerWithUsername:name password:password];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			finish(error);
		});
		
	});
	
}

//添加好友
- (void)addFriendWithName:(NSString *)name message:(NSString *)message finish:(void(^)(EMError *err))finish{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		EMError *error = [[EMClient sharedClient].contactManager addContact:name message:message];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			finish(error);
		});
		
	});
}

//创建群组
- (void)addGroupWithName:(NSString *)name message:(NSString *)message finish:(void (^)(EMError *))finish{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		EMError *error = nil;
		EMGroupOptions *options = [[EMGroupOptions alloc] init];
		options.maxUsersCount = 100;
		options.style = EMGroupStylePublicJoinNeedApproval;
		[[EMClient sharedClient].groupManager createGroupWithSubject:name description:message invitees:nil message:message setting:options error:&error];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			finish(error);
		});
		
	});
}

@end

















