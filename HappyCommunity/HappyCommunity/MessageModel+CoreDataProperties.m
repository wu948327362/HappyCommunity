//
//  MessageModel+CoreDataProperties.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/3.
//  Copyright © 2016年 吴文涛. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MessageModel+CoreDataProperties.h"

@implementation MessageModel (CoreDataProperties)

@dynamic text;
@dynamic direction;
@dynamic messageId;
@dynamic conversationId;
@dynamic from;
@dynamic to;
@dynamic timestamp;
@dynamic chatType;
@dynamic status;
@dynamic isReadAcked;
@dynamic isDeliverAcked;
@dynamic isRead;

@end
