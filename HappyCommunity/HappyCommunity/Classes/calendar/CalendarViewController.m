//
//  CalendarViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CalendarViewController.h"
//UI
#import "CalendarFlowLayout.h"
#import "CalendarLogic.h"
#import "CalendarCollectionCell.h"
#import "CalendarCollectionReusableView.h"
//model
#import "CalendarDayModel.h"
#import "CalendarHomeViewController.h"
#import "Color.h"
@interface CalendarViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

//定时器
{
    NSTimer *timer;
}
@end
static NSString *MonthHeader = @"MonthHeaderView";
static NSString *Daycell = @"DayCell";
@implementation CalendarViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
        [self initView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"腿粗" style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    __weak CalendarViewController *yvc = self;
//    self.view.backgroundColor = [UIColor redColor];
    self.title = @"日历";
//    [self setTitle:@"选择日期"];
//    //得到flowout
//    CalendarFlowLayout *layout = [[CalendarFlowLayout alloc] init];
//    //初始化网格视图的大小
//    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    //注册collectionCell
//    [self.collection registerClass:[CalendarCollectionCell class] forCellWithReuseIdentifier:Daycell];
//    [self.collection registerClass:[CalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
//    
//    self.collection.dataSource = self;
//    self.collection.delegate = self;
//    //设置网格视图的背景颜色
//    self.collection.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.collection];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    self.calendarMonth = [NSMutableArray array];
}

- (void)initView
{
    [self setTitle:@"选择日期"];
    //得到flowout
    CalendarFlowLayout *layout = [[CalendarFlowLayout alloc] init];
    //初始化网格视图的大小
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //注册collectionCell
    [self.collection registerClass:[CalendarCollectionCell class] forCellWithReuseIdentifier:Daycell];
    [self.collection registerClass:[CalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
    self.collection.dataSource = self;
    self.collection.delegate = self;
    //设置网格视图的背景颜色
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collection];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////懒加载日期数组
//- (NSMutableArray *)calendarMonth
//{
//    if (_calendarMonth == nil) {
//        _calendarMonth = [NSMutableArray array];
//    }
//    return _calendarMonth;
//}



#pragma mark collectionView的代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *array = [self.calendarMonth objectAtIndex:section];
    return array.count;
}

/** 每个UICollectionCell展示的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Daycell forIndexPath:indexPath];
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];
        
        CalendarCollectionReusableView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%ld年 %ld月",model.year,model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;

}

/** UICollectionView被选中时调用的方法*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *month_array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_array objectAtIndex:indexPath.row];
    if (model.style == CellDayTypeClick || model.style == CellDayTypeFutur || model.style == CellDayTypeWeek) {
        [self.logic selectLogic:model];
//        if (self.block) {
//            self.block(model);//传递数组给上级
////            timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
//        }
        [self.collection reloadData];
        
    }
}


//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/** 定时器方法*/
- (void)onTimer
{
    [timer invalidate];
    timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
