//
//  CalendarCollectionCell.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CalendarCollectionCell.h"
#import "CalendarDayModel.h"
#import "Color.h"
@implementation CalendarCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView
{
    //照片
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, self.bounds.size.width- 10, self.bounds.size.width- 10)];
    photoView.image = [UIImage imageNamed:@"chack"];
    [self.contentView addSubview:photoView];
    
    //阳历
    day_lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width - 10)];
    day_lab.textAlignment = NSTextAlignmentCenter;
//    day_lab.backgroundColor = [UIColor blackColor];
    day_lab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:day_lab];
    
    //阴历
    day_title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 15 , self.bounds.size.width, 15)];
    day_title.textColor = [UIColor lightGrayColor];
    day_title.textAlignment = NSTextAlignmentCenter;
    day_title.font = [UIFont boldSystemFontOfSize:10];
    [self.contentView addSubview:day_title];
    
}

//重写model的set方法
- (void)setModel:(CalendarDayModel *)model
{
    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_Yes];
            break;
        case CellDayTypePast://过去的日期
            [self hidden_No];
            if (model.holiday) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%ld", model.day];
            }
            day_lab.textColor = [UIColor lightGrayColor];
            day_title.text = model.chinese_Calendar;
            photoView.hidden = YES;
            break;
        case CellDayTypeFutur://将来的日期
            [self hidden_No];
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%ld", model.day];
                day_lab.textColor = COLOR_THEME;
            }
            day_title.text = model.chinese_Calendar;
            photoView.hidden = YES;
            break;
        case CellDayTypeWeek://周末
            [self hidden_No];
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%ld", model.day];
                day_lab.textColor = [UIColor colorWithRed:0.0 green:0.7505 blue:0.9991 alpha:1.0];
            }
            day_title.text = model.chinese_Calendar;
            photoView.hidden = YES;
            break;
        case CellDayTypeClick://被点击的日期
            [self hidden_No];
            day_lab.text = [NSString stringWithFormat:@"%ld", model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.chinese_Calendar;
            photoView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)hidden_Yes
{
    day_lab.hidden = YES;
    day_title.hidden = YES;
    photoView.hidden = YES;
}

- (void)hidden_No
{
    day_lab.hidden = NO;
    day_title.hidden = NO;
}
- (void)layoutSubviews{
    //对imageView的大小进行调整.
    //1.拿到imageView的大小.
    CGRect frame1 = photoView.frame;
    //2.拿到当前item的大小.
    CGRect frame = self.frame;
    
    //3.修改数据并设置回去.
    frame1.size = frame.size;
    
    photoView.frame = frame1;
}

@end
