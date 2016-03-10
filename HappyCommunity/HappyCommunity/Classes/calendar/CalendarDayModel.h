//
//  CalendarDayModel.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick    //被点击的日期
    
};
@interface CalendarDayModel : NSObject
/** 显示的日期样式*/
@property(nonatomic, assign)CollectionViewCellDayType style;
/** 天*/
@property(nonatomic, assign)NSUInteger day;
/** 月*/
@property(nonatomic, assign)NSUInteger month;
/** 年*/
@property(nonatomic, assign)NSUInteger year;
/** 周*/
@property(nonatomic, assign)NSUInteger week;
/** 农历*/
@property(nonatomic, copy)NSString *chinese_Calendar;
/** 节日*/
@property(nonatomic, copy)NSString *holiday;

/** 得到自定义日历cell的模型*/
+ (CalendarDayModel *)calendarDayWithYear:(NSUInteger)year
                                    month:(NSUInteger)month
                                      day:(NSUInteger)day;

/** 返回当天的NSDate对象*/
- (NSDate *)date;
/** 返回当天的日期字符串对象*/
- (NSString *)strDate;
/** 返回星期几*/
- (NSString *)getWeekStr;

@end
