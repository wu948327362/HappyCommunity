//
//  ChatMessageModel.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/3.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageModel : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,assign)NSInteger direction;
@property(nonatomic,copy)NSString *messageId;
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic) long long timestamp;

@end
