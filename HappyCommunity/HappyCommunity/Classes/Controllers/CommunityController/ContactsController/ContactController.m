//
//  ContactController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/2.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "ContactController.h"
#import "ContactManager.h"
#import "ChatController.h"
#import "EMSDK.h"
#import "EMError.h"
#import "DataBaseTools.h"

@interface ContactController ()

@property(nonatomic,strong)NSMutableArray *data;

@property(nonatomic,strong)ChatController *chatController;

@end

static NSString *conCell = @"contact_cell";
@implementation ContactController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//注册cell
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:conCell];
	
	//初始化聊天界面
	self.chatController = [[ChatController alloc] init];
	
}

- (void)viewWillAppear:(BOOL)animated{
	//根据flag加载数据
	[self loadData];
}

- (void)loadData{
	self.data = [NSMutableArray array];
	[self.data removeAllObjects];
	[self.data addObjectsFromArray:[[ContactManager shareInstance] dataForFlag:self.flag]];
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conCell forIndexPath:indexPath];
	
	cell.imageView.image = [UIImage imageNamed:self.leftImage];
	cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	//判断如果flag==3,则是好友请求只需弹出提示框即可.
	if(self.flag==3){
		
		[self showAlert:@"是否接受好友请求" title:@"好友请求" index:indexPath.row];
		
	}else{
		ChatController *chat = [[ChatController alloc] init];
		chat.receiverId = self.data[indexPath.row];
		chat.flag = self.flag;
		[self.navigationController pushViewController:chat animated:YES];
	}
	
}

//显示提示信息.
- (void)showAlert:(NSString *)string title:(NSString *)title index:(NSInteger)index{
	UIAlertController *control = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
	//保存用户的姓名和message
	NSArray *arr = [self.data[index] componentsSeparatedByString:@":"];
	
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:[arr firstObject]];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if (!error) {
					//数据库移除好友请求,重新加载.
					[[DataBaseTools SharedInstance] delPersonByName:[arr firstObject]];
					[self loadData];
				}
			});
			
		});
		
	}];
	UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			[[EMClient sharedClient].contactManager declineInvitationForUsername:[arr firstObject]];
			
		});
	}];
	[control addAction:action];
	[control addAction:action1];
	[self presentViewController:control animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 70;
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
