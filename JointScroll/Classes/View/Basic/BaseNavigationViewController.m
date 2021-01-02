//
//  BaseNavigationViewController.m
//  JointScroll
//
//  Created by lj on 2020/12/21.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
