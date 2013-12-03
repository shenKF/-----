//
//  PersistencyManager.h
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
@interface PersistencyManager : NSObject
-(NSArray*)getAlbums;
-(void)addAlbum:(Album*)album atIndex:(int)index;
-(void)deleteAlbumAtindex:(int)index;
-(void)saveImage:(UIImage *)image filename:(NSString *)filename;
-(UIImage *)getImage:(NSString *)filiname;
-(void)saveAlbums;
@end
