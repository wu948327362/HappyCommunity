//
//  ContactManager.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactManager : NSObject

+ (instancetype)shareInstance;

- (NSMutableArray *)dataForFlag:(NSInteger)flag;

@end
