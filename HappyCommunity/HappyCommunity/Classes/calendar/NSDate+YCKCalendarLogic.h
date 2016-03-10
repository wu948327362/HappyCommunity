//
//  NSDate+YCKCalendarLogic.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YCKCalendarLogic)
/** 计算当前月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth;
/** 计算当前月有多少个星期*/
- (NSUInteger)numberOfWeeksInCurrentMonth;
/** 计算这个月第一天是星期几*/
- (NSUInteger)weeklyOrdinality;
/** 计算这个月最开始的一天*/
- (NSDate *)firstDayOfCurrentMonth;
/** 计算当前月的最后一天*/
- (NSDate *)lastDayOfCurrentMonth;
/** 上个月的日期*/
- (NSDate *)dayInTheBeforeMonth;
/** 下个月的日期*/
- (NSDate *)dayInTheNextMonth;
/** 获取当前月份之后的几个月*/
- (NSDate *)dayInTheAfterMonths:(NSInteger)month;
/** 获取当前之后的几天*/
- (NSDate *)dayInTheAfterDay:(NSInteger)days;
/** 获取当前年月日的对象*/
- (NSDateComponents *)YMDCompents;
/** 字符串转换日期*/
- (NSDate *)dateFromString:(NSString *)dateString;
/** 日期转换字符串*/
- (NSString *)stringFromDate:(NSDate *)date;


/** 根据今天日期和之前的日期得到两个日历之间相差的天数*/
+ (NSInteger)getDayNumberToDay:(NSDate *)today beforeDay:(NSDate *)beforeDay;

/** 根据日期得到一周的值*/
- (NSInteger)getWeekValueWithDate;

/** 判断日期是今天，明天，后天，周几*/
- (NSString *)compareTodayWithDate;

/** 通过数字返回星期几的字符串*/
+ (NSString *)getWeekStringFromInteger:(NSInteger)week;
@end
