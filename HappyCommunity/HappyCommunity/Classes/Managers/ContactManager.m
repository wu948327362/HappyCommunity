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

@implementation ContactManager

+ (instancetype)shareInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[ContactManager alloc] init];
	});
	return manager;
}

- (NSMutableArray *)dataForFlag:(NSInteger)flag{
	NSMutableArray *arr = [NSMutableArray array];
	NSArray *array = [NSArray array];
	
	switch (flag) {
		case 0:
			array = [[EMClient sharedClient].contactManager getContactsFromServerWithError:nil];
			arr = [self getNameArray:array flag:0];
			break;
		case 1:
			array = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:nil];
			arr = [self getNameArray:array flag:1];
			break;
		case 2:
			array = [[EMClient sharedClient].groupManager getAllGroups];
			arr = [self getNameArray:array flag:2];
			break;
		case 3:
			//按时没有用户请求需要自己去做.
			array = [[DataBaseTools SharedInstance] showAllPerson];
			arr = [self getNameArray:array flag:3];
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
			[data addObject:group.owner];
		}
	}else if (flag==4){
		for (FriendsInvitation *friend in arr) {
			[data addObject:friend.userName];
		}
	}else if(flag==1){
		
	}
	return data;
}

@end









