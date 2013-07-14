//
//  Cake.m
//  cakeside-ios
//
//  Created by mo khan on 2013-07-14.
//  Copyright (c) 2013 mo khan. All rights reserved.
//

#import "Cake.h"

@implementation Cake
+ (Cake *)initFromJSON:(NSDictionary *)jsonData;
{
         NSLog(@"%@", jsonData);
  Cake *result = [[Cake alloc] init];
  result.id = [[jsonData objectForKey:@"id"] integerValue];
  result.name = [jsonData objectForKey:@"name"];
  return result;
}

@end
