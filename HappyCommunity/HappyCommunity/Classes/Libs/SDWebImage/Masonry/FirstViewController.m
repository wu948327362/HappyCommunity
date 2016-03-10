//
//  FirstViewController.m
//  MasonryDemo
//
//  Created by 陈向阳 on 15/7/22.
//  Copyright (c) 2015年 陈向阳. All rights reserved.
//

#import "FirstViewController.h"
#import "Masonry.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
//    scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.78 blue:0.6 alpha:0.8];
    [self.view addSubview:scrollView];
    __weak UIView *sv = self.view;
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).width.insets(UIEdgeInsetsMake(10, 10, 50, 10));
        
    }];
    
    //scrollView上添加一个内容视图
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    
    //约束宽 和scrollview一样大小
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
        
    }];
    
    int count = 10;
    UIView *last = nil;
    //添加十个view
    for (int i = 0 ; i < count ; i++) {
        
        UIView *view = [UIView new];
        [container addSubview:view];
        
        view.backgroundColor = [UIColor colorWithRed:(arc4random() % 256/256.0) green:(arc4random() % 256/256.0) blue:(arc4random() % 256/256.0) alpha:1];
        
        //约束宽和高
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@(20*i));
            
            if(last)
            {
                //中间的 后一个与前一个view紧连
                make.top.mas_equalTo(last.mas_bottom);
                
            }else
            {
                 //第一个 y相对于内容视图为0 y ＝ 0
                make.top.mas_equalTo(container.mas_top);
                
            }
        }];
        
        last = view;
    }
    
    //scrollview的底部和最后一个视图的底部重合  自动计算scrollview的高
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(last.mas_bottom);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
