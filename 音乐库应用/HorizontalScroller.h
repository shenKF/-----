//
//  HorizontalScroller.h
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView<UIScrollViewDelegate>
@property (nonatomic,assign) id<HorizontalScrollerDelegate> delegate;
-(void)reload;
@end

@protocol HorizontalScrollerDelegate <NSObject>
@required
-(NSInteger)numberOfViewForHorizontalScroller:(HorizontalScroller*)scroller;
-(UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(int)index;
-(void)horizontalScroller:(HorizontalScroller*)scroller clickedViewAtindex:(int)index;
@optional
-(NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller*)scroller;
@end