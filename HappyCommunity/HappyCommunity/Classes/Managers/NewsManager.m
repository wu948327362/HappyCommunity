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
#import "WeatherModel.h"
static NewsManager *manager = nil;

@interface NewsManager ()

@end
@implementation NewsManager
/**
 *  单例0
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
- (void)requestWithUrl:(NSString *)url finish:(void (^)(NSMutableArray *))finish
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
            NSLog(@"请求成功");
            
            NSArray *arr = responseObject[@"itemList"];
            
            for (NSDictionary *d in arr) {
                NewsModel *model = [[NewsModel alloc] init];
                NSDictionary *dic = d[@"itemImage"];
                model.imgUrl1 = dic[@"imgUrl1"];
                model.itemTitle = d[@"itemTitle"];
                model.detailUrl = d[@"detailUrl"];
                model.itemType = d[@"itemType"];
                if (!([model.itemType isEqualToString:@"classtopic_flag"] || [model.itemTitle isEqualToString:@"如您看到此提示，请升级客户端到最新版本"])) {
                    [self.data addObject:model];
                }
            }
            
            finish(self.data);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败%@", error);
        }];

    });
    
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
    if (self.data.count>=index) {
        return model;
    }else{
        return nil;
    }
    return model;
}

//根据返回的json数据得到model
- (WeatherModel *)getWeatherModelWithStr:(NSString *)string{
    WeatherModel *model = [[WeatherModel alloc] init];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *dict = [dic[@"HeWeather data service 3.0"] firstObject];
    
    NSArray *arr = dict[@"daily_forecast"];
    
    for (NSDictionary *d in arr) {
        NSDictionary *now = [dict[@"hourly_forecast"] firstObject];
        
        NSString *nowDate = [[now[@"date"] componentsSeparatedByString:@" "] firstObject];
        
        NSString *date = d[@"date"];
        if ([date isEqualToString:nowDate]) {
            model.max = d[@"tmp"][@"max"];
            model.min = d[@"tmp"][@"min"];
            model.dir = d[@"wind"][@"dir"];
            model.sc = d[@"wind"][@"sc"];
            model.txt_d = d[@"cond"][@"txt_d"];
            model.txt_n = d[@"cond"][@"txt_n"];
            
        }
    }
    model.txt = dict[@"suggestion"][@"drsg"][@"txt"];
    
    return model;
}
@end











