//
//  MyEMManager.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/5.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSDK.h"
#import <UIKit/UIKit.h>

@interface MyEMManager : NSObject
+ (instancetype)shareInstance;

//添加好友进群
- (UIAlertController *)addToGroup:(NSString *)receiveId;

//发送消息
- (void)sendMessageWithReceiveId:(NSString *)receiveId message:(NSString *)messge flag:(NSInteger)flag finish:(void(^)())finish;

//登陆
- (void)LoginWithName:(NSString *)name password:(NSString *)password finish:(void(^)(EMError *err))finish;

//注册
- (void)RegisterWithName:(NSString *)name password:(NSString *)password finish:(void(^)(EMError *err))finish;

//添加好友
- (void)addFriendWithName:(NSString *)name message:(NSString *)message finish:(void(^)(EMError *err))finish;

//创建群组
- (void)addGroupWithName:(NSString *)name message:(NSString *)message finish:(void(^)(EMError *err))finish;

@end














