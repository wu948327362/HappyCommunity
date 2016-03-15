//
//  FriendsInvitation.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsInvitation : NSObject
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,assign)NSInteger friendOrGroup;
@property(nonatomic,copy)NSString *addWhoName;
@end
