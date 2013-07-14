//
//  NSDictionary+NSDictionary_Additions.m
//  fastcab-driver
//
//  Created by Rick Cotter on 12-03-20.
//  Copyright (c) 2012 Assn. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

-(id) objectForKey:(NSString *)key defaultValue:(id)defaultValue {
    id value = [self objectForKey:key];
    if (!value) {
        return defaultValue;        
    }
    
    if (value == [NSNull null]) {
        return defaultValue;
    }
        
    return value;
}

@end
