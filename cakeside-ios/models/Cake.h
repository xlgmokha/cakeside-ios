//
//  Cake.h
//  cakeside-ios
//
//  Created by mo khan on 2013-07-14.
//  Copyright (c) 2013 mo khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cake : NSObject
+ (Cake *)initFromJSON:(NSDictionary *)jsonData;
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;
@end
