//
//  WebViewViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *web;
//@property(nonatomic, strong)NSString *newsUrl;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.web = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    NSURL *url = [NSURL URLWithString:self.url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.view addSubview:self.web];
//    [self.web loadRequest:request];
//    //尺寸页面适配
//    self.web.scalesPageToFit = YES;
//    //取消右边竖直方向的滑条
//    self.web.scrollView.showsVerticalScrollIndicator = NO;
//    //取消sebView的回弹功能
//    self.web.scrollView.bounces = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:self.web];
    [self.web loadRequest:request];
    //尺寸页面适配
    self.web.scalesPageToFit = YES;
    //取消右边竖直方向的滑条
    self.web.scrollView.showsVerticalScrollIndicator = NO;
    //取消sebView的回弹功能
    self.web.scrollView.bounces = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
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
