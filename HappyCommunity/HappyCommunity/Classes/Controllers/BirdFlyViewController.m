//
//  BirdFlyViewController.m
//  HappyCommunity
//
//  Created by lanou3g on 16/3/7.
//  Copyright © 2016年 吴文涛. All rights reserved.
//

#import "BirdFlyViewController.h"

//3.0初速度需要60秒减少至0
const float MaxTime = 50;
//加速度，方向向下
const float VG = 0.05;
//初速度
const float MaxV = 2.5;

//初始化总路程
const float AllLength = 692;

typedef enum {
    
    GameNoStart,
    GamePlaying,
    GameOver
    
} GameState;


@interface BirdFlyViewController ()

{
    NSTimer *birdTimer;
    //开始游戏开关
    BOOL isStart;
    //游戏状态
    GameState gameState;
    
    //总场景
    UIView *playLayer;
    
    //小鸟
    UIImageView *birdImgView;
    //小鸟的壳
    UIView *birdClotherView;
    
    //跳跃时间
    float maxJumpTime;
    
    //滚动的背景
    UIView *bgView1;
    UIView *bgView2;
    
    //管道
    UIView *pileImgView11;
    UIView *pileImgView12;
    UIView *pileImgView21;
    UIView *pileImgView22;
    
    //得分
    UILabel *scoreLabel;
    NSInteger score;
}


@end

@implementation BirdFlyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initBirdAndOther];
    
    birdTimer = [NSTimer scheduledTimerWithTimeInterval:0.008
                                                 target:self
                                               selector:@selector(update)
                                               userInfo:nil
                                                repeats:YES];
}

#pragma mark - 横竖屏幕
//只支持portait,不能旋转:
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark - 频率刷新
- (void) update
{
    //判断
    if (isStart == YES && gameState == GamePlaying)
    {
        [self updateBird];
        [self updateBg];
        [self setPiles];
        [self checkBirdRect];
    }
}

#pragma mark -
#pragma mark - 初始化
- (void) initBirdAndOther
{
    //初始化总场景
    playLayer = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:playLayer];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    //初始化障碍物
    bgView1 = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [playLayer addSubview:bgView1];
    [playLayer addSubview:bgView2];
    
    //中间的管道
    pileImgView11 = [self addPilesAtX:0];
    [bgView1 addSubview:pileImgView11];
    pileImgView11.hidden = YES;
    pileImgView21 = [self addPilesAtX:0];
    [bgView2 addSubview:pileImgView21];
    
    pileImgView12 = [self addPilesAtX:160];
    [bgView1 addSubview:pileImgView12];
    pileImgView12.hidden = YES;
    pileImgView22 = [self addPilesAtX:160];
    [bgView2 addSubview:pileImgView22];
    
    //底部草
    UIImageView *buttomImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 53, 320, 53)];
    buttomImg1.image = [UIImage imageNamed:@"ground"];
    [bgView1 addSubview:buttomImg1];
    UIImageView *buttomImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 53, 320, 53)];
    buttomImg2.image = [UIImage imageNamed:@"ground"];
    [bgView2 addSubview:buttomImg2];
    
    //小鸟的衣服
    birdClotherView = [[UIView alloc] initWithFrame:CGRectMake(60, [[UIScreen mainScreen] bounds].size.height/2 + 80, 40, 30)];
    [playLayer addSubview:birdClotherView];
    
    //初始化小鸟
    birdImgView = [[UIImageView alloc] init];
    birdImgView.frame = CGRectMake(0, 0, 60, 40);
    birdImgView.image = [UIImage imageNamed:@"bird"];
    [birdClotherView addSubview:birdImgView];
    
    //得分
//    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 30)];
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 350, 80, 300, 30)];
    scoreLabel.textAlignment = NSTextAlignmentRight;
    [playLayer addSubview:scoreLabel];
    scoreLabel.text = @"score: 0";
}


#pragma mark -
#pragma mark - 点击屏幕开始和跳跃
- (void) screenTap
{
    //没点击一次
    maxJumpTime = MaxTime;
    
    if (isStart == NO)
    {
        isStart = YES;
        gameState = GamePlaying;
        
        for (UIView *tmpView in self.view.subviews)
        {
            [tmpView removeFromSuperview];
        }
        
        [self initBirdAndOther];
    }
    
    //仰角30度旋转
    CGAffineTransform transform = CGAffineTransformIdentity;
    birdImgView.transform = CGAffineTransformRotate(transform,  -30 * M_PI / 180 );
}

#pragma mark -
#pragma mark - 设置管道
- (void) setPiles
{
    NSInteger tmpY = rand()%120;
    
    if (bgView1.frame.origin.x == -53)
    {
        //设置第一个管道
        CGRect rect = pileImgView11.frame;
        rect.origin.y = tmpY - 120;
        pileImgView11.frame = rect;
        if (pileImgView11.hidden == YES)
        {
            pileImgView11.hidden = NO;
        }
    }
    else if (bgView1.frame.origin.x == -213)
    {
        //设置第二个管道
        CGRect rect = pileImgView12.frame;
        rect.origin.y = tmpY - 120;
        pileImgView12.frame = rect;
        if (pileImgView12.hidden == YES)
        {
            pileImgView12.hidden = NO;
        }
    }
    else if (bgView2.frame.origin.x == -53)
    {
        //设置第三个管道
        CGRect rect = pileImgView21.frame;
        rect.origin.y = tmpY - 120;
        pileImgView21.frame = rect;
    }
    else if (bgView2.frame.origin.x == -213)
    {
        //设置第四个管道
        CGRect rect = pileImgView22.frame;
        rect.origin.y = tmpY - 120;
        pileImgView22.frame = rect;
    }
}

#pragma mark -
#pragma mark - 碰撞检测
- (void) checkBirdRect
{
    //碰撞检测
    float birdRightX = birdClotherView.frame.origin.x + 34;
    float birdButtomY = birdClotherView.frame.origin.y + 24;
    float birdUpY = birdClotherView.frame.origin.y;
    
    //计算障碍物
    //下面的柱子和上面的柱子检测
    if ((birdRightX - 0 == bgView1.frame.origin.x && birdUpY >= 319 + (pileImgView11.frame.origin.y + 120)))
    {
        if (pileImgView11.hidden == NO)
        {
            [self gameOver];
        }
    }
    else  if(birdRightX - 0 == bgView1.frame.origin.x && birdButtomY <= 199 + (pileImgView11.frame.origin.y + 120))
    {
        if (pileImgView11.hidden == NO)
        {
            [self gameOver];
        }
    }
    
    if ((birdRightX - 160 == bgView1.frame.origin.x && birdUpY >= 319 + (pileImgView12.frame.origin.y + 120)))
    {
        if (pileImgView12.hidden == NO)
        {
            [self gameOver];
        }
    }
    else  if(birdRightX - 160 == bgView1.frame.origin.x && birdButtomY <= 199 + (pileImgView12.frame.origin.y + 120))
    {
        if (pileImgView12.hidden == NO)
        {
            [self gameOver];
        }
    }
    
    if ((birdRightX - 0 == bgView2.frame.origin.x && birdUpY >= 319 + (pileImgView21.frame.origin.y + 120)))
    {
        [self gameOver];
    }
    else  if(birdRightX - 0 == bgView2.frame.origin.x && birdButtomY <= 199 + (pileImgView21.frame.origin.y + 120))
    {
        [self gameOver];
    }
    
    if ((birdRightX - 160 == bgView2.frame.origin.x && birdUpY >= 319 + (pileImgView22.frame.origin.y + 120)))
    {
        [self gameOver];
    }
    else  if(birdRightX - 160 == bgView2.frame.origin.x && birdButtomY <= 199 + (pileImgView22.frame.origin.y + 120))
    {
        [self gameOver];
    }
    
    //上下柱子横截面检测
    if (birdRightX - 0 > bgView1.frame.origin.x && bgView1.frame.origin.x >= birdRightX - 0 - 52 - 34 && (birdUpY <= 199 + (pileImgView11.frame.origin.y + 120) || birdButtomY >= 319 + (pileImgView11.frame.origin.y + 120)))
    {
        if (pileImgView11.hidden == NO)
        {
            [self gameOver];
        }
    }
    
    if (birdRightX - 160 > bgView1.frame.origin.x && bgView1.frame.origin.x >= birdRightX - 160 - 52 - 34 && (birdUpY <= 199 + (pileImgView12.frame.origin.y + 120) || birdButtomY >= 319 + (pileImgView12.frame.origin.y + 120)))
    {
        if (pileImgView12.hidden == NO)
        {
            [self gameOver];
        }
    }
    
    if (birdRightX - 0 > bgView2.frame.origin.x && bgView2.frame.origin.x >= birdRightX - 0 - 52 - 34 && (birdUpY <= 199 + (pileImgView21.frame.origin.y + 120) || birdButtomY >= 319 + (pileImgView21.frame.origin.y + 120)))
    {
        if (pileImgView12.hidden == NO)
        {
            [self gameOver];
        }
    }
    
    if (birdRightX - 160 > bgView2.frame.origin.x && bgView2.frame.origin.x >= birdRightX - 160 - 52 - 34 && (birdUpY <= 199 + (pileImgView22.frame.origin.y + 120) || birdButtomY >= 319 + (pileImgView22.frame.origin.y + 120)))
    {
        [self gameOver];
    }
    
    //判断地平线
    if (birdButtomY >= [[UIScreen mainScreen] bounds].size.height - 53)
    {
        [self gameOver];
    }
}

#pragma mark -
#pragma mark - 碰撞处理
- (void) gameOver
{
    isStart = NO;
    gameState = GameOver;
    score = 0;
}

#pragma mark -
#pragma mark - 更新小鸟的坐标位置
- (void) updateBird
{
    maxJumpTime --;
    CGRect rect = birdClotherView.frame;
    if (maxJumpTime >= 0)
    {
        rect.origin.y = rect.origin.y - (MaxV - (MaxTime - maxJumpTime)*VG);
    }
    else
    {
        //俯角30度旋转
        CGAffineTransform transform = CGAffineTransformIdentity;
        birdImgView.transform = CGAffineTransformRotate(transform,  30 * M_PI / 180 );
        rect.origin.y = rect.origin.y - (maxJumpTime*VG);
    }
    birdClotherView.frame = rect;
}

- (void) updateBg
{
    CGRect rect1 = bgView1.frame;
    CGRect rect2 = bgView2.frame;
    
    if (rect1.origin.x <= -320)
    {
        rect1.origin.x = 320;
    }
    
    if (rect2.origin.x <= -320)
    {
        rect2.origin.x = 320;
    }
    
    rect1.origin.x = rect1.origin.x - 1;
    rect2.origin.x = rect2.origin.x - 1;
    
    bgView1.frame = rect1;
    bgView2.frame = rect2;
    
    if (rect1.origin.x == 0 || rect1.origin.x == -160 || rect2.origin.x == 0 || rect2.origin.x == -160)
    {
        if (pileImgView11.hidden == YES || pileImgView12.hidden == YES)
        {
            return;
        }
        
        score += 1;
        scoreLabel.text = [NSString stringWithFormat:@"score: %d",score];
    }
}

#pragma mark -
#pragma mark - 产生障碍物
- (UIView *) addPilesAtX:(float) originX
{
    NSInteger tmpY = rand()%120;
    //0位置和160的未知 山下间隔120px
    UIView *pileView = [[UIView alloc] initWithFrame:CGRectMake(originX, tmpY - 120, 52, 758)];
    
    UIImageView *pileImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 319)];
    pileImg1.image = [UIImage imageNamed:@"up_bar"];
    [pileView addSubview:pileImg1];
    UIImageView *pileImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 439, 52, 319)];
    pileImg2.image = [UIImage imageNamed:@"down_bar"];
    [pileView addSubview:pileImg2];
    
    return pileView;
    
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
