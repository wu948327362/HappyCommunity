//
//  NSDate+YCKCalendarLogic.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "NSDate+YCKCalendarLogic.h"

@implementation NSDate (YCKCalendarLogic)
/** 计算当前月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

/** 计算当前月有多少个星期*/
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    weeks += days / 7;
    weeks += (days % 7 > 0)? 1 : 0;
    return weeks;
}

/** 计算这个月第一天是星期几*/
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}

/** 计算这个月最开始的一天*/
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

/** 计算当前月的最后一天*/
- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/** 上个月的日期*/
- (NSDate *)dayInTheBeforeMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 下个月的日期*/
- (NSDate *)dayInTheNextMonth
{
    NSDateComponents *dateComonents = [[NSDateComponents alloc] init];
    dateComonents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComonents toDate:self options:0];
}

/** 获取当前月份之后的几个月*/
- (NSDate *)dayInTheAfterMonths:(NSInteger)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 获取当前之后的几天*/
- (NSDate *)dayInTheAfterDay:(NSInteger)days
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 获取当前年月日的对象*/
- (NSDateComponents *)YMDCompents
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
}

/** 字符串转换日期*/
- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

/** 日期转换字符串*/
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDate = [dateFormatter stringFromDate:date];
    return destDate;
}

/** 根据今天日期和之前的日期得到两个日历之间相差的天数*/
+ (NSInteger)getDayNumberToDay:(NSDate *)today beforeDay:(NSDate *)beforeDay
{
    //日历控件对象
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforeDay options:0];
    NSInteger day = [components day];
    return day;
}

/** 根据日期得到一周的值 , 周日是“1”， 周一是“2”。。。。*/
- (NSInteger)getWeekValueWithDate
{
    NSInteger weekDayValue;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    return weekDayValue = [dateComponents weekday];
}

/** 判断日期是今天，明天，后天，周几*/
- (NSString *)compareTodayWithDate
{
//    NSDate *today = [NSDate date];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
//    NSDateComponents *components_today = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
//                                    NSCalendarUnitWeekday fromDate:today];
//    NSDateComponents *components_other = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
//    NSInteger weekValue = [self getWeekValueWithDate];
//    if (components_today.year == components_other.year && components_today.month == components_other.month && components_today.day == components_other.day) {
//        return @"今天";
//    }else if (components_today.year == components_other.year && components_today.month == components_other.month && (components_today.day - components_other.day) == -1){
//        return @"明天";
//    }else if (components_today.year == components_other.year && components_today.month == components_other.month && (components_today.day - components_other.day) == -2){
//        return @"后天";
//    }else{
//        return [NSDate getWeekStringFromInteger:weekValue];
//    }
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
//    NSDateComponents *comps_today= [calendar components:(NSYearCalendarUnit |
//                                                         NSMonthCalendarUnit |
//                                                         NSDayCalendarUnit |
//                                                         NSWeekdayCalendarUnit) fromDate:todate];
//    
//    
//    NSDateComponents *comps_other= [calendar components:(NSYearCalendarUnit |
//                                                         NSMonthCalendarUnit |
//                                                         NSDayCalendarUnit |
//                                                         NSWeekdayCalendarUnit) fromDate:self];
        NSDateComponents *comps_today = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                        NSCalendarUnitWeekday fromDate:todate];
        NSDateComponents *comps_other = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    
    //获取星期对应的数字
    NSInteger weekIntValue = [self getWeekValueWithDate];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -1){
        return @"明天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -2){
        return @"后天";
        
    }else{
        //直接返回当时日期的字符串(这里让它返回空)
        return [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }


}

/** 通过数字返回星期几的字符串*/
+ (NSString *)getWeekStringFromInteger:(NSInteger)week
{
    NSString *str_weekDay;
    switch (week) {
        case 1:
            str_weekDay = @"周日";
            break;
        case 2:
            str_weekDay = @"周一";
            break;
        case 3:
            str_weekDay = @"周二";
            break;
        case 4:
            str_weekDay = @"周三";
            break;
        case 5:
            str_weekDay = @"周四";
            break;
        case 6:
            str_weekDay = @"周五";
            break;
        case 7:
            str_weekDay = @"周六";
            break;
        default:
            break;
    }
    return str_weekDay;
}


@end
