//
//  MyViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "MyViewController.h"
#import "NewsController.h"
#import "LaughController.h"
#import "RESideMenu.h"
#import "LeftViewController.h"

@interface MyViewController ()
@property(nonatomic,strong)NewsController *nec;
@property(nonatomic,strong)LaughController *lac;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//	self.navigationController.navigationBar.translucent = NO;
	
	self.nec = [[NewsController alloc] init];
	self.lac = [[LaughController alloc] init];
    [self addChildViewController:self.nec];
    [self addChildViewController:self.lac];
    
	[self setRect];
	
    [self.view addSubview:self.nec.tableView];
	
	[self setSegmentWithNavigation];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(presentLeftMenuViewController:)];
}

//- (void)action {
//    LeftViewController *lvc = [[LeftViewController alloc] init];
//    [self.navigationController pushViewController:lvc animated:YES];
//}

#pragma mark - Configuring the view’s layout behavior
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//解决导航栏挡住tableView内容的问题
- (void)setRect{
	CGRect rect = self.view.frame;
//	rect.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 49, 0);
	self.nec.tableView.frame = rect;
	self.lac.tableView.frame = rect;
    self.nec.tableView.contentInset = inset;
    self.lac.tableView.contentInset = inset;
	self.view.frame = rect;
}

//设置UINavigationController的segmentController
- (void)setSegmentWithNavigation{
	
	NSArray *segmentedArray = [NSArray arrayWithObjects:@"新闻",@"笑话",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
	segmentedControl.frame = CGRectMake(0.0, 0.0, 200, 30.0);
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.tintColor = [UIColor redColor];
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	//方法2
	[self.navigationItem setTitleView:segmentedControl];
	
}

//segmentValue改变时调用的方法
- (void)segmentAction:(UISegmentedControl *)segment{
	
	if (segment.selectedSegmentIndex==0) {
        [self.lac.tableView removeFromSuperview];
        [self.view addSubview:self.nec.tableView];
        self.lac.label.hidden = YES;
		
	}else if(segment.selectedSegmentIndex==1){
		
        [self.nec.tableView removeFromSuperview];
        [self.view addSubview:self.lac.tableView];
	}
	
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
