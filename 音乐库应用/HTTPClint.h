//
//  HTTPClint.h
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPClint : NSObject
-(id)getRequest:(NSString *)url;
-(id)postRequest:(NSString *)url boby:(NSString *)boby;
-(UIImage *)downloadImage:(NSString *)url;
@end
