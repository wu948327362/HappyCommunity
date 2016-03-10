//
//  MessageModel+CoreDataProperties.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/3.
//  Copyright © 2016年 吴文涛. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *direction;
@property (nullable, nonatomic, retain) NSString *messageId;
@property (nullable, nonatomic, retain) NSString *conversationId;
@property (nullable, nonatomic, retain) NSString *from;
@property (nullable, nonatomic, retain) NSString *to;
@property (nullable, nonatomic, retain) NSNumber *timestamp;
@property (nullable, nonatomic, retain) NSNumber *chatType;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *isReadAcked;
@property (nullable, nonatomic, retain) NSNumber *isDeliverAcked;
@property (nullable, nonatomic, retain) NSNumber *isRead;

@end

NS_ASSUME_NONNULL_END
