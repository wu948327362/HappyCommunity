//
//  LaughView.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "LaughView.h"

@implementation LaughView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setView];
	}
	return self;
}

- (void)setView{
	self.backgroundColor = [UIColor redColor];
}

@end
