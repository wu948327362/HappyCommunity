//
//  NewsManager.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsModel;
@interface NewsManager : NSObject
/** 单例*/
+ (instancetype)shareInstance;
/**
 *  根据url请求出的数据，得到一个数组
 *
 *  @param url url
 *
 *  @return array
 */
- (void)requestWithUrl:(NSString *)url finish:(void (^)(NSMutableArray *array))finish;
/** 根据数组得到数组个数*/
- (NSInteger)countOfArray;

/** 根据当前的index获得模型*/
- (NewsModel *)getModelWithIndex:(NSInteger)index;
/*数组*/
@property(nonatomic, strong)NSMutableArray *data;

@end
