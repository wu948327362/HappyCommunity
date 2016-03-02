//
//  NewsController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "NewsController.h"
#import "LaughController.h"
#import "AFNetworking.h"
#import "NewsManager.h"
#import "NewTableViewCell.h"
#import "NewsModel.h"

@interface NewsController ()
@property(nonatomic, strong)NSMutableArray *data;
@end

static NSString *newsCell = @"mycell";
@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:newsCell];
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewTableViewCell" bundle:nil] forCellReuseIdentifier:newsCell];
    self.data = [NSMutableArray array];
    
}

- (void)loadData
{
   self.data = [[NewsManager shareInstance] requestWithUrl:NewsUrl finish:^{
       [self.tableView reloadData];
   }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",[[NewsManager shareInstance] countOfArray]);
    return [[NewsManager shareInstance] countOfArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCell forIndexPath:indexPath];
    cell.Model = [[NewsManager shareInstance] getModelWithIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"fdsfsdfsdfs");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewTableViewCell *cell = [[NewTableViewCell alloc] init];
//    cell.Model = [[NewsManager shareInstance] getModelWithIndex:indexPath.row];
//    return [cell heightForCell:cell.Model];
    return 120;
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
