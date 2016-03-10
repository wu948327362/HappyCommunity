//
//  CalendarDayModel.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CalendarDayModel.h"
#import "NSDate+YCKCalendarLogic.h"
@implementation CalendarDayModel
/** 得到自定义日历cell的模型*/
+ (CalendarDayModel *)calendarDayWithYear:(NSUInteger)year
                                    month:(NSUInteger)month
                                      day:(NSUInteger)day
{
    CalendarDayModel *model = [[CalendarDayModel alloc] init];
    model.year = year;
    model.month = month;
    model.day = day;
    return model;
}

/** 返回当天的NSDate对象*/
- (NSDate *)date
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = self.year;
    components.month = self.month;
    components.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
/** 返回当天的日期字符串对象*/
- (NSString *)strDate
{
    NSDate *today = [self date];
    NSString *str = [today stringFromDate:today];
    return str;
}

/** 返回星期几*/
- (NSString *)getWeekStr
{
    NSDate *date = [self date];
    NSString *weekStr = [date compareTodayWithDate];
    return weekStr;
}
//判断是不是同一天
- (BOOL)isEqualTo:(CalendarDayModel *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}

@end
