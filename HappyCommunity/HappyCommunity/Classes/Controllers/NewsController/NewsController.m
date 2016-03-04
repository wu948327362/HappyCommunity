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
#import "WebViewViewController.h"
<<<<<<< HEAD


=======
>>>>>>> 220024127a4828abf43848f219808dfae3acc549
#import <MJRefresh.h>



@interface NewsController ()
/**
 *  创建可变数组来接受管理类请求的数据
 */
@property(nonatomic, strong)NSMutableArray *data1;
/**
 *  创建下拉刷新控件
 */
@property(nonatomic, strong)UIRefreshControl *refresh;
@property(nonatomic, assign)int number;
@end

static NSString *newsCell = @"mycell";
@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    
=======
>>>>>>> 220024127a4828abf43848f219808dfae3acc549

    //设置导航栏状态不透明
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //进入页面加载数据

        
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:newsCell];

<<<<<<< HEAD
    //初始化数组
    self.data1 = [NSMutableArray array];
    [self loadData];
    //注册XIB拖得cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewTableViewCell" bundle:nil] forCellReuseIdentifier:newsCell];
    

=======
    [self loadData];
    //注册XIB拖得cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewTableViewCell" bundle:nil] forCellReuseIdentifier:newsCell];
    //初始化数组
    self.data = [NSMutableArray array];
	
>>>>>>> 220024127a4828abf43848f219808dfae3acc549
    self.number = 1;
    [self setupDownRefresh];
    //上拉加载方法
    [self setupRefresh];
    
}
////上拉刷新
- (void)setupRefresh
{
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(unRefreshAction:)];
}

- (void)unRefreshAction:(UIRefreshControl *)refresh
{
    
    NSString *urlString = [NSString stringWithFormat:newsRefresh,++self.number];
    
    __block NSMutableArray *array = [NSMutableArray array];
//    self.data = [array addObjectsFromArray:<#(nonnull NSArray *)#>]
    NSLog(@"!!!!!!!%@!!!!!!!!", [self.data1[0] itemTitle]);
    array = [[NewsManager shareInstance] requestWithUrl:urlString finish:^{
        
//        array = [NewsManager shareInstance].data;
//        [self.data1 addObjectsFromArray:[NewsManager shareInstance].data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
//
    }];
    
    
    [self.tableView.mj_footer endRefreshing];
    
//    for (NewsModel *model in self.data) {
//        NSLog(@"%@", model.itemTitle);
//    }
    
//   self.data =  [[array addObjectsFromArray: [[[NewsManager shareInstance] requestWithUrl:urlString finish:^{
//        [self.tableView reloadData];
//   }]];
    
    
    
}
//下拉刷新方法
- (void)setupDownRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction:)];
    [self.tableView.mj_header beginRefreshing];
}
//下拉刷新的响应事件
- (void)refreshAction:(UIRefreshControl *)controller
{
    
    
    [self.data1 removeAllObjects];
    NSString *urlString = [NSString stringWithFormat:newsRefresh,1];
//    NSLog(@"irl:%@", urlString);
    self.data1 = [[NewsManager shareInstance] requestWithUrl:urlString finish:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark 加载数据方法
<<<<<<< HEAD
=======

>>>>>>> 220024127a4828abf43848f219808dfae3acc549
- (void)loadData
{
    NSString *urlString = [NSString stringWithFormat:newsRefresh,1];
    
    self.data1 = [[NewsManager shareInstance] requestWithUrl:urlString finish:^{
        [self.tableView reloadData];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%ld",[[NewsManager shareInstance] countOfArray]);
    return [NewsManager shareInstance].data.count;
}
#pragma mark 设置cell的属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCell forIndexPath:indexPath];
    cell.Model = [[NewsManager shareInstance] getModelWithIndex:indexPath.row];
    return cell;
}
#pragma mark 设置cell的点击响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewTableViewCell *cell = [[NewTableViewCell alloc] init];
    cell.Model = [[NewsManager shareInstance] getModelWithIndex:indexPath.row];
    WebViewViewController *webV = [[WebViewViewController alloc] init];
    webV.url = cell.Model.detailUrl;
    [self.navigationController pushViewController:webV animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}
#pragma mark 设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTableViewCell *cell = [[NewTableViewCell alloc] init];
    cell.Model = [[NewsManager shareInstance] getModelWithIndex:indexPath.row];
    return [cell heightForCell:cell.Model];
    
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
