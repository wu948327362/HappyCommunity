//
//  LoginController.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController
+ (instancetype)shareInstance;
//将密码输入框置为空
- (void)clearPassword;
@end
