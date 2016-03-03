//
//  ChatController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "ChatController.h"

@interface ChatController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@end

static NSString *chatCell = @"chat_cell";
@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    //设置tableView的frame;
	[self loadTableView];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.messageField.delegate = self;
	
	//注册cell
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:chatCell];
	
}
//设置tableView的frame;
- (void)loadTableView{
	//设置tableView的frame;
	CGRect frame = self.tableView.frame;
	frame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
	frame.size.height = frame.size.height - CGRectGetMidY(self.tabBarController.tabBar.frame);
	self.tableView.frame = frame;
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell forIndexPath:indexPath];
	
	
	
	return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	CGRect rect = self.view.frame;
	
	rect.size.height = rect.size.height-210;
	self.view.frame = rect;
	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	self.view.frame = [UIScreen mainScreen].bounds;
	return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[self.messageField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(UIButton *)sender {
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
