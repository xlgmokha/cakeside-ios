#import <Foundation/Foundation.h>
@interface Cake : NSObject
+ (Cake *)initFromJSON:(NSDictionary *)jsonData;
@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *photo;
@end
