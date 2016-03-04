//
//  LaughTableViewCell.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/3.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LaughModel;
@interface LaughTableViewCell : UITableViewCell

@property(nonatomic, strong)LaughModel *model;

@property(nonatomic, strong)UIImageView *photoView;


- (CGFloat)heightForCell:(LaughModel *)model;
@end
