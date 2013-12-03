//
//  LibraryAPI.h
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
@interface LibraryAPI : NSObject
+ (LibraryAPI*)sharedInstance;
-(NSArray*)getAlbums;
-(void)addAlbum:(Album*)album atIndex:(int)index;
-(void)deleteAlbumAtIndex:(int)index;
-(void)saveAlbums;
@end
