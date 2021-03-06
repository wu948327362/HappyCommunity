//
//  DataBaseTools.m
//  MyDataBase
//
//  Created by lanou3g on 15/12/31.
//  Copyright © 2015年 吴文涛. All rights reserved.
//

#import "DataBaseTools.h"
#import "FriendsInvitation.h"

#import "AppDelegate.h"
#import "MessageModel.h"
#import "CloudManager.h"
#import "ContactManager.h"

static DataBaseTools *handler;

@interface DataBaseTools ()<EMChatManagerDelegate,EMGroupManagerDelegate,EMContactManagerDelegate>
@property(nonatomic,strong)NSCache *cache;
@end

@implementation DataBaseTools
+(instancetype)SharedInstance{
    if (handler==nil) {
        handler = [[DataBaseTools alloc] init];
		
		[handler openDataBase];
		[handler createTable];
		//设置接收消息代理,并设置接受消息代理方法.
		[[EMClient sharedClient].chatManager addDelegate:handler delegateQueue:nil];
		[[EMClient sharedClient].groupManager addDelegate:handler delegateQueue:nil];
		AppDelegate *app = [UIApplication sharedApplication].delegate;
		handler.context = app.managedObjectContext;
		handler.cache = [[NSCache alloc] init];
		[[EMClient sharedClient].contactManager addDelegate:handler delegateQueue:nil];
    }
    return handler;
}

////重写init方法
//- (instancetype)init{
//	self = [super init];
//	if (self) {
//		[self initProperties];
//	}
//	return self;
//}
//
//- (void)initProperties{
//	[self openDataBase];
//	[self createTable];
//	//设置接收消息代理,并设置接受消息代理方法.
//	[[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//	[[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
//	AppDelegate *app = [UIApplication sharedApplication].delegate;
//	self.context = app.managedObjectContext;
//}

static sqlite3 *dataBase;

- (void)openDataBase{
    //获取文件路径以及数据库路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *path = [docPath stringByAppendingString:@"/NewFriendsInvitation.sqlite"];
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
    NSString *sql =@"CREATE  TABLE IF NOT EXISTS NewFriendsInvitation (pid INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , userName TEXT NOT NULL , message TEXT NOT NULL , addWhoName TEXT NOT NULL, friendOrGroup INTEGER NOT NULL)";
    
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败%d",result);
    }
    
    
    
}
- (void)addPerson:(FriendsInvitation *)person{
    NSString *sql = [NSString stringWithFormat:@"insert into NewFriendsInvitation (userName,message,friendOrGroup,addWhoName) values('%@','%@',%d,'%@')",person.userName,person.message,0,[[EMClient sharedClient] currentUsername]];
	NSLog(@"%@",sql);
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"add成功");
    }else{
        NSLog(@"add失败%d",result);
    }
}

- (void)addGroup:(FriendsInvitation *)person{
	NSString *sql = [NSString stringWithFormat:@"insert into NewFriendsInvitation (userName,message,friendOrGroup,addWhoName) values('%@','%@',%d,'%@')",person.userName,person.message,1,[[EMClient sharedClient] currentUsername]];
	
	int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
	if (result==SQLITE_OK) {
		NSLog(@"add成功");
	}else{
		NSLog(@"add失败%d",result);
	}
}

- (void)delPersonByPid:(NSInteger)pid{
    NSString *sql = [NSString stringWithFormat:@"delete from NewFriendsInvitation where pid = %ld ",(long)pid];
    
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"delete成功");
    }else{
        NSLog(@"delete失败%d",result);
    }
    
}

- (void)delPersonByName:(NSString *)name{
	NSString *sql = [NSString stringWithFormat:@"delete from NewFriendsInvitation where userName = '%@' ",name];
	
	int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
	if (result==SQLITE_OK) {
		NSLog(@"delete成功");
	}else{
		NSLog(@"delete失败%d",result);
	}
	
}

- (void)updatePerson:(NSString *)name byPid:(NSInteger)pid{
    NSString *sql = [NSString stringWithFormat:@"update NewFriendsInvitation set userName='%@' where pid=%ld",name,(long)pid];
    int result = sqlite3_exec(dataBase, sql.UTF8String, NULL, NULL, NULL);
    
    if (result==SQLITE_OK) {
        NSLog(@"update成功");
    }else{
        NSLog(@"update失败%d",result);
    }
    
}
- (NSArray<FriendsInvitation *>*)showAllPerson{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = @"select * from NewFriendsInvitation";
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare(dataBase, sql.UTF8String, -1, &stmt, NULL);
    
    if (result==SQLITE_OK) {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            FriendsInvitation *p = [[FriendsInvitation alloc] init];
//            p.pid = sqlite3_column_int(stmt, 0);
            p.userName = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 1)];
            p.message = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt,2)];
			p.addWhoName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt,3)];
			p.friendOrGroup = sqlite3_column_int(stmt, 4);
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
    NSString *sql = @"INSERT INTO NewFriendsInvitation (userName,message) VALUES (?,?)";
    
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
}

//是否存在用户名为name的用户
- (BOOL)isExitsUserWithName:(NSString *)name{
	
	BOOL flag = NO;
	NSArray *arr = [self showAllPerson];
	
	for (FriendsInvitation *friends in arr) {
		if ([friends.userName isEqualToString:name]) {
			flag = YES;
		}
	}
	return flag;
}

//找出自己的用户请求
- (NSMutableArray *)getMyRequest{
	NSMutableArray *arr = [NSMutableArray array];
	
	NSArray *array = [self showAllPerson];
	
	for (FriendsInvitation *friend in array) {
		if ([friend.addWhoName isEqualToString:[[EMClient sharedClient] currentUsername]]) {
			[arr addObject:friend];
		}
		
		for (NSString *group in [[ContactManager shareInstance] getGroupContainsMe]) {
			NSArray *a = [group componentsSeparatedByString:@":"];
			if ([friend.userName isEqualToString:[a firstObject]]) {
				[arr addObject:friend];
			}
		}
		
	}
	
	return arr;
	
}

#pragma mark - 接收到消息函数回调
- (void)didReceiveMessages:(NSArray *)aMessages{
	
	for (EMMessage *message in aMessages) {
		[self saveMessageModelWith:message];
	}
	
}

//根据EMMessage返回MessageModel
- (void)saveMessageModelWith:(EMMessage *)message{
	
	NSEntityDescription *description = [NSEntityDescription entityForName:@"MessageModel" inManagedObjectContext:handler.context];
	MessageModel *model = [[MessageModel alloc] initWithEntity:description insertIntoManagedObjectContext:handler.context];
	
	model.text = ((EMTextMessageBody *)message.body).text;
	model.direction = [NSNumber numberWithInteger:message.direction];
	model.messageId = message.messageId;
	model.conversationId = message.conversationId;
	model.from = message.from;
	model.to = message.to;
	model.timestamp = [NSNumber numberWithLongLong:message.timestamp];
	model.chatType = [NSNumber numberWithInteger:message.chatType];
	model.status = [NSNumber numberWithInteger:message.status];
	model.isReadAcked = [NSNumber numberWithInteger:message.isReadAcked];
	model.isRead = [NSNumber numberWithInteger:message.isRead];
	model.isDeliverAcked = [NSNumber numberWithInteger:message.isDeliverAcked];
	
	NSLog(@"%@====%@=====%d",message.from,message.to,message.direction);
	
	[handler.context save:nil];
}

//根据用户名返回查询数组结果
- (NSMutableArray *)messagesWithReceiverId:(NSString *)receiverId from:(NSString *)currentUser flag:(NSInteger)flag{
	
	NSMutableArray *data = [NSMutableArray array];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageModel" inManagedObjectContext:handler.context];
	[fetchRequest setEntity:entity];
	// Specify criteria for filtering which objects to fetch
	if (flag==0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(from==%@ AND to==%@) OR (from==%@ AND to==%@)",currentUser,receiverId,receiverId,currentUser];
		[fetchRequest setPredicate:predicate];
	}else if(flag==1){
		NSArray *arr = [receiverId componentsSeparatedByString:@":"];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"to==%@",[arr firstObject]];
		[fetchRequest setPredicate:predicate];
	}
	fetchRequest.fetchLimit = 10;
	
	// Specify how the fetched objects should be sorted
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
	
	NSError *error = nil;
	NSArray *fetchedObjects = [handler.context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		return nil;
	}
	
	for (MessageModel *model in fetchedObjects) {
		[data addObject:model];
	}
	return data;
	
}

//收到添加好友请求代理方法.
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
	
	//如果数据库已经存在某个好友的请求则不加入数据库.是好友也不能添加好友.
	if (!([self isExitsUserWithName:aUsername]||[self isFriend:aUsername])) {
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

//收到某人的加群申请.如果是好友则默认可以进入该群在否则等待群主的验证.
- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup applicant:(NSString *)aApplicant reason:(NSString *)aReason{
	
	//判断是否是好友.
//	BOOL isFriend = [handler isExitsUserWithName:aApplicant];
//	
//	if (isFriend) {
//		[[EMClient sharedClient].groupManager addOccupants:@[aApplicant] toGroup:aGroup.groupId welcomeMessage:nil error:nil];
//	}else{
		FriendsInvitation *frienInvitation = [[FriendsInvitation alloc] init];
		frienInvitation.userName = aApplicant;
		frienInvitation.message = [NSString stringWithFormat:@"%@:%@",aReason,aGroup.groupId];
		frienInvitation.friendOrGroup = 1;
		[handler addGroup:frienInvitation];
//	}
	
}

//获取文件(Documents)路径,然后设置图片缓存路径.
- (NSString *)filePathWithName:(NSString *)name{
	if (![name isEqualToString:@""]) {
		//设置图片缓存路径
		NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
		NSString *filePath = [docPath stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
		return filePath;
	}else{
		return nil;
	}
	
}

//获取缓存的图片
- (UIImage *)getCachePictureWithName:(NSString *)name{
	
	//获取图片缓存路径
	NSString *filePath = [self filePathWithName:name];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	
	return [UIImage imageWithData:data];
	
	
}

//缓存图片
- (void)cachePictureWithImage:(UIImage *)image andName:(NSString *)name{
	
	//根据图片缓存路径,缓存图片
	NSString *filePath = [self filePathWithName:name];
//	[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
	NSData *data = UIImagePNGRepresentation(image);
	
	[data writeToFile:filePath atomically:NO];
	
}

//缓存图片
- (void)cacheImageWithImage:(UIImage *)image andKey:(NSString *)key{
	NSData *data = UIImagePNGRepresentation(image);
	
	NSString *filePath = [self filePathWithName:key];
	
	[self.cache setObject:data forKey:key];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
		
	});
	
}

//读取图片
- (UIImage *)imageForKey:(NSString *)key{
	
	if (key==nil) {
		return nil;
	}
	
	NSData *data = [_cache objectForKey:key];
	if (data) {
		return [UIImage imageWithData:data];
	}else{
		NSString *filePath = [self filePathWithName:key];
		data = [[NSFileManager defaultManager] contentsAtPath:filePath];
		
		if (data) {
			[_cache setObject:data forKey:key];
		}
		return [UIImage imageWithData:data];
	}
	
}

@end






















