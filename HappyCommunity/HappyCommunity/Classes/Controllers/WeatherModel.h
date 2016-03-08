//
//  WeatherModel.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

// 白天温度
@property (nonatomic, copy) NSString *max;
// 夜晚温度
@property (nonatomic, copy) NSString *min;
// 白天风向
@property (nonatomic, copy) NSString *dir;
// 风力大小
@property (nonatomic, copy) NSString *sc;
// 白天天气
@property (nonatomic, copy) NSString *txt_d;
// 夜晚天气
@property (nonatomic, copy) NSString *txt_n;
// 温馨提示
@property (nonatomic, copy) NSString *txt;

@end
