//
//  CalendarCollectionCell.h
//  HappyCommunity
//
//  Created by lanou3g on 16/3/9.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayModel.h"
#import "Color.h"

@interface CalendarCollectionCell : UICollectionViewCell
{
    UILabel *day_lab;//今天的日期获取是节日
    UILabel *day_title;//显示标签
    UIImageView *photoView;//选中时的图片
}

@property(nonatomic, strong)CalendarDayModel *model;
@end
