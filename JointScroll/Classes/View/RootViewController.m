//
//  RootViewController.m
//  JointScroll
//
//  Created by lj on 2020/12/20.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "BaseNavigationViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

-(instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    HomeViewController *home = [[HomeViewController alloc] init];
    home.title = @"首页";
    home.tabBarItem.image = [UIImage imageNamed:@"nav_home_off"];
    home.tabBarItem.selectedImage = [UIImage imageNamed:@"nav_home_on"];
    
    SecondViewController *second = [[SecondViewController alloc] init];
    second.title = @"资讯";
    second.tabBarItem.image = [UIImage imageNamed:@"nav_news_off"];
    second.tabBarItem.selectedImage = [UIImage imageNamed:@"nav_news_on"];
    
    ThirdViewController *Third = [[ThirdViewController alloc] init];
    Third.title = @"信息";
    Third.tabBarItem.image = [UIImage imageNamed:@"nav_sig_off"];
    Third.tabBarItem.selectedImage = [UIImage imageNamed:@"nav_sig_on"];
    
    FourthViewController *Fourth = [[FourthViewController alloc] init];
    Fourth.title = @"设置";
    Fourth.tabBarItem.image = [UIImage imageNamed:@"nav_mine_off"];
    Fourth.tabBarItem.selectedImage = [UIImage imageNamed:@"nav_mine_on"];
    
    BaseNavigationViewController *nav1 = [[BaseNavigationViewController alloc] initWithRootViewController:home];
    BaseNavigationViewController *nav2 = [[BaseNavigationViewController alloc] initWithRootViewController:second];
    BaseNavigationViewController *nav3 = [[BaseNavigationViewController alloc] initWithRootViewController:Third];
    BaseNavigationViewController *nav4 = [[BaseNavigationViewController alloc] initWithRootViewController:Fourth];
    
    NSArray *views = @[nav1,nav2,nav3,nav4];
    self.viewControllers = views;
    
    UIColor *selectedColor = [UIColor colorWithRed:150/255.0 green:75/255.0 blue:0/255.0 alpha:1.0];
    UIColor *normalColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0];
    
    [[UITabBar appearance] setTintColor:selectedColor];
    
    [[UIBarItem appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys: normalColor, NSForegroundColorAttributeName,nil]
                                          forState:UIControlStateNormal];
    
    [[UIBarItem appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:selectedColor, NSForegroundColorAttributeName, nil]
                                          forState:UIControlStateSelected];
}

@end
