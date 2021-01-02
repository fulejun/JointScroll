//
//  LJScrollableViewController.h
//  FishingDay
//
//  Created by lj on 2020/12/19.
//  Copyright © 2020 lj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJScrollableViewController : UIViewController

-(instancetype)initWithViewControllers:(NSArray*)viewControllers;
-(void)changeScrollStatus:(BOOL)canScroll;

@property(nonatomic,strong)NSArray *viewControllersAry;


@end

NS_ASSUME_NONNULL_END
