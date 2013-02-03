//
//  JAN13.h
//  mos
//

#import <Foundation/Foundation.h>

// reference http://www5d.biglobe.ne.jp/~bar/spec/barspec.html

@interface JAN13 : NSObject
+(UIImage*)makeBarcode:(NSString*)str size:(CGSize)sz pitch:(CGFloat)pitch;
@end
