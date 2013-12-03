//
//  Album.h
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject<NSCoding>
//这些变量在Album中都不需要修改它们的值，所以定义为只读的。
@property (nonatomic,strong,readonly) NSString *title,*artist,*genre,*coverUrl,*year;
-(id)initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year;
@end
