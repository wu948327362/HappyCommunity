//
//  CommunityController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "CommunityController.h"
<<<<<<< HEAD
#import "CommunityView.h"
#import "RESideMenu.h"
=======
#import "ContactController.h"
#import "AddFriendController.h"
#import "DataBaseTools.h"
#import "EMSDK.h"
#import "EMError.h"
#import "FriendsInvitation.h"
>>>>>>> 0954a624909025b3032616339932e20b5fe35cde

@interface CommunityController ()<EMContactManagerDelegate>
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)ContactController *comController;
@property(nonatomic,strong)AddFriendController *friendController;
@end

static NSString *communityCell = @"community_cell";
@implementation CommunityController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化数据源
	[self loadData];
	
	self.navigationItem.title = @"联系人";
	
	//注册cell
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:communityCell];
	
	//点击跳转显示不同cell的信息的controller
	self.comController = [[ContactController alloc] init];
	
	//添加好友按钮
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
	
	self.friendController = [[AddFriendController alloc] initWithNibName:@"AddFriendController" bundle:nil];
	
	//设置接收到好友请求代理
	[[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
	
<<<<<<< HEAD
	self.view = self.cv;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(presentLeftMenuViewController:)];
}

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
=======
>>>>>>> 0954a624909025b3032616339932e20b5fe35cde
}

//添加好友方法
- (void)addAction{
	//标志为0,表示是添加好友.
	self.friendController.flag = 0;
	[self.navigationController pushViewController:self.friendController animated:YES];
}

- (void)loadData{
	self.data = [NSMutableArray array];
	self.images = [NSMutableArray array];
	
	self.data = @[@"好友",@"群组",@"所有群组",@"好友请求",@"添加群组"].mutableCopy;
	self.images = @[@"groupPublicHeader@2x",@"group_header@2x",@"group_joinpublicgroup@2x",@"newFriends@2x",@"group_participant_addHL@2x"].mutableCopy;
	
	[self.tableView reloadData];
	
}

- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage{
	
	FriendsInvitation *friend = [[FriendsInvitation alloc] init];
	friend.userName = aUsername;
	friend.message = aMessage;
	[[DataBaseTools SharedInstance] addPerson:friend];
	//数据库在注销的时候关闭.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:communityCell forIndexPath:indexPath];
	
	cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
	cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

//点击cell跳转,传入参数indexPath.row,区分跳转cell的类型
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.row>3) {
		//标志为1,表示是创建群组.
		self.friendController.flag = 1;
		[self.navigationController pushViewController:self.friendController animated:YES];
		
	}else{
		self.comController.flag = indexPath.row;
		
		[self.navigationController pushViewController:self.comController animated:YES];
	}
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
