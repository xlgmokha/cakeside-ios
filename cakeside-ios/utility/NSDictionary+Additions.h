//
//  NSDictionary+NSDictionary_Additions.h
//  fastcab-driver
//
//  Created by Rick Cotter on 12-03-20.
//  Copyright (c) 2012 Assn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)
-(id) objectForKey:(NSString *)key defaultValue:(id)defaultValue;
@end
