//
//  LJScrollableViewController.h
//  FishingDay
//
//  Created by 乐军付 on 2020/12/19.
//  Copyright © 2020 乐军付. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJScrollableViewController : UIViewController

-(instancetype)initWithViewControllers:(NSArray*)viewControllers;
-(void)changeScrollStatus:(BOOL)canScroll;

@property(nonatomic,strong)NSArray *viewControllersAry;


@end

NS_ASSUME_NONNULL_END
