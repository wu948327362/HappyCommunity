//
//  CalendarHomeViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CalendarHomeViewController.h"
#import "NSDate+YCKCalendarLogic.h"

@interface CalendarHomeViewController ()
{
    
    
    NSInteger daynumber;//天数
    NSInteger optiondaynumber;//选择日期数量
    //    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}
@end

@implementation CalendarHomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    self.view.backgroundColor = [UIColor clearColor];
//    __weak CalendarHomeViewController *chv = self;
//    self.view.backgroundColor = [UIColor redColor];
//    self.title = @"日历";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(NSInteger)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collection reloadData];//刷新
}
//
////酒店初始化方法
//- (void)setHotelToDay:(NSInteger)day ToDateforString:(NSString *)todate
//{
//    
//    daynumber = day;
//    optiondaynumber = 2;//选择两个后返回数据对象
//    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
//    [super.collection reloadData];//刷新
//}
//
//
////火车初始化方法
//- (void)setTrainToDay:(NSInteger)day ToDateforString:(NSString *)todate
//{
//    daynumber = day;
//    optiondaynumber = 1;//选择一个后返回数据对象
//    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
//    [super.collection reloadData];//刷新
//    
//}



#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(NSInteger)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.logic = [[CalendarLogic alloc]init];
    
    return [super.logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - 设置标题


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
