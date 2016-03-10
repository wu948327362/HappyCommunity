//
//  WeatherViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/8.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "WeatherViewController.h"
#import "RESideMenu.h"
#import "APIStoreSDK.h"
#import "WeatherModel.h"
#import "NewsManager.h"

@interface WeatherViewController ()<UITextViewDelegate, UITextFieldDelegate>

// UITextView的属性
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

// 搜索框的属性
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

// 白天温度的属性
@property (weak, nonatomic) IBOutlet UILabel *dayTemperatureLabel;

// 夜晚温度的属性
@property (weak, nonatomic) IBOutlet UILabel *nightTemperatureLabel;

// 白天风向的属性
@property (weak, nonatomic) IBOutlet UILabel *dayWindLabel;

// 风力大小的属性
@property (weak, nonatomic) IBOutlet UILabel *nightWindLabel;

// 白天天气的属性
@property (weak, nonatomic) IBOutlet UILabel *dayWeatherLabel;

// 夜晚天气的属性
@property (weak, nonatomic) IBOutlet UILabel *nightWeatherLabel;

@property(nonatomic,strong)WeatherModel *model;


@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UITextView的代理
    self.descriptionTextView.delegate = self;
    
    self.title = @"天气";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(presentLeftMenuViewController:)];
    
    // 城市拼音
    self.searchTextField.text = @"";
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    // Do any additional setup after loading the view.
}

#pragma mark 取消UITextView的可编辑状态
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

#pragma mark 跳转到左侧的菜单栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 搜索按钮的点击事件
- (IBAction)searchButton:(UIButton *)sender {
    NSString *city = self.searchTextField.text;
    
    // 实例化一个回调,处理请求的返回值
    APISCallBack *callBack = [APISCallBack alloc];
    callBack.onSuccess = ^(long status, NSString* responseString) {
        NSLog(@"onSuccess");
        if(responseString != nil) {
            
            WeatherModel *wmodel = [[NewsManager shareInstance] getWeatherModelWithStr:responseString];
            self.model = wmodel;
            
        }
    };
    
    callBack.onError = ^(long status, NSString* responseString) {
        NSLog(@"onError");
        
    };
    
    callBack.onComplete = ^() {
        NSLog(@"onComplete");
    };
    
    //部分参数
    NSString *uri = @"http://apis.baidu.com/heweather/weather/free";
    NSString *method = @"post";
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:city forKey:@"city"];
    
    //请求API
    [ApiStoreSDK executeWithURL:uri method:method apikey:@"8a63164e956dcdbb2cc593acbb88e6a1" parameter:parameter callBack:callBack];
    [self.view endEditing:YES];
}

- (void)setModel:(WeatherModel *)model{
    _model = model;
    
    self.dayTemperatureLabel.text = [NSString stringWithFormat:@"%@℃", model.max];
    self.dayWindLabel.text = model.dir;
    self.nightWindLabel.text = model.sc;
    self.dayWeatherLabel.text = model.txt_d;
    self.nightWeatherLabel.text = model.txt_n;
    self.descriptionTextView.text = model.txt;
    self.nightTemperatureLabel.text = [NSString stringWithFormat:@"%@℃", model.min];
    
}

#pragma mark 取消TextField键盘的第一响应者
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
