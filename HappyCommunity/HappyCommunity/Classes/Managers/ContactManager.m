//
//  ContactManager.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "ContactManager.h"
#import "EMSDK.h"
#import "EMError.h"
#import "DataBaseTools.h"
#import "FriendsInvitation.h"

static ContactManager *manager;

@interface ContactManager ()<EMContactManagerDelegate>

@end

@implementation ContactManager

+ (instancetype)shareInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[ContactManager alloc] init];
		//设置接收到好友请求代理
		[[EMClient sharedClient].contactManager addDelegate:manager delegateQueue:nil];
	});
	return manager;
}

- (NSMutableArray *)dataForFlag:(NSInteger)flag{
	NSMutableArray *arr = [NSMutableArray array];
	NSArray *array = [NSArray array];
	
	switch (flag) {
		case 0:
			array = [[EMClient sharedClient].contactManager getContactsFromServerWithError:nil];
			[arr addObjectsFromArray:array];
			break;
		case 1:
			array = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:nil];
			[arr addObjectsFromArray:[self getNameArray:array flag:1]];
			break;
		case 2:
			array = [[EMClient sharedClient].groupManager getAllGroups];
			[arr addObjectsFromArray:[self getNameArray:array flag:2]];
			break;
		case 3:
			//按时没有用户请求需要自己去做.
			array = [[DataBaseTools SharedInstance] showAllPerson];
			[arr addObjectsFromArray:[self getNameArray:array flag:3]];
			break;
		default:
			break;
	}
	return arr;
}

//遍历数组存数据
- (NSMutableArray *)getNameArray:(NSArray *)arr flag:(NSInteger)flag{
	NSMutableArray *data = [NSMutableArray array];
	if (flag==1||flag==2) {
		for (EMGroup *group in arr) {
			[data addObject:[NSString stringWithFormat:@"%@:%@",group.groupId,group.description]];
		}
	}else if (flag==3){
		for (FriendsInvitation *friend in arr) {
			[data addObject:[NSString stringWithFormat:@"%@:%@",friend.userName,friend.message]];
		}
	}
	return data;
}

//收到添加好友请求代理方法.
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
	
	//如果数据库已经存在某个好友的请求则不加入数据库.是好友也不能添加好友.
	if (![[DataBaseTools SharedInstance] isExitsUserWithName:aUsername]||[self isFriend:aUsername]) {
		FriendsInvitation *friend = [[FriendsInvitation alloc] init];
		friend.userName = aUsername;
		friend.message = aMessage;
		[[DataBaseTools SharedInstance] addPerson:friend];
	}
	//数据库在注销的时候关闭.
}

//判断是否是好友.
- (BOOL)isFriend:(NSString *)name{
	BOOL flag = NO;
	
	NSArray *userList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:nil];
	
	for (NSString *user in userList) {
		if ([user isEqualToString:name]) {
			flag = YES;
		}
	}
	
	return YES;
}

@end









