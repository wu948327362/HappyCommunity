//
//  NewsView.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "NewsView.h"

@implementation NewsView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setView];
	}
	return self;
}

- (void)setView{
	self.backgroundColor = [UIColor greenColor];
}

@end
