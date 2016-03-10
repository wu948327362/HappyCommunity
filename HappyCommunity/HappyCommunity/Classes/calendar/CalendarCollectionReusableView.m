//
//  CalendarCollectionReusableView.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CalendarCollectionReusableView.h"
#import "Color.h"
#define CATDayLabelWidth  self.bounds.size.width / 7
#define CATDayLabelHeight 20.0f
@interface CalendarCollectionReusableView ()
@property(nonatomic, strong)UILabel *week1;//星期日的label
@property(nonatomic, strong)UILabel *week2;//星期一的label
@property(nonatomic, strong)UILabel *week3;//星期二的label
@property(nonatomic, strong)UILabel *week4;//星期三的label
@property(nonatomic, strong)UILabel *week5;//星期四的label
@property(nonatomic, strong)UILabel *week6;//星期五的label
@property(nonatomic, strong)UILabel *week7;//星期六的label


@end
@implementation CalendarCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        // Initialization code
//        [self setup];
//    }
//    return self;
//}

- (void)setup
{
    self.clipsToBounds = YES;//剪裁超过父视图的部分
    
    //month
    self.masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    [self.masterLabel setBackgroundColor:[UIColor clearColor]];
    [self.masterLabel setTextAlignment:NSTextAlignmentCenter];
    [self.masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    self.masterLabel.textColor = COLOR_THEME;
    [self addSubview:self.masterLabel];
    CGFloat xOffset = self.bounds.size.width / 7;
    CGFloat yOffset = 45.0f;
    
    //一，二，三，四，五，六，日
    self.week1 = [[UILabel alloc]initWithFrame:CGRectMake(0,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week1 setBackgroundColor:[UIColor clearColor]];
    [self.week1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week1.textAlignment = NSTextAlignmentCenter;
    self.week1.textColor = COLOR_THEME1;
    [self addSubview:self.week1];
    
    self.week2 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week2 setBackgroundColor:[UIColor clearColor]];
    [self.week2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week2.textAlignment=NSTextAlignmentCenter;
    self.week2.textColor = COLOR_THEME;
    [self addSubview:self.week2];
    
    xOffset += CATDayLabelWidth;
    self.week3 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week3 setBackgroundColor:[UIColor clearColor]];
    [self.week3 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week3.textAlignment=NSTextAlignmentCenter;
    self.week3.textColor = COLOR_THEME;
    [self addSubview:self.week3];
    
    xOffset += CATDayLabelWidth;
    self.week4 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week4 setBackgroundColor:[UIColor clearColor]];
    [self.week4 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week4.textAlignment=NSTextAlignmentCenter;
    self.week4.textColor = COLOR_THEME;
    [self addSubview:self.week4];
    
    xOffset += CATDayLabelWidth ;
    self.week5 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week5 setBackgroundColor:[UIColor clearColor]];
    [self.week5 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week5.textAlignment=NSTextAlignmentCenter;
    self.week5.textColor = COLOR_THEME;
    [self addSubview:self.week5];
    
    xOffset += CATDayLabelWidth ;
    self.week6 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week6 setBackgroundColor:[UIColor clearColor]];
    [self.week6 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week6.textAlignment=NSTextAlignmentCenter;
    self.week6.textColor = COLOR_THEME;
    [self addSubview:self.week6];
    
    xOffset += CATDayLabelWidth ;
    self.week7 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
    [self.week7 setBackgroundColor:[UIColor clearColor]];
    [self.week7 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    self.week7.textAlignment=NSTextAlignmentCenter;
    self.week7.textColor = COLOR_THEME1;
    [self addSubview:self.week7];
    
    [self fileNameOnTheLabelWith:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
//    //日，一，二，三，四，五，六
//    CGFloat masterLabelY = CGRectGetMaxY(self.masterLabel.frame);
////    CGFloat offsetX = 5;
//    CGFloat offsetY = masterLabelY + 10;
//    self.week1 = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, CGRectGetWidth([UIScreen mainScreen].bounds)/7, LabelHeight)];
//    self.week1.textAlignment = NSTextAlignmentCenter;
//    self.week1.textColor = [UIColor colorWithRed:1.0 green:0.1691 blue:0.0504 alpha:1.0];
//    [self addSubview:self.week1];
//    
//    [self getLabel:self.week2 withFram:CGRectMake(LabelWidth, offsetY, LabelWidth, LabelHeight)];
//    [self getLabel:self.week3 withFram:CGRectMake(LabelWidth * 2, offsetY, LabelWidth, LabelHeight)];
//    [self getLabel:self.week4 withFram:CGRectMake(LabelWidth * 3, offsetY, LabelWidth, LabelHeight)];
//    [self getLabel:self.week5 withFram:CGRectMake(LabelWidth * 4, offsetY, LabelWidth, LabelHeight)];
//    [self getLabel:self.week6 withFram:CGRectMake(LabelWidth * 5, offsetY, LabelWidth, LabelHeight)];
//    [self getLabel:self.week7 withFram:CGRectMake(LabelWidth * 6, offsetY, LabelWidth, LabelHeight)];
//    
//    [self fileNameOnTheLabelWith:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
}
//
//- (void)getLabel:(UILabel *)label withFram:(CGRect)rect
//{
//    
//    label = [[UILabel alloc]initWithFrame:rect];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor colorWithRed:0.3619 green:0.9681 blue:1.0 alpha:1.0];
//    [self addSubview:label];
//}

- (void)fileNameOnTheLabelWith:(NSArray *)nameArray
{
    for (int i = 0; i < nameArray.count; i++) {
        switch (i) {
            case 0:
                self.week1.text = nameArray[i];
                break;
            case 1:
                self.week2.text = nameArray[i];
                break;
            case 2:
                self.week3.text = nameArray[i];
                break;
            case 3:
                self.week4.text = nameArray[i];
                break;
            case 4:
                self.week5.text = nameArray[i];
                break;
            case 5:
                self.week6.text = nameArray[i];
                break;
            case 6:
                self.week7.text = nameArray[i];
                break;
                
            default:
                break;
        }
    }
}
@end
