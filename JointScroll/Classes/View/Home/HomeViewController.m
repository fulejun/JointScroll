//
//  HomeViewController.m
//  JointScroll
//
//  Created by 乐军付 on 2020/12/20.
//

#import "HomeViewController.h"
#import "JointScrollTableView.h"
#import "LJScrollableViewController.h"
#import "SubViewController.h"

#import "Macros.h"
#import "UIView+Additions.h"
#import <ReactiveObjC/ReactiveObjC.h>


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JointScrollTableView *parentTableView;
@property(nonatomic,strong) LJScrollableViewController *scrollableView;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,assign)CGPoint triggerPoint;
@property(nonatomic,assign)int statusbarFlag;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusbarFlag = 1;
    self.canScroll = YES;
    [self buildUI];
    [self customNavBars];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
}

- (void)changeScrollStatus {
    self.canScroll = YES;
    [_scrollableView changeScrollStatus:NO];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)buildUI {
    [self.view addSubview:self.parentTableView];
    [self.parentTableView setTableHeaderView:self.header];
    [self.parentTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBarHeight)];
    self.triggerPoint = CGPointMake(0, self.header.height-NavBarHeight);
}

-(void)subViewWithCell:(UITableViewCell*)cell {
    NSArray *viewNames = @[@"关注", @"推荐", @"头条", @"时事", @"体育", @"科技", @"生活"];
    NSMutableArray *views = [NSMutableArray array];
    for (int i = 0; i < viewNames.count; i++) {
        SubViewController *sub = [[SubViewController alloc] init];
        sub.title = viewNames[i];
        [views addObject:sub];
    }
    _scrollableView = [[LJScrollableViewController alloc] initWithViewControllers:views];
    [self addChildViewController:_scrollableView];
    [cell.contentView addSubview:_scrollableView.view];
}

#pragma mark - NavBars
-(void)customNavBars {
    //设置标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor darkGrayColor]
    }];

    [RACObserve(self.parentTableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        CGPoint point = [(NSValue*)x CGPointValue];
        if (point.y >= self.triggerPoint.y) {
            self.navigationController.navigationBar.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.navigationBar.alpha = 1;
                self.statusbarFlag = 0;
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.navigationBar.alpha = 0;
                self.statusbarFlag = 1;
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.statusbarFlag == 1) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT-NavBarHeight-TabBarHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil];
    cell.backgroundColor = UIColor.magentaColor;
    [self subViewWithCell:cell];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.parentTableView) {
        if (!self.canScroll) {
            self.parentTableView.contentOffset = self.triggerPoint;
            [_scrollableView changeScrollStatus:YES];
        }else if(scrollView.contentOffset.y >= self.triggerPoint.y ){
            self.parentTableView.contentOffset = self.triggerPoint;
            self.canScroll = NO;
            [_scrollableView changeScrollStatus:YES];
        }
    } else {
//        NSLog(@"parent-->sub");
//        if (!self.canChildViewScroll) {
//            self.subView.newsTable.contentOffset = CGPointZero;
//        }else if (scrollView.contentOffset.y <= 0) {
//            self.canParentViewScroll = YES;
//            self.subView.canScroll = NO;
//        }
    }
}

#pragma mark - LazyLoads
-(JointScrollTableView*)parentTableView {
    if (_parentTableView == nil) {
        _parentTableView = [[JointScrollTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain JSTableType:JSTableParent];
        _parentTableView.dataSource = self;
        _parentTableView.delegate = self;
        _parentTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _parentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _parentTableView;
}

-(UIView*)header {
    if (_header == nil) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
        headerImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
        [_header addSubview:headerImageView];
    }
    return _header;
}

-(UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 80, 80);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
