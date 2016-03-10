//
//  LeftViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "LeftViewController.h"
#import "RESideMenu.h"
#import "WeatherViewController.h"
#import "ServiceViewController.h"

#import "CalendarHomeViewController.h"

#import "SettingViewController.h"
#import "DataBaseTools.h"


static NSString * const kYCLeftViewControllerCellReuseId = @"kYCLeftViewControllerCellReuseId";

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *lefs;
@property (nonatomic, assign) NSInteger previousRow;

@property(nonatomic, strong)CalendarHomeViewController *chvc;;

@property (nonatomic, strong) NSArray *images;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.22 green:0.71 blue:0.98 alpha:1];
    

//    _lefs = @[@"新闻和笑话", @"关于app", @"功能历"];
//    _tableView = [[UITableView alloc] init];
//    _tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width - 64);


    _lefs = @[@"新闻和笑话", @"关于app", @"日历",@"天气"];
	_images = @[@"news_icon", @"about_icon", @"calendar_icon",@"weather_icon"];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
	

    _tableView.dataSource = self;
    _tableView.delegate = self;
	//设置tableView的tableHeaderView
	[self setHeaderView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYCLeftViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.tableView];

    
    // Do any additional setup after loading the view.
}

//设置状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lefs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYCLeftViewControllerCellReuseId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYCLeftViewControllerCellReuseId];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.lefs[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.highlightedTextColor = [UIColor grayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.backgroundColor = [UIColor clearColor];
	cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *center;
    if (indexPath.row == 0) {
        center = self.sideMenuViewController.mainController;
    }
    else if(indexPath.row == 1){
        ServiceViewController *service = [[ServiceViewController alloc ] init];
        center = [[UINavigationController alloc] initWithRootViewController:service];
    }else if(indexPath.row == 2){
        CalendarHomeViewController *setting = [[CalendarHomeViewController alloc ] init];
        center = [[UINavigationController alloc] initWithRootViewController:setting];
        [setting setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化
        [self.navigationController pushViewController:_chvc animated:YES];
        
    }else{
        AboutViewController *about = [[AboutViewController alloc ] init];
        center = [[UINavigationController alloc] initWithRootViewController:about];

    }else if(indexPath.row == 3){
        WeatherViewController *weather = [[WeatherViewController alloc] init];
        center = [[UINavigationController alloc] initWithRootViewController:weather];

    }
    [self.sideMenuViewController setContentViewController:center
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
    self.previousRow = indexPath.row;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//添加header视图
- (void)setHeaderView{
	
	UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
	
	//设置头像icon
	UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 55, 55)];
	imView.image = [[DataBaseTools SharedInstance] getCachePictureWithName:[[EMClient sharedClient] currentUsername]];
	if (imView.image==nil) {
		imView.image = [UIImage imageNamed:@"chatListCellHead@2x"];
	}
	//设置圆角
	imView.layer.masksToBounds = YES;
	imView.layer.cornerRadius = 55/2;
	[myview addSubview:imView];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 18, 80, 55)];
	label.text = [[EMClient sharedClient] currentUsername];
	
	[myview addSubview:label];
	myview.backgroundColor = [UIColor whiteColor];
	
	self.tableView.tableHeaderView = myview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
