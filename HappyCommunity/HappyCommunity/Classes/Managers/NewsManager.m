//
//  NewsManager.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "NewsManager.h"
#import "NewsModel.h"
#import <AFNetworking.h>
#import "NewsController.h"
static NewsManager *manager = nil;

@interface NewsManager ()
@property(nonatomic, strong)NSMutableArray *data;
@end
@implementation NewsManager
/**
 *  单例
 */
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NewsManager alloc] init];
    });
    return manager;
}

//懒加载
- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
        
    }
    return _data;
}

/**
 *  根据新闻的URL获得可变数组
 *
 *  @param url NewsUrl
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)requestWithUrl:(NSString *)url finish:(void (^)())finish
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        NSLog(@"请求成功");
        NSArray *arr = responseObject[@"data"][@"itemList"];
        for (NSDictionary *d in arr) {
            NewsModel *model = [[NewsModel alloc] init];
            NSDictionary *dic = d[@"itemImage"];
            model.imgUrl1 = dic[@"imgUrl1"];
            model.itemTitle = d[@"itemTitle"];
            [self.data addObject:model];
        }
        
//        NSLog(@"%@", self.data);
        
        finish();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@", error);
    }];
    return self.data;
}

/**
 *  根据返回的数组得到数组个数
 */
- (NSInteger)countOfArray
{
    return self.data.count;
}

/**
 *  根据数组
 */
- (NewsModel *)getModelWithIndex:(NSInteger)index
{
    NewsModel *model = self.data[index];
    return model;
}
@end
