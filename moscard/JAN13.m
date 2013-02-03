//
//  JAN13.m
//  mos
//

#import "JAN13.h"

@implementation JAN13
{
    int pos;
    CGFloat pitch;
    CGFloat height;
    CGContextRef ctx;
    CGFloat fontSize;
}

-(NSInteger)digitCode:(NSString*)str
{
	if(str.length < 12) return -1;
	int c = 0;
	
	for(int i = 11 ; i > 0 ; i -= 2) c += [str characterAtIndex:i] - 0x30;
	c *= 3;
	for(int i = 0 ; i < 12 ; i += 2) c += [str characterAtIndex:i] - 0x30;
	c = 10 - (c % 10);
	return c;
}

-(void)drawBits:(int)bits length:(int)length value:(int)value
{
    if(value >= 0)
    {
        NSString *s = @(value).stringValue;
        [s drawAtPoint:CGPointMake((pos+1.5)*pitch, height-fontSize) withFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    for(int i = 0 ; i < length ; i++, pos++)
    {
        if(!((1 << (length-1-i)) & bits)) continue;
        CGRect rc = CGRectMake(pos*pitch, 0, pitch, height-(value < 0 ? fontSize*.2 : fontSize));
        CGContextAddRect(ctx, rc);
    }
}

-(UIImage*)makeBarcode:(NSString*)str size:(CGSize)sz pitch:(CGFloat)ipitch
{
    pitch = ipitch; //2.5;  //  = about (size / 110) and good value (320->2.5) or set to 0.33mm (times 0.8 to 2.0) per line
    pos = 0;
    height = sz.height - 20;
    fontSize = pitch * 8;
    
	if(str.length == 12)
		str = [str stringByAppendingFormat:@"%c",[self digitCode:str]+0x30];
	
	if(str.length != 13) return nil;
	
    // 10+3+6*7+5+6*7+3+10 = 115 .. 5
	
    unsigned char leftOdds[10] = {
        0b0001101,0b0011001,0b0010011,0b0111101,0b0100011,
        0b0110001,0b0101111,0b0111011,0b0110111,0b0001011,
    };
    
    unsigned char leftEvens[10] = {
        0b0100111,0b0110011,0b0011011,0b0100001,0b0011101,
        0b0111001,0b0000101,0b0010001,0b0001001,0b0010111,
    };
    
    unsigned char rightEvens[10] = {
        0b1110010,0b1100110,0b1101100,0b1000010,0b1011100,
        0b1001110,0b1010000,0b1000100,0b1001000,0b1110100,
    };
    
    unsigned oejudge[10] = {
        0b111111,0b110100,0b110010,0b110001,0b101100,
        0b100110,0b100011,0b101010,0b101001,0b100101,
    }; // use odd = 1
    
    UIGraphicsBeginImageContextWithOptions(sz, YES, [UIScreen mainScreen].scale);
    ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, sz.width, sz.height));
    
    CGContextTranslateCTM(ctx, (int)((sz.width-pitch*105)/2), 10);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    
    int headdigit = [str characterAtIndex:0] - 0x30;
	
    [self drawBits:0b000 length:7 value:headdigit];
    
    [self drawBits:0b101 length:3 value:-1];
    
    int oeval = oejudge[headdigit];
    
    for(int i = 1 ; i < 7 ; i++)
    {
        int v = [str characterAtIndex:i] - 0x30;
        int bits = ((1 << (6-i)) & oeval) ? leftOdds[v] : leftEvens[v];
        [self drawBits:bits length:7 value:v];
    }
    
    [self drawBits:0b01010 length:5 value:-1];
    
    for(int i = 7 ; i < 13 ; i++)
    {
        int v = [str characterAtIndex:i] - 0x30;
        int bits = rightEvens[v];
        [self drawBits:bits length:7 value:v];
    }
    
    [self drawBits:0b101 length:3 value:-1];
    
    CGContextFillPath(ctx);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	ctx = nil;
	
    return img;
}

+(UIImage*)makeBarcode:(NSString*)str size:(CGSize)sz pitch:(CGFloat)pitch
{
    JAN13 *a = [[JAN13 alloc] init];
    return [a makeBarcode:str size:sz pitch:pitch];
}





@end


