//
//  CloudManager.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CloudManager.h"
#import "EMSDK.h"

static CloudManager *manager = nil;
@implementation CloudManager

+ (instancetype)shareInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[CloudManager alloc] init];
	});
	return manager;
}

//保存用户icon头像
- (void)saveUserIconWithPath:(NSString *)filePath{
	
	AVObject *userNameAndIcon = [AVObject objectWithClassName:@"UserNameAndIcon"];
	
	[userNameAndIcon setObject:[[EMClient sharedClient] currentUsername] forKey:@"userName"];
	
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	
	AVFile *icon = [AVFile fileWithData:data];
	
	[icon saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		//avfile文件上传完成后
		if (icon!=nil) {
			[userNameAndIcon setObject:icon forKey:@"userIcon"];
			[userNameAndIcon saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				NSLog(@"%@",error);
			}];
		}
		
	}];
	
}

//更新用户头像
- (void)updateWithPath:(NSString *)filePath{
	
	[self findUserByName:[[EMClient sharedClient] currentUsername] finish:^(AVObject *obj) {
		AVFile *newIcon = [self saveIconFileWithPath:filePath];
		if (obj!=nil) {
			[obj setObject:newIcon forKey:@"userIcon"];
		}
	}];
	
	
}

//存储用户的AVFile
- (AVFile *)saveIconFileWithPath:(NSString *)filePath{
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	
	AVFile *icon = [AVFile fileWithData:data];
	
	[icon saveInBackground];
	return icon;
}

//根据用户名返回用户
- (void)findUserByName:(NSString *)name finish:(void(^)(AVObject *obj))finish{
	
	AVQuery *query = [AVQuery queryWithClassName:@"UserNameAndIcon"];
	[query whereKey:@"userName" equalTo:name];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		finish([objects firstObject]);
	}];
	
}

//根据用户名查询用户头像
- (void)getUserIconByName:(NSString *)name finish:(void(^)(UIImage *findImage))finish{
	
	[self findUserByName:name finish:^(AVObject *obj) {
		
		AVObject *user = obj;
		AVFile *icon = [user objectForKey:@"userIcon"];
		
		NSData *data = [icon getData];
		
		UIImage *findImage = [UIImage imageWithData:data];
		finish(findImage);
	}];
	
}

@end















