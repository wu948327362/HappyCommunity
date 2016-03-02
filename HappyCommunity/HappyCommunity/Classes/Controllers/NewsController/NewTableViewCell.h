//
//  NewTableViewCell.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@interface NewTableViewCell : UITableViewCell
@property(nonatomic, strong)NewsModel *Model;
@property (nonatomic, strong)UILabel *titleLabel;
- (CGFloat)heightForCell:(NewsModel *)model;
@end
