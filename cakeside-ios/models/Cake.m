#import "Cake.h"

@implementation Cake
+ (Cake *)initFromJSON:(NSDictionary *)jsonData;
{
  NSLog(@"%@", jsonData);
  Cake *result = [[Cake alloc] init];
  result.id = [[jsonData objectForKey:@"id"] integerValue];
  result.name = [jsonData objectForKey:@"name"];
  result.photo = [jsonData objectForKey:@"photo"];
  return result;
}

@end
