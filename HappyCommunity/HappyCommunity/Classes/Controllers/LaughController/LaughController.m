//
//  LaughController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "LaughController.h"
#import "LaughModel.h"
#import "UIImageView+WebCache.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "LaughTableViewCell.h"
#import "MyViewController.h"
static NSString *indentifil = @"mycell";
@interface LaughController ()
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)CGFloat photoW;
@property(nonatomic, assign)CGFloat photoH;
@property(nonatomic, assign)NSInteger num;

@end


@implementation LaughController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	//注册xib的cell
	[self.tableView registerClass:[LaughTableViewCell class] forCellReuseIdentifier:indentifil];
    //初始化数组
    self.dataArray = [NSMutableArray array];
    self.num = 0;
//    //进入界面刷新数据
//    [self loadData];
    //取消tableView右边的滑动条
//    self.tableView.showsVerticalScrollIndicator = NO;
    //取消界面的滑动功能
//    self.tableView.scrollEnabled = NO;
    //下拉刷新
    [self setupRefresh];
    //上拉加载
    [self setupPullOnLoad];
    
    
	
}

- (void)setupPullOnLoad
{
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullOnAction)];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)pullOnAction
{
//    if (self.dataArray) {
//        [self.dataArray removeAllObjects];
//    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *str = [NSString stringWithFormat:pullUrl,++self.num];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上拉加载请求成功");
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:responseObject[@"value"]];
        //        NSLog(@"%@", responseObject);
        for (NSDictionary *dic in array) {
            LaughModel *model = [[LaughModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
    }];
}
#pragma mark 下拉刷新
- (void)setupRefresh
{
//    MJRefreshNormalHeader *head = [[MJRefreshNormalHeader alloc] init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
//    [self.dataArray removeAllObjects];
//    self.tableView.becomeFirstResponder = NO;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)refreshAction
{
//    ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *str = [NSString stringWithFormat:laughUrl];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        NSLog(@"请求成功");
//        [self.dataArray removeAllObjects];
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:responseObject[@"value"]];
        
        NSMutableArray *newLaught = [NSMutableArray array];
        
        //        NSLog(@"%@", responseObject);
        for (NSDictionary *dic in array) {
            LaughModel *model = [[LaughModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [newLaught addObject:model];
            //            NSLog(@"=================%@", self.dataArray);
        }
        [self.tableView reloadData];
        //暂停刷新
        [self.tableView.mj_header endRefreshing];
        NSRange range = NSMakeRange(0, newLaught.count);
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.dataArray insertObjects:newLaught atIndexes:set];
        if (self.dataArray == nil) {
            [self loadData];
            self.label.text = @"没有任何消息更新";
        }
        //显示刷新的笑话数
        [self showNewLaugh:self.dataArray.count];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
        [self.tableView.mj_header endRefreshing];
    }];

}
#pragma mark 显示刷新消息
- (void)showNewLaugh:(NSInteger)count
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 35, CGRectGetMaxX([UIScreen mainScreen].bounds), 35)];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background@2x.png"]];
    if (count == 0) {
//        NewsController *nvc = [[NewsController alloc] init];
        
    
    }else{
        label.text = [NSString stringWithFormat:@"尊贵的主人有%ld条信息更新奥！", count];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.tintColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:15];
//    MyViewController *mvc = [[MyViewController alloc] init];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    [UIView animateWithDuration:2 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //最后从父视图中去掉
            [label removeFromSuperview];
        }];
    }];
    
}

#pragma mark 加载数据方法
- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:laughUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        NSLog(@"请求成功");
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:responseObject[@"value"]];
        for (NSDictionary *dic in array) {
            LaughModel *model = [[LaughModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", self.dataArray.count);
	return self.dataArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LaughTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifil forIndexPath:indexPath];
 
     LaughModel *model = self.dataArray[indexPath.row];
     cell.model = model;
     self.photoH = [model.imageHeight floatValue];
     self.photoW = [model.imageWidth floatValue];
     cell.photoView.frame = CGRectMake(10, 50, CGRectGetWidth([UIScreen mainScreen].bounds) - 20 , self.photoH);
     
     return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return self.photoH + 50;
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
