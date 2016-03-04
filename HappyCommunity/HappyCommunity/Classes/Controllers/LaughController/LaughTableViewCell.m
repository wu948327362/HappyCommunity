//
//  LaughTableViewCell.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/3.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "LaughTableViewCell.h"
#import "LaughModel.h"
#import "UIImageView+WebCache.h"
@interface LaughTableViewCell ()
@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, assign)CGFloat photoW;
@property(nonatomic, assign)CGFloat photoH;
@end
@implementation LaughTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setModel:(LaughModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.photoH = [model.imageHeight floatValue];
    self.photoW = [model.imageWidth floatValue];
    NSLog(@"%f",self.photoH);
    
}
- (void)setupView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.contentView.bounds) - 20, 30)];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.photoView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.photoView];
}
- (CGFloat)heightForCell:(LaughModel *)model
{
    return self.photoH + 50;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
