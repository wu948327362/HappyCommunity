//
//  ServiceViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "ServiceViewController.h"
#import "RESideMenu.h"
#import "EMSDK.h"

@interface ServiceViewController ()

@property (nonatomic, strong) UIButton *openDrawerButton;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关于app";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(presentLeftMenuViewController:)];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [btn  setTitle:@"这是abc页面" forState:UIControlStateNormal];
//    [self.view addSubview:btn];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(35, 70, [UIScreen mainScreen].bounds.size.width-70, 300)];
    description.text = @"这是一款神奇的app,你可以在这里看到新闻,无聊的时候看一下笑话,定能让你身心放松,可以在社区中与人交流\n\n此版本为v1.0.0";
    description.numberOfLines = 0;
    description.font = [UIFont systemFontOfSize:20 weight:0.5];
    [self.view addSubview:description];
    
    // Do any additional setup after loading the view.
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
