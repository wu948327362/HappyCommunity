//
//  CalendarLogic.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+YCKCalendarLogic.h"
@class CalendarDayModel;
@interface CalendarLogic : NSObject
/** 计算当前日期之前几天或者之后几天（负数是之前几天，正数是之后的几天）*/
- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)date1 needDays:(NSInteger)days;

- (void)selectLogic:(CalendarDayModel *)day;
@end
