//
//  misc.m
//  mos
//

#import "misc.h"

@implementation Util

+(NSMutableURLRequest*)makeRequest
{
	NSString *card = [UserDefault stringForKey:@"card"];
	if(!card) return nil;
	
	NSString *pin = [UserDefault stringForKey:@"pin"];
	if(!pin) return nil;
	
	NSString *base = @"https://www.vcsys.com/s/mos/m/";
	
	//.... umm..blocking
	NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:base] encoding:NSShiftJISStringEncoding error:nil];
	
	NSRange m = [s rangeOfString:@"login;jsessionid=\\w*" options:NSRegularExpressionSearch];
	NSString *url = [NSString stringWithFormat:@"%@%@",base,[s substringWithRange:m]];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	req.HTTPMethod = @"POST";

	NSDictionary *post = @{
	  @"cardId1" : [card substringWithRange:NSMakeRange(0, 4)],
	  @"cardId2" : [card substringWithRange:NSMakeRange(4, 4)],
	  @"cardId3" : [card substringWithRange:NSMakeRange(8, 4)],
	  @"cardId4" : [card substringWithRange:NSMakeRange(12, 4)],
	  @"cardPin" : pin};
	
	NSMutableArray *ar = [NSMutableArray array];
	[post enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[ar addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
	}];
	
	NSString *ps = [ar componentsJoinedByString:@"&"];
	[req setHTTPBody:[ps dataUsingEncoding:NSUTF8StringEncoding]];

	return req;
}

@end


@implementation NSString (mstring)

-(BOOL)isRegularMatch:(NSString*)pattern
{
	NSRange ra = [self rangeOfString:pattern options:NSRegularExpressionSearch];
	return ra.location != NSNotFound;
}

@end


@interface MsgBox () <UIAlertViewDelegate>
@end

@implementation MsgBox
+(void)info:(NSString*)msg
{
	UIAlertView *alt = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alt show];
}

+(void)error:(NSString *)msg
{
	UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alt show];
}

@end
