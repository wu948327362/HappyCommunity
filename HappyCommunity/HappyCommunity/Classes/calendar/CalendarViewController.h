//
//  CalendarViewController.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarLogic.h"
#import "CalendarDayModel.h"
#import "RESideMenu.h"
/** 回调代码block*/
typedef void(^CalendarBlock)(CalendarDayModel *model);
@interface CalendarViewController : UIViewController
/** 网格视图*/
@property(nonatomic, strong)UICollectionView *collection;
/** 每个月份中的daymodel容器数组*/
@property(nonatomic, strong)NSMutableArray *calendarMonth;
//回调block
@property(nonatomic, copy)CalendarBlock block;
@property(nonatomic, strong)CalendarLogic *logic;
@end
