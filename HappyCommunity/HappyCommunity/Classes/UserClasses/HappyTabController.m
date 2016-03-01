//
//  HappyTabController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "HappyTabController.h"
#import "NewsController.h"
#import "CommunityController.h"
#import "SettingsController.h"
#import "MyViewController.h"

@interface HappyTabController ()
//@property(nonatomic,strong)NewsController *nec;
@property(nonatomic,strong)CommunityController *cmc;
@property(nonatomic,strong)SettingsController *sec;
@property(nonatomic,strong)MyViewController *mvc;
@end

@implementation HappyTabController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//初始化tabBar对应的ViewControllers
	[self setControllers];
}

#pragma mark 初始化tabBar对应的ViewControllers
- (void)setControllers{
	
	//设置消息Controllers
	self.mvc = [[MyViewController alloc] init];
	self.mvc.tabBarItem = [self setTabbarWithSelectedImage:@"tabbar_contact_HL@2x" image:@"tabbar_contact@2x" title:@"娱乐"];
	UINavigationController *nvc1 = [[UINavigationController alloc] initWithRootViewController:self.mvc];
	
	//设置消息Controllers
	self.cmc = [[CommunityController alloc] init];
	self.cmc.tabBarItem = [self setTabbarWithSelectedImage:@"tabbar_Conversation_HL@2x" image:@"tabbar_Conversation@2x" title:@"社区"];
	UINavigationController *nvc2 = [[UINavigationController alloc] initWithRootViewController:self.cmc];
	
	//设置消息Controllers
	self.sec = [[SettingsController alloc] init];
	self.sec.tabBarItem = [self setTabbarWithSelectedImage:@"tabbar_setting_HL@2x" image:@"tabbar_setting@2x" title:@"设置"];
	UINavigationController *nvc3 = [[UINavigationController alloc] initWithRootViewController:self.sec];
	
	//设置tabBarControllers
	self.viewControllers = @[nvc1,nvc2,nvc3];
	
	
}

/*
 *@param selectedImage选中图片
 *@param image未选中的图片
 *return 返回tabbarItem
 */
- (UITabBarItem *)setTabbarWithSelectedImage:(NSString *)simage image:(NSString *)image title:(NSString *)title{
	
	UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:simage]];
	return item;
	
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
