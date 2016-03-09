//
//  DataBaseTools.h
//  MyDataBase
//
//  Created by lanou3g on 15/12/31.
//  Copyright © 2015年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "EMSDK.h"
#import <UIKit/UIKit.h>

@class FriendsInvitation;
@interface DataBaseTools : NSObject
//单例
+ (instancetype)SharedInstance;

//打开数据库
- (void)openDataBase;
//关闭数据库
- (void)closeDataBase;
//创建表,只执行一次
- (void)createTable;
//根据FriendsInvitation添加
- (void)addPerson:(FriendsInvitation *)person;
//根据FriendsInvitation添加
- (void)addGroup:(FriendsInvitation *)person;
//根据pid删除
- (void)delPersonByPid:(NSInteger)pid;
//根据name删除
- (void)delPersonByName:(NSString *)name;
//根据pid更新name
- (void)updatePerson:(NSString *)name byPid:(NSInteger)pid;
//返回所有好友请求
- (NSArray<FriendsInvitation *>*)showAllPerson;
//- (FriendsInvitation *)findPersonBypid:(NSInteger)pid;
- (void)bindPerson:(FriendsInvitation *)person;

//查找用户名是否存在
- (BOOL)isExitsUserWithName:(NSString *)name;

//根据两个聊天的用户的名字返回他们聊天记录的models
- (NSMutableArray *)messagesWithReceiverId:(NSString *)receiverId from:(NSString *)currentUser flag:(NSInteger)flag;

//保存两个人的;聊天记录
- (void)saveMessageModelWith:(EMMessage *)message;

//获取缓存的图片
- (id)getCachePictureWithName:(NSString *)name;

//缓存图片
- (void)cachePictureWithImage:(UIImage *)image andName:(NSString *)name;

//coreData
@property(nonatomic,strong)NSManagedObjectContext *context;

@end










