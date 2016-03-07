//
//  ChatTableViewCell.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/4.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chatLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;

@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property(nonatomic,strong)ChatModel *chatModel;

@property (weak, nonatomic) IBOutlet UILabel *leftName;

@property (weak, nonatomic) IBOutlet UILabel *rightName;

@end










