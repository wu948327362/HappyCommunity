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
#import "SettingViewController.h"

static NSString * const kYCLeftViewControllerCellReuseId = @"kYCLeftViewControllerCellReuseId";

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *lefs;
@property (nonatomic, assign) NSInteger previousRow;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    _lefs = @[@"新闻和笑话", @"关于app", @"客服呈上", @"天气"];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width - 64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
        SettingViewController *setting = [[SettingViewController alloc ] init];
        center = [[UINavigationController alloc] initWithRootViewController:setting];
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
