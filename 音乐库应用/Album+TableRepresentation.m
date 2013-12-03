//
//  Album+TableRepresentation.m
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)
-(NSDictionary *)tr_tableRepresentation{
    return @{@"titles": @[@"Artist",@"Album",@"Genre",@"Year"],@"values":@[self.artist,self.title,self.genre,self.year]};
}
@end
