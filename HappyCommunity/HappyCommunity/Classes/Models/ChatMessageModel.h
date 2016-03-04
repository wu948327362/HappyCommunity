//
//  ChatMessageModel.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/3.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSDK.h"

@interface ChatMessageModel : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,assign)NSInteger direction;
@property(nonatomic,copy)NSString *messageId;
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic) long long timestamp;
@property (nonatomic) EMChatType chatType;
@property (nonatomic) EMMessageStatus status;
@property (nonatomic) BOOL isReadAcked;
@property (nonatomic) BOOL isDeliverAcked;
@property (nonatomic) BOOL isRead;
@property (nonatomic, copy) NSDictionary *ext;

@end
