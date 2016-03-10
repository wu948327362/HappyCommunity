//
//  AboutViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "AboutViewController.h"
#import "RESideMenu.h"

static NSString *cell_id = @"cell_identifier";
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//显示侧边栏的导航栏按钮.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(presentLeftMenuViewController:)];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell_id];
	
}

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewController代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
	
	return cell;
	
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
