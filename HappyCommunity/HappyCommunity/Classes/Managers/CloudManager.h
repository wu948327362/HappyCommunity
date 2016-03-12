//
//  CloudManager.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface CloudManager : NSObject

+ (instancetype)shareInstance;

//保存用户icon头像
- (void)saveUserIconWithPath:(NSString *)filePath;

//更新用户头像
- (void)updateWithPath:(NSString *)filePath;

//根据用户名查询用户头像
- (void)getUserIconByName:(NSString *)name finish:(void(^)(UIImage *findImage))finish;

//存储用户的AVFile
- (AVFile *)saveIconFileWithPath:(NSString *)filePath;

//根据用户名返回用户
- (void)findUserByName:(NSString *)name finish:(void(^)(AVObject *obj))finish;


@end
