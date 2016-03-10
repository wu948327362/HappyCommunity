//
//  ChatController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "ChatController.h"
#import "EMSDK.h"
#import "EMError.h"
#import "MessageModel.h"
#import "DataBaseTools.h"
#import "ChatTableViewCell.h"
#import "ChatModel.h"
#import "MyEMManager.h"
#import "CloudManager.h"

@interface ChatController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

//暂存发送和接受的消息
@property(nonatomic,strong)NSMutableArray *messages;

@end

static NSString *chatCell = @"chat_cell";
@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    //设置tableView的frame及其他相关设置;
	[self loadMyView];
	
	//注册cell
	[self.tableView registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:chatCell];
	
	//设置接收消息代理,并设置接受消息代理方法.
	[[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
	
	
}

- (void)viewDidAppear:(BOOL)animated{
	[self updateMessages:self.flag];
}

//设置tableView的frame;
- (void)loadMyView{
	
	//设置代理
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.messageField.delegate = self;
	
	//设置tableView的frame;
	CGRect frame = self.tableView.frame;
	frame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
	frame.size.height = frame.size.height - CGRectGetMidY(self.tabBarController.tabBar.frame);
	self.tableView.frame = frame;
	
	//设置按钮圆角
	self.sendBtn.layer.masksToBounds = YES;
	self.sendBtn.layer.cornerRadius = 4;
	
	//初始化数组,信息
	self.messages = [NSMutableArray array];
	
	//判断如果是群组聊天导航栏添加添加按钮可以邀请好友进入聊天组
	if (self.flag==1) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请好友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriend)];
	}
	
	//xib设置圆角需要设置这一句.10.0f随便取.
	self.tableView.estimatedRowHeight = 10.0f;
	//隐藏右侧滑条
	self.tableView.showsVerticalScrollIndicator = NO;
	
	//增加监听,当键盘出现或者改变时发出消息
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	//键盘退出时发出消息
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	
}

//键盘出现或者改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
	
	//获取键盘数据
	NSDictionary *userInfo = [aNotification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyBoardRect = [aValue CGRectValue];
	int height = keyBoardRect.size.height;
	
	CGRect rect = self.view.frame;
	CGFloat tab = CGRectGetHeight(self.tabBarController.tabBar.frame);
	
	rect.size.height = rect.size.height - height + tab;
	self.view.frame = rect;
	
	[self updateMessages:self.flag];
	
}

//键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
	self.view.frame = [UIScreen mainScreen].bounds;
	[self updateMessages:self.flag];
}

//添加好友的导航栏的方法
- (void)addFriend{
	
	//添加好友进群
	UIAlertController *control = [[MyEMManager shareInstance] addToGroup:self.receiverId];
	
	[self presentViewController:control animated:YES completion:nil];
	
	
}

- (void)viewWillAppear:(BOOL)animated{
	[self.view endEditing:YES];
}

#pragma mark - tableView的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell forIndexPath:indexPath];
	
	//判断是否是本人发出的消息
	MessageModel *message = self.messages[indexPath.row];
	
	ChatModel *model = [[ChatModel alloc] init];
	model.chatText = message.text;
	
	//设置cell圆角等属性.
	cell = [self setCellAttrinbutes:cell];
	
	//等于0说明是本人发出的.
	if ([message.from isEqualToString:[[EMClient sharedClient] currentUsername]]) {
		cell = [self setRightCell:cell model:model name:message.from];
		
	}else{
		cell = [self setLeftCell:cell model:model name:message.from];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.001;
}

//由于约束生效等问题只能将设置cell的圆角等操作放在这里.
- (ChatTableViewCell *)setCellAttrinbutes:(ChatTableViewCell *)cell{
	//设置圆角
	cell.leftIcon.layer.masksToBounds = YES;
	cell.leftIcon.layer.cornerRadius = cell.leftIcon.frame.size.width/2;
	cell.rightIcon.layer.masksToBounds = YES;
	cell.rightIcon.layer.cornerRadius = cell.leftIcon.frame.size.width/2;
	
	//设置label的圆角
	cell.chatLabel.layer.masksToBounds = YES;
	cell.chatLabel.layer.cornerRadius = 10;
	cell.leftIcon.layer.cornerRadius = cell.leftIcon.frame.size.width/2;
	cell.rightIcon.layer.cornerRadius = cell.rightIcon.frame.size.width/2;
	
	return cell;
}

//自己发送的信息显示在右边
- (ChatTableViewCell *)setRightCell:(ChatTableViewCell *)cell model:(ChatModel *)model name:(NSString *)name{
	cell.leftIcon.hidden = YES;
	cell.rightIcon.hidden = NO;
	cell.leftName.hidden = YES;
	cell.rightName.hidden = NO;
	cell.chatModel = model;
	cell.rightName.text = name;
	cell.chatLabel.textAlignment = NSTextAlignmentRight;
	cell.chatLabel.backgroundColor = [UIColor orangeColor];
	cell.rightIcon.image = [[DataBaseTools SharedInstance] getCachePictureWithName:name];
	if (cell.rightIcon.image==nil) {
		[[CloudManager shareInstance] getUserIconByName:name finish:^(UIImage *findImage) {
			cell.rightIcon.image = findImage;
			if (cell.rightIcon.image==nil) {
				cell.rightIcon.image = [UIImage imageNamed:@"chatListCellHead@2x"];
			}else{
				[[DataBaseTools SharedInstance] cachePictureWithImage:findImage andName:name];
			}
		}];
		
	}
	
	return cell;
}

//好友发送的信息显示在左边
- (ChatTableViewCell *)setLeftCell:(ChatTableViewCell *)cell model:(ChatModel *)model name:(NSString *)name{
	cell.leftIcon.hidden = NO;
	cell.rightIcon.hidden = YES;
	cell.leftName.hidden = NO;
	cell.rightName.hidden = YES;
	cell.chatModel = model;
	cell.leftName.text = name;
	cell.chatLabel.textAlignment = NSTextAlignmentLeft;
	cell.chatLabel.backgroundColor = [UIColor purpleColor];
	cell.leftIcon.image = [[DataBaseTools SharedInstance] getCachePictureWithName:name];
	if (cell.leftIcon.image==nil) {
		[[CloudManager shareInstance] getUserIconByName:name finish:^(UIImage *findImage) {
			cell.leftIcon.image = findImage;
			
			if (cell.leftIcon.image==nil) {
				cell.leftIcon.image = [UIImage imageNamed:@"chatListCellHead@2x"];
			}else{
				[[DataBaseTools SharedInstance] cachePictureWithImage:findImage andName:name];
			}
		}];
		
	}
	
	return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	[self updateMessages:self.flag];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	[self updateMessages:self.flag];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[self.messageField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击按钮发送消息
- (IBAction)sendMessage:(UIButton *)sender {
	//发送消息为空则返回.
	[[MyEMManager shareInstance] sendMessageWithReceiveId:self.receiverId message:self.messageField.text flag:self.flag finish:^(EMMessage *mes) {
		[self saveMessageModelWith:mes];
		self.messageField.text = @"";
	}];
	
}

//更新消息界面
- (void)updateMessages:(NSInteger)flag{
	
	[self.messages removeAllObjects];
	
	self.messages = [[DataBaseTools SharedInstance] messagesWithReceiverId:self.receiverId from:[[EMClient sharedClient] currentUsername] flag:flag];
	
	[self.tableView reloadData];
	
	if (self.messages.count>0) {
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
		
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
	
}

#pragma mark - 接收到消息函数回调
- (void)didReceiveMessages:(NSArray *)aMessages{
	for (EMMessage *message in aMessages) {
		if ([message.from isEqualToString:self.receiverId]) {
			[self saveMessageModelWith:message];
		}
	}
}

//保存消息到数组
- (void)saveMessageModelWith:(EMMessage *)message{
	
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageModel" inManagedObjectContext:[DataBaseTools SharedInstance].context];
	MessageModel *model = [[MessageModel alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
	
	
	model.text = ((EMTextMessageBody *)message.body).text;
	model.direction = [NSNumber numberWithInteger:message.direction];
	model.messageId = message.messageId;
	model.conversationId = message.conversationId;
	model.from = message.from;
	model.to = message.to;
	model.timestamp = [NSNumber numberWithLongLong:message.timestamp];
	model.chatType = [NSNumber numberWithInteger:message.chatType];
	model.status = [NSNumber numberWithInteger:message.status];
	model.isReadAcked = [NSNumber numberWithInteger:message.isReadAcked];
	model.isRead = [NSNumber numberWithInteger:message.isRead];
	model.isDeliverAcked = [NSNumber numberWithInteger:message.isDeliverAcked];
	
	[self.messages addObject:model];
	
	//刷新,滑到最后一行.
	[self.tableView reloadData];
	
	if (self.messages.count>0) {
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
		
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
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
