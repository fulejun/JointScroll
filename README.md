# JointScroll
 
JointScroll是一个OC的多层嵌套滚动示例，代码中有两种实现方式，基本思路都是事件穿透。处理细节稍有不同，第二种相对更加简单

####首页
采用手势穿透的方式，让主视图实现UIGestureRecognizerDelegate协议，并让主视图能接收所有触摸事件。
<pre>
	//事件穿透
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *) otherGestureRecognizer {
		return YES;
}
</pre>


####资讯页
采用滚动位置侦听的控制方式。当视图滚动时，当检测到滚动视图是左右滚动的scrollView时，就把上下滚动的tableView设为不可滚动，当一次滚动结束时，要把tableView的滚动设成为可滚动。
<pre>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.mainScrollView == scrollView) {
        self.parentTableView.scrollEnabled = NO;
    }
    if (scrollView == self.parentTableView) {
        if (!self.canParentScroll) {
            self.parentTableView.contentOffset = self.triggerPoint;
            self.canChildScroll = YES;
        }else if(scrollView.contentOffset.y >= self.triggerPoint.y) {
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
</pre>


