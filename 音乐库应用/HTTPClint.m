//
//  HTTPClint.m
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "HTTPClint.h"

@implementation HTTPClint
-(id)getRequest:(NSString *)url
{
    return nil;
}
-(id)postRequest:(NSString *)url boby:(NSString *)boby
{
    return nil;
}
-(UIImage *)downloadImage:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:data];
}
@end
