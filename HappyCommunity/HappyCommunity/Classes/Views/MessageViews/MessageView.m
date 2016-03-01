//
//  MessageView.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setView];
	}
	return self;
}

- (void)setView{
	self.backgroundColor = [UIColor yellowColor];
	
	self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
	[self addSubview:self.tableView];
	
}

@end
