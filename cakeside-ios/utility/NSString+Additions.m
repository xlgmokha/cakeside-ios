//
//  NSString+Additions.m
//  Cardinal
//
//  Created by Cory Smith on 10-03-28.
//  Copyright 2010 Assn. All rights reserved.
//

#import "NSString+Additions.h"


#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

+ (NSString *) md5:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}

@end

@implementation NSString (Assn)

- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty {
	return [[self trim] isEqualToString:@""];
}

- (BOOL)endsWith:(NSString *)ending {
	
	int indexToCheck = [self length] - [ending length];
	
	if(indexToCheck >= 0)
		return [[self substringFromIndex:indexToCheck] isEqualToString:ending];
	
	return NO;
}

- (BOOL)startsWith:(NSString *)starting {
	if([starting isEmpty] || [starting length] > self.length)
		return NO;
	
	return [[self substringToIndex:[starting length]] isEqualToString:starting];
}

- (NSString *)replace:(NSString *)find with:(NSString *)replacement {
	return [self stringByReplacingOccurrencesOfString:find withString:replacement];
}


- (NSString *)replaceAll:(NSArray *)keys with:(NSArray *)values {
    
    NSMutableString *s = [NSMutableString stringWithString:self];
    
    for (int i = 0; i < keys.count; i++) {
        [s replaceOccurrencesOfString:[keys objectAtIndex:i] 
                           withString:[values objectAtIndex:i]
                              options:NSLiteralSearch 
                                range:NSMakeRange(0, [s length])];
    }
    
    return s;
}


- (BOOL)contains:(NSString *)text {
	NSRange range = [[self lowercaseString] rangeOfString:[text lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString *)urlEncode
{
	NSString *result = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return result;
}

- (NSString *)stringWithNewLinesAsBRs {

	// Strange New lines:
	//	Next Line, U+0085
	//	Form Feed, U+000C
	//	Line Separator, U+2028
	//	Paragraph Separator, U+2029

	// Scanner
	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSCharacterSet *newLineCharacters = [NSCharacterSet characterSetWithCharactersInString:
										 [NSString stringWithFormat:@"\n\r"]];
	// Scan
	do {

		// Get non new line characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineCharacters intoString:&temp];
		if (temp) [result appendString:temp];
		temp = nil;

		// Add <br /> s
		if ([scanner scanString:@"\r\n" intoString:nil]) {

			// Combine \r\n into just 1 <br />
			[result appendString:@"<br />"];

		} else if ([scanner scanCharactersFromSet:newLineCharacters intoString:&temp]) {

			// Scan other new line characters and add <br /> s
			if (temp) {
				for (NSUInteger i = 0; i < temp.length; i++) {
					[result appendString:@"<br />"];
				}
			}

		}

	} while (![scanner isAtEnd]);

	// Cleanup & return
	NSString *retString = [NSString stringWithString:result];

	// Return
	return retString;
    
}


- (NSString *)sanitizeForHTMLOutput
{
    NSString *result = self;
    if (!result) { result = @""; }
    result = [result trim];
    result = [result stringWithNewLinesAsBRs];
    return result;
}

+ (NSString *)generateUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);

    return uuidString;
}

@end
