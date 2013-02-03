//
//  misc.h
//  mos
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+(NSMutableURLRequest*)makeRequest;
@end

@interface NSString (mstring)
-(BOOL)isRegularMatch:(NSString*)pattern;
@end

@interface MsgBox : UIAlertView
+(void)info:(NSString*)msg;
+(void)error:(NSString*)msg;
@end
