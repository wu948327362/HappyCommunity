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
	
    //设置tableView的frame;
	[self loadMyView];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.messageField.delegate = self;
	
	//注册cell
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:chatCell];
	
	//设置接收消息代理,并设置接受消息代理方法.
	[[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
	
	[self updateMessages:self.flag];
	
}
//设置tableView的frame;
- (void)loadMyView{
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
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriend)];
	}
	
}

//添加好友的导航栏的方法
- (void)addFriend{
	
	UIAlertController *control = [UIAlertController alertControllerWithTitle:@"添加好友进群" message:[NSString stringWithFormat:@"%@邀请你加入群聊",[[EMClient sharedClient] currentUsername]] preferredStyle:UIAlertControllerStyleAlert];
	
	__block NSString *name = nil;
	[control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"请输入好友名字";
		textField.adjustsFontSizeToFitWidth = YES;
		name = textField.text;
	}];
	
	//得到group
	NSArray *arr = [self.receiverId componentsSeparatedByString:@":"];
	
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[[EMClient sharedClient].groupManager addOccupants:@[name] toGroup:[arr firstObject] welcomeMessage:[NSString stringWithFormat:@"%@邀请你加入群聊",[[EMClient sharedClient] currentUsername]] error:nil];
	}];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[control addAction:ok];
	[control addAction:cancel];
	
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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell forIndexPath:indexPath];
	
	//判断是否是本人发出的消息
	MessageModel *message = self.messages[indexPath.row];
	
	//等于0说明是本人发出的.
	if ((message.direction).integerValue==0) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",message.text,message.from];
		cell.textLabel.textAlignment = UITextAlignmentRight;
	}else{
		cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",message.from,message.text];
		cell.textLabel.textAlignment = UITextAlignmentLeft;
	}
	
	return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	CGRect rect = self.view.frame;
	
	rect.size.height = rect.size.height-210;
	self.view.frame = rect;
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	[self updateMessages:self.flag];
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

//点击按钮发送消息
- (IBAction)sendMessage:(UIButton *)sender {
	//发送消息为空则返回.
	if (self.messageField.text.length==0) {
		return;
	}
	EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:self.messageField.text];
	NSString *sendUser = [[EMClient sharedClient] currentUsername];
	__weak typeof(self) weakself = self;
	
	if (self.flag==0) {
		EMMessage *message  = [[EMMessage alloc] initWithConversationID:self.receiverId from:sendUser to:self.receiverId body:body ext:nil];
		message.chatType = EMChatTypeChat;
		
		[[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
			
		} completion:^(EMMessage *message, EMError *error) {
			if (!error) {
				//保存聊天记录到coreData
				[[DataBaseTools SharedInstance] saveMessageModelWith:message];
				
				//将输入框置为空
				self.messageField.text = @"";
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakself updateMessages:self.flag];
				});
			}
		}];
		
	}else if (self.flag==1||self.flag==2){
		//获取所要发送的群组的ID
		NSArray *arr = [self.receiverId componentsSeparatedByString:@":"];
		
		EMMessage *message = [[EMMessage alloc] initWithConversationID:[arr firstObject] from:sendUser to:[arr firstObject] body:body ext:nil];
		message.chatType = EMChatTypeGroupChat;
		
		[[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
			
		} completion:^(EMMessage *message, EMError *error) {
			if (!error) {
				//保存聊天记录到coreData
				[[DataBaseTools SharedInstance] saveMessageModelWith:message];
				//将输入框置为空
				self.messageField.text = @"";
				dispatch_async(dispatch_get_main_queue(), ^{
					[weakself updateMessages:self.flag];
				});
			}
		}];
		
	}
	
}

//更新消息界面
- (void)updateMessages:(NSInteger)flag{
	
	[self.messages removeAllObjects];
	if (flag==0) {
		self.messages = [[DataBaseTools SharedInstance] messagesWithReceiverId:self.receiverId from:[[EMClient sharedClient] currentUsername] flag:flag];
	}else if (flag==1||flag==2){
		self.messages = [[DataBaseTools SharedInstance] messagesWithReceiverId:self.receiverId from:[[EMClient sharedClient] currentUsername] flag:flag];
	}
	
	
	[self.tableView reloadData];
	
	if (self.messages.count>0) {
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
		
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	
}

#pragma mark - 接收到消息函数回调
- (void)didReceiveMessages:(NSArray *)aMessages{
	
	[self updateMessages:self.flag];
	
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
