//
//  LoginAnimatino.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/5.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoginAnimatino : NSObject
//使登陆界面的两条线从中间开始往外长.
+ (void)labelAnimationWithLabel:(NSLayoutConstraint *)constraint view:(UIView *)view;

//注册按钮的animation
+ (void)btnAnimationWithBtn:(UIButton *)btn view:(UIView *)view;
@end
