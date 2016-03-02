//
//  NewTableViewCell.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "NewTableViewCell.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
@interface NewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end
@implementation NewTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 20, 20, CGRectGetWidth([UIScreen mainScreen].bounds) - 60 - CGRectGetWidth(self.photoView.frame) , CGRectGetHeight(self.photoView.frame))];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
}
- (void)setModel:(NewsModel *)Model
{
    _Model = Model;
    NSLog(@"%@",Model);
    self.titleLabel.text = Model.itemTitle;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:Model.imgUrl1]];
    NSString *temp = Model.itemTitle;
    CGSize size = CGSizeMake(CGRectGetWidth(self.titleLabel.frame), 20000);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [temp boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = rect.size.height;
    self.titleLabel.frame = frame;
    
    
}

//- (CGFloat)heightForCell:(NewsModel *)model
//{
//    CGSize size = CGSizeMake(CGRectGetWidth(_titleLabel.frame), 20000);
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
//    CGRect rect = [model.itemTitle boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    return rect.size.height + 100;
//
//}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
