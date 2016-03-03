//
//  DataBaseTools.h
//  MyDataBase
//
//  Created by lanou3g on 15/12/31.
//  Copyright © 2015年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class FriendsInvitation;
@interface DataBaseTools : NSObject
//单例
+ (instancetype)SharedInstance;

- (void)openDataBase;
- (void)closeDataBase;
- (void)createTable;
- (void)addPerson:(FriendsInvitation *)person;
- (void)delPersonByPid:(NSInteger)pid;
- (void)updatePerson:(NSString *)name byPid:(NSInteger)pid;
- (NSArray<FriendsInvitation *>*)showAllPerson;
//- (FriendsInvitation *)findPersonBypid:(NSInteger)pid;
- (void)bindPerson:(FriendsInvitation *)person;

@end
