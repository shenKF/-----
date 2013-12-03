//
//  Album+TableRepresentation.h
//  音乐库应用
//
//  Created by ken on 13-11-29.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)
-(NSDictionary*)tr_tableRepresentation;
@end
