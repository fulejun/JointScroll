//
//  LJScrollableViewController.m
//  FishingDay
//
//  Created by lj on 2020/12/19.
//  Copyright © 2020 lj. All rights reserved.
//
#import "LJScrollableViewController.h"
#import "SubViewController.h"
#import "UIView+Additions.h"
#import "Macros.h"

#define kNavBarHeight 44.0
#define btnWidth 60


@interface LJScrollableViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *titleBtnView;
@property(nonatomic,strong)UIScrollView *containerView;
@property(nonatomic,strong)NSMutableArray *titleBtns;
@property(nonatomic,weak)UIButton *currentSelectedBtn;

@end

@implementation LJScrollableViewController
-(instancetype)initWithViewControllers:(NSArray *)viewControllers {
    if (self = [super init]){
        _viewControllersAry = [[NSArray alloc]initWithArray:viewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLayout];
    [self setupViewControllersAndTabBar];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _titleBtnView.contentOffset = CGPointZero;
}

-(void)changeScrollStatus:(BOOL)canScroll {
    for (int i = 0; i < _viewControllersAry.count; i++) {
        SubViewController *sub = (SubViewController *)_viewControllersAry[i];
        sub.canScroll = canScroll;
    }
}

#pragma mark - 添加视图按钮
-(void)setupViewControllersAndTabBar {
    float btnHeight = _titleBtnView.bounds.size.height;
    for (int i = 0; i<_viewControllersAry.count; i++) {
        //视图
        UIViewController *vc = (UIViewController*)_viewControllersAry[i];
        vc.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _containerView.frame.size.height-kNavBarHeight);
        [_containerView addSubview:vc.view];
        [self addChildViewController:vc];
        
         //创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, btnHeight);
        [btn setTitle:vc.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        btn.tag = i;
        [_titleBtnView addSubview:btn];
        [self.titleBtns addObject:btn];
        [btn addTarget:self action:@selector(setSelectTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        //设置第一个按钮和视图
        if (i==0) {
            [self setSelectTitleBtn:btn];
        }
    }
    //设置滚动区域
    [_titleBtnView setContentSize:CGSizeMake(_viewControllersAry.count*btnWidth, btnHeight)];
    [_containerView setContentSize:CGSizeMake(_viewControllersAry.count*SCREEN_WIDTH, _containerView.height)];
}


#pragma mark - 按钮事件
-(void)setSelectTitleBtn:(UIButton*)btn {
    _currentSelectedBtn.transform = CGAffineTransformIdentity;
    [_currentSelectedBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _currentSelectedBtn = btn;
    //移动滚动区、改变按钮大小和颜色
    [self moveTitleBtnToCentre:btn];
    //根据按钮显示View
    [_containerView setContentOffset:CGPointMake(SCREEN_WIDTH*btn.tag, 0) animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onChangePage" object:nil];
}

-(void)moveTitleBtnToCentre:(UIButton*)btn {
    CGFloat offsetX = btn.center.x - 0.5*SCREEN_WIDTH;
    CGFloat maxScollW = _titleBtnView.contentSize.width - SCREEN_WIDTH;
    if ( offsetX < 0) {
        offsetX = 0;
    }else if (offsetX > maxScollW){
        offsetX = maxScollW;
    }
    [_titleBtnView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


#pragma mark - ScrollDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton *btn = _titleBtns[page];
    [self setSelectTitleBtn:btn];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger leftIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    NSInteger rightIndex = leftIndex + 1;
    UIButton *leftBtn = _titleBtns[leftIndex];
    NSInteger count = _titleBtns.count;
    
    CGFloat scaleR = scrollView.contentOffset.x/SCREEN_WIDTH;
    scaleR -= leftIndex;
    CGFloat scaleL = 1 - scaleR;
    
    if(rightIndex < count){
        UIButton *rightBtn = _titleBtns[rightIndex];
        rightBtn.transform = CGAffineTransformMakeScale(1+ 0.3 * scaleR, 1+ 0.3 * scaleR);
        [rightBtn setTitleColor:[UIColor colorWithRed:1*scaleR green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }
    leftBtn.transform = CGAffineTransformMakeScale(1+ 0.3 * scaleL, 1+ 0.3 * scaleL);
    [leftBtn setTitleColor:[UIColor colorWithRed:1*scaleL green:0 blue:0 alpha:1] forState:UIControlStateNormal];
}

/*
 当滑动结束时，把所有非选中的按钮字体设置成黑色
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger leftIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton *leftBtn = _titleBtns[leftIndex];
    
    for (int i = 0; i <_titleBtns.count; i++) {
        UIButton *btn = _titleBtns[i];
        if(btn == leftBtn){
            [leftBtn setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
            btn.transform = CGAffineTransformMakeScale(1, 1);
        }
    }
}

#pragma mark - LazyLoad
-(NSMutableArray*)titleBtns {
    if (!_titleBtns) {
        _titleBtns = [[NSMutableArray alloc] init];
    }
    return _titleBtns;
}

-(void)setupLayout {
    _titleBtnView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kNavBarHeight)];
    _titleBtnView.backgroundColor = [UIColor lightGrayColor];
    [_titleBtnView setShowsHorizontalScrollIndicator:NO];
    [_titleBtnView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_titleBtnView];
    //内容视图
    _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, self.view.bounds.size.width, SCREEN_HEIGHT-NavBarHeight-TabBarHeight-kNavBarHeight)];
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.pagingEnabled = YES;
    _containerView.delegate = self;
    _containerView.bounces = NO;
    [self.view addSubview:_containerView];
}


@end

