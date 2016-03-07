//
//  ChatTableViewCell.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/4.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

//重写model的set属性
- (void)setChatModel:(ChatModel *)chatModel{
	_chatLabel.text = chatModel.chatText;
	_chatLabel.numberOfLines = 0;
	_chatLabel.font = [UIFont systemFontOfSize:25];
	
	CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 1000);
	
	NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:25]};
	CGRect rect = [chatModel.chatText boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];
	
	CGRect frame = self.chatLabel.frame;
	frame.size = rect.size;
	self.chatLabel.frame = frame;
	
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
