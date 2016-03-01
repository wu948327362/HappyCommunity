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
	
	[self setRect];
	
	[self.view addSubview:self.nec.tableView];
	
	[self setSegmentWithNavigation];
}

//解决导航栏挡住tableView内容的问题
- (void)setRect{
	CGRect rect = self.view.frame;
	rect.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
	self.nec.tableView.frame = rect;
	self.lac.tableView.frame = rect;
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
