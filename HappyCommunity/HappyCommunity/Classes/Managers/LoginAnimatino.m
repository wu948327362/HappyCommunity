//
//  LoginAnimatino.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/5.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "LoginAnimatino.h"


static CGFloat bottomLineWidth = 275;
@implementation LoginAnimatino

+ (void)labelAnimationWithLabel:(NSLayoutConstraint *)constraint view:(UIView *)view{
	constraint.constant = bottomLineWidth;
	
	[UIView animateWithDuration:1.5 animations:^{
		[view layoutIfNeeded];
	}];
}

+ (void)btnAnimationWithBtn:(UIButton *)btn view:(UIView *)view{
	[UIView animateWithDuration:1.5 animations:^{
		btn.transform = CGAffineTransformIdentity;
	}];
}

@end
