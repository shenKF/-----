//
//  AlbumView.m
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
{
    UIImageView *coverImage;//专辑封面图
    UIActivityIndicatorView *indicator;//下载的指示器
}

-(id)initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height-10)];
        [self addSubview:coverImage];
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification" object:self userInfo:@{@"imageView":coverImage,@"coverUrl":albumCover}];
    }
    
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
    }
}

-(void)dealloc
{
    [coverImage removeObserver:self forKeyPath:@"image"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
