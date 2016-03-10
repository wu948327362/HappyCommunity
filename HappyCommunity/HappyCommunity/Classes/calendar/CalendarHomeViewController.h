//
//  CalendarHomeViewController.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CalendarViewController.h"
#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface CalendarHomeViewController : CalendarViewController
@property (nonatomic, strong) NSString *calendartitle;//设置导航栏标题

- (void)setAirPlaneToDay:(NSInteger)day ToDateforString:(NSString *)todate;//飞机初始化方法
//
//- (void)setHotelToDay:(NSInteger)day ToDateforString:(NSString *)todate;//酒店初始化方法
//
//- (void)setTrainToDay:(NSInteger)day ToDateforString:(NSString *)todate;//火车初始化方法
@end
