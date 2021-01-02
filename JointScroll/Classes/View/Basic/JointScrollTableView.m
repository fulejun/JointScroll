//
//  JointScrollTableView.m
//  JointScroll
//
//  Created by lj on 2020/12/21.
//

#import "JointScrollTableView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface JointScrollTableView()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,assign)CGPoint strictPoint;
@end

@implementation JointScrollTableView

//-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style JSTableType:(JSTable)type {
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
    }
    return self;
}

//事件穿透
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
