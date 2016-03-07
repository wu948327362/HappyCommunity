//
//  ChatController.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatController : UIViewController
@property(nonatomic,copy)NSString *receiverId;
//传进来的flag0表示单聊,1表示群聊.
@property(nonatomic,assign)NSInteger flag;
@end
