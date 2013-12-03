//
//  HorizontalScroller.m
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "HorizontalScroller.h"
#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 280
#define VIEWS_OFFSEt 280
@implementation HorizontalScroller
{
    UIScrollView *scroller;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}
- (void)scrollerTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    for (int index = 0; index < [self.delegate numberOfViewForHorizontalScroller:self]; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame,location)) {
            [self.delegate horizontalScroller:self clickedViewAtindex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

-(void)reload
{
    //如果没有委托，那么不需要做任何事情，仅仅返回即可
    if (self.delegate == nil) {
        return;
    }
    //移除之前添加到滚动视图的子视图
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        [obj removeFromSuperview];
    }];
    
    //所有的视图的位置从给定的偏移量开始。
    CGFloat xValue = VIEWS_OFFSEt;
    for (int i = 0; i < [self.delegate numberOfViewForHorizontalScroller:self]; i++) {
        xValue += VIEW_PADDING;
        //HorizontalScroller 每次从委托请求视图对象，并且根据预先设置的边框来水平的放置这些视图
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue,VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroller addSubview:view];
        xValue +=VIEW_DIMENSIONS + VIEW_PADDING;
    }
    //一旦所有视图都设置好了以后，设置 UIScroller 的内容偏移以便用户可以滚动的查看所有的专辑封面
    [scroller setContentSize:CGSizeMake(xValue + VIEWS_OFFSEt, self.frame.size.height)];
    //initialViewIndexForHorizontalScroller:方法，这个检测是需要的，因为这个方法是可选的。如果委托没有实现这个方法，0就是缺省值。最后设置滚动视图为协议规定的初始化视图的中间。
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        int initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS + (2 * VIEW_PADDING)), 0) animated:YES];
    }
}
//didMoveToSuperview方法会在视图被增加到另外一个视图作为子视图的时候调用，这正是重新加载滚动视图的最佳时机
-(void)didMoveToSuperview{
    [self reload];
}

-(void)centerCurrentView
{
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSEt/2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DIMENSIONS + (2 * VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DIMENSIONS + (2 * VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal, 0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtindex:viewIndex];
}

//在用户完成拖动的时候通知委托
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self centerCurrentView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
