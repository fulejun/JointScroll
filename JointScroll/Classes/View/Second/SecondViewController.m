//
//  SecondViewController.m
//  JointScroll
//
//  Created by lj on 2020/12/20.
//

#import "SecondViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "JointScrollTableView.h"
#import "UIView+Additions.h"
#import "Macros.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)JointScrollTableView *parentTableView;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,strong)NSMutableArray *subTables;

@property(nonatomic,assign)BOOL canParentScroll;
@property(nonatomic,assign)BOOL canChildScroll;
@property(nonatomic,assign)CGPoint triggerPoint;
@property(nonatomic,assign)int statusbarFlag;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    [self customNavBars];
}

-(void)buildUI {
    [self.view addSubview:self.parentTableView];
    [self.parentTableView setTableHeaderView:self.header];
    [self.parentTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBarHeight)];
    
    _canParentScroll = YES;
    _canChildScroll = NO;
    
    self.statusbarFlag = 1;
    self.triggerPoint = CGPointMake(0, self.header.height-NavBarHeight);
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
    if (tableView == self.parentTableView) {
        return 1;
    }
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.parentTableView) {
        return SCREEN_HEIGHT-NavBarHeight-TabBarHeight;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.parentTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil];
        [self configSubTables:cell];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil];
    cell.textLabel.text = [NSString stringWithFormat:@"index:%ld",indexPath.row];
    return cell;
    
}

-(void)configSubTables:(UITableViewCell*)cell {
    //这里的标题没有显示出来，有需求可以
    NSArray *viewNames = @[@"关注", @"推荐", @"头条", @"时事", @"体育", @"科技", @"生活"];
    _subTables = [NSMutableArray array];
    for (int i = 0; i < viewNames.count; i++) {
        //这里的Subview是用Table实现的，可以换成View或者ViewController也是可以的，当然必须把TableViwe暴露出来，方便统一控制偏移
        //这里使用一个数组把全部table保存起来
        UITableView *subTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight-TabBarHeight) style:UITableViewStylePlain];
        subTableView.dataSource = self;
        subTableView.delegate = self;
        subTableView.showsVerticalScrollIndicator = NO;
        subTableView.backgroundColor = UIColor.whiteColor;
        subTableView.tag = i;
        if (@available(iOS 11.0, *)) {
            subTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_subTables addObject:subTableView];
        [self.mainScrollView addSubview:subTableView];
    }
    [self.mainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*viewNames.count, SCREEN_HEIGHT-NavBarHeight-TabBarHeight)];
    [cell.contentView addSubview:self.mainScrollView];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ///如果捕获到的滚动视频是左右滚动的scrollView时，就把上下滚动的tableView设为不可滚动,
    ///相应的在滚动结束时，要把tableView的滚动设成为可滚动
    if (self.mainScrollView == scrollView) {
        self.parentTableView.scrollEnabled = NO;
    }
    if (scrollView == self.parentTableView) {
        if (!self.canParentScroll) {
            self.parentTableView.contentOffset = self.triggerPoint;
            self.canChildScroll = YES;
        }else if(scrollView.contentOffset.y >= self.triggerPoint.y ){
            self.parentTableView.contentOffset = self.triggerPoint;
            self.canParentScroll = NO;
            self.canChildScroll = YES;
        }
    } else {
        if (!self.canChildScroll) {
            for (UITableView *table in _subTables) {
                table.contentOffset = CGPointZero;
            }
        }else if (scrollView.contentOffset.y <= 0) {
            self.canParentScroll = YES;
            self.canChildScroll = NO;
        }
    }
}

///当左右滚动结束时，要把tableView的上下滚动设成为可滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.parentTableView.scrollEnabled = YES;
}

#pragma mark - LazyLoads

-(JointScrollTableView*)parentTableView {
    if (_parentTableView == nil) {
        _parentTableView = [[JointScrollTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

-(UIScrollView*)mainScrollView {
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight-TabBarHeight)];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _mainScrollView;
}

@end
