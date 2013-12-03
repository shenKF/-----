//
//  LibraryAPI.m
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "HTTPClint.h"

@interface LibraryAPI ()
{
    PersistencyManager *persistenceyManager;
    HTTPClint *httpClient;
    BOOL isOnline;
}
@end


@implementation LibraryAPI
+(LibraryAPI *)sharedInstance
{
    static LibraryAPI *_sharedInstance = nil;//声明一个静态变量，保存类的实例，确保它在类中的全局可用性。
    
    static dispatch_once_t oncePredicate;//声明一个静态变量 dispatch_once_t，它确保初始化器 代码只执行一次
    
    /*使用 Grand Central Dispatch(GCD)执行初始化 LibraryAPI 变量的 block.这 正是单例
     模式的关键:一旦类已经被初始化,初始化器永远不会再被调用*/
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

-(id)init{
    self = [super init];
    if (self) {
        persistenceyManager = [[PersistencyManager alloc] init];
        httpClient = [[HTTPClint alloc] init];
        isOnline = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    return self;
}

-(void)downloadImage:(NSNotification *)notification
{
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    imageView.image = [persistenceyManager getImage:[coverUrl lastPathComponent]];
    if (imageView.image == nil) {
        // 3
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            dispatch_sync(dispatch_get_main_queue(), ^{
            imageView.image = image;
            [persistenceyManager saveImage:image filename:[coverUrl lastPathComponent]];
        });
    });
    }
}

-(NSArray *)getAlbums
{
    return [persistenceyManager getAlbums];
}

-(void)addAlbum:(Album *)album atIndex:(int)index
{
    [persistenceyManager addAlbum:album atIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/addAlbum" boby:[album description]];
    }
}

-(void)deleteAlbumAtIndex:(int)index
{
    [persistenceyManager deleteAlbumAtindex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/deleteAlbum" boby:[@(index) description]];
    }
}

-(void)saveAlbums
{
    [persistenceyManager saveAlbums];
}

@end
