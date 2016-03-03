//
//  DataBaseTools.m
//  MyDataBase
//
//  Created by lanou3g on 15/12/31.
//  Copyright © 2015年 吴文涛. All rights reserved.
//

#import "DataBaseTools.h"
#import "FriendsInvitation.h"

static DataBaseTools *handler;
@implementation DataBaseTools
+(instancetype)SharedInstance{
    if (handler==nil) {
        handler = [[DataBaseTools alloc] init];
		[handler openDataBase];
		[handler createTable];
    }
    return handler;
}

static sqlite3 *dataBase;

- (void)openDataBase{
    //获取文件路径以及数据库路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *path = [docPath stringByAppendingString:@"/FriendsInvitation.sqlite"];
    NSLog(@"%@",path);
    int result = sqlite3_open(path.UTF8String, &dataBase);
    if (result==SQLITE_OK) {
        NSLog(@"open ok");
    }else{
        NSLog(@"open error");
    }
    
    
    
}
- (void)closeDataBase{
    
    int result = sqlite3_close(dataBase);
    if (result==SQLITE_OK) {
        NSLog(@"close ok");
    }else{
        NSLog(@"close error");
    }
    
}

- (void)createTable{
    NSString *sql =@"CREATE  TABLE IF NOT EXISTS FreindsInvitation (pid INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , userName TEXT NOT NULL , message TEXT NOT NULL)";
    
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败%d",result);
    }
    
    
    
}
- (void)addPerson:(FriendsInvitation *)person{
    NSString *sql = [NSString stringWithFormat:@"insert into FreindsInvitation (userName,message) values('%@','%@')",person.userName,person.message];
    
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"add成功");
    }else{
        NSLog(@"add失败%d",result);
    }
    
    
}
- (void)delPersonByPid:(NSInteger)pid{
    NSString *sql = [NSString stringWithFormat:@"delete from FreindsInvitation where pid = %ld ",pid];
    
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"delete成功");
    }else{
        NSLog(@"delete失败%d",result);
    }
    
}
- (void)updatePerson:(NSString *)name byPid:(NSInteger)pid{
    NSString *sql = [NSString stringWithFormat:@"update FreindsInvitation set userName='%@' where pid=%ld",name,pid];
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    
    if (result==SQLITE_OK) {
        NSLog(@"update成功");
    }else{
        NSLog(@"update失败%d",result);
    }
    
}
- (NSArray<FriendsInvitation *>*)showAllPerson{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = @"select * from FreindsInvitation";
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare(dataBase, sql.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            FriendsInvitation *p = [[FriendsInvitation alloc] init];
//            p.pid = sqlite3_column_int(stmt, 0);
            p.userName = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
            p.message = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt,2)];
            [arr addObject:p];
        }
    }
    sqlite3_finalize(stmt);
    return arr;
}
//- (FriendsInvitation *)findPersonBypid:(NSInteger)pid{
//    FriendsInvitation *p = [[FriendsInvitation alloc] init];
//    
//    //sqlite3_stmt *stmt = NULL;
//    NSArray *arr = [self showAllPerson];
//    NSLog(@"%@",arr);
//    for (FriendsInvitation *p1 in arr) {
//        NSLog(@"%ld",p1.pid);
//        if (p1.pid==pid) {
//            p = p1;
//        }
//    }
//    return p;
//}

- (void)bindPerson:(FriendsInvitation *)person{
    NSString *sql = @"INSERT INTO FreindsInvitation (userName,message) VALUES (?,?)";
    
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare(dataBase, sql.UTF8String, -1, &stmt, NULL);
    //NSLog(@"%@====%@=====%ld",person.name,person.sex,person.age);
    if (result==SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, person.userName.UTF8String, -1, NULL);
        sqlite3_bind_text(stmt, 2, person.message.UTF8String, -1, NULL);
        if(sqlite3_step(stmt)){
            NSLog(@"ok");
        }else{
            NSLog(@"error");
        }
    }else{
        NSLog(@"sql is wrong %d",result);
    }
    
    sqlite3_finalize(stmt);
    
    
    
//    //生成sql语句
//    NSString *sql = @"INSERT INTO Persons (name,sex,age) VALUES (?,?,?)";
//    //创建游标
//    sqlite3_stmt *stmt = NULL;
//    //预执行
//    int result = sqlite3_prepare(dataBase, sql.UTF8String, -1, &stmt, NULL);
//    
//    if (result==SQLITE_OK) {
//        //绑定参数
//        sqlite3_bind_text(stmt, 1, person.name.UTF8String, -1, NULL);
//        sqlite3_bind_text(stmt, 2, person.sex.UTF8String, -1, NULL);
//        sqlite3_bind_int(stmt, 3, (int)person.age);
//        
//        //游标下移进行过滤
//        if(sqlite3_step(stmt)){
//            NSLog(@"插入数据成功");
//        }else{
//            NSLog(@"插入数据失败");
//        }
//    }else{
//        NSLog(@"sql is wrong");
//    }
//    sqlite3_finalize(stmt);
}


@end






















