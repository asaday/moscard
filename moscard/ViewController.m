//
//  ViewController.m
//  mos
//

#import <CoreImage/CoreImage.h>
#import "ViewController.h"
#import "SettingsVC.h"

#import "misc.h"
#import "JAN13.h"

@interface ViewController ()
@end

@implementation ViewController
{
	NSOperationQueue *que;
	UIImageView *iv;
	BOOL effected;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem *bb1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(tapReload:)];
	UIBarButtonItem *bb2 = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStyleBordered target:self action:@selector(tapSettings:)];
	self.navigationItem.leftBarButtonItems = @[bb1,bb2];
	
	que = [[NSOperationQueue alloc] init];
	[UserDefault removeObjectForKey:@"last"];
    
    if(![UserDefault stringForKey:@"card"])
        [self performSelector:@selector(tapSettings:) withObject:nil afterDelay:0.3];
}

-(void)viewWillAppear:(BOOL)animated
{
	NSTimeInterval t = [UserDefault floatForKey:@"last"];
	if([[NSDate date] timeIntervalSince1970] - t < 3600*12) return;	// 12hours
	
	_lbl1.text = @"input card in settings";
	_lbl2.text = @"";
	
	[iv removeFromSuperview];
	NSString *card = [UserDefault stringForKey:@"card"];
	if(!card) return;

	UIImage *img = [JAN13 makeBarcode:[card substringFromIndex:4] size:CGSizeMake(320, 120) pitch:2];
	if(!img) return;

	iv = [[UIImageView alloc] initWithImage:img];
	iv.center = CGPointMake(160,200);
	[self.view addSubview:iv];
	
	[self reload];
}

-(void)tapSettings:(id)sender
{
	SettingsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentViewController:nav animated:YES completion:nil];
}

-(void)tapReload:(id)sender
{
	[self reload];
}

- (IBAction)doubleTap:(id)sender
{
	if(iv.image == nil) return;
	
	if(!effected)
	{
		CIImage *ciImage = [[CIImage alloc] initWithImage:iv.image];
		CIFilter *ciFilter = [CIFilter filterWithName:@"CIPixellate"
										keysAndValues:kCIInputImageKey,ciImage, @"inputScale",@(7), nil];
		CIContext *ciContext = [CIContext contextWithOptions:nil];
		CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
		iv.image = [UIImage imageWithCGImage:cgimg scale:1 orientation:UIImageOrientationUp];
		CGImageRelease(cgimg);
		effected = YES;
		return;
	}
	
	NSString *card = [UserDefault stringForKey:@"card"];
	if(!card) return;
	iv.image = [JAN13 makeBarcode:[card substringFromIndex:4] size:CGSizeMake(320, 120) pitch:2];
	effected = NO;
}

- (void)reload
{
	NSURLRequest *req = [Util makeRequest];
	if(!req) return;
	
	_lbl1.text = @"loading...";
	_lbl2.text = @"";
	
	[_act startAnimating];
	
	[NSURLConnection sendAsynchronousRequest:req queue:que completionHandler:^(NSURLResponse *res, NSData * d, NSError *err) {
		dispatch_async(dispatch_get_main_queue(), ^(){

			[_act stopAnimating];
			
			NSString *s = [[NSString alloc] initWithData:d encoding:NSShiftJISStringEncoding];
			
			NSRange m;
			while ((m = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
				s = [s stringByReplacingCharactersInRange:m withString:@""];
			
            _lbl1.text = @"error";
            
            m = [s rangeOfString:@"残高.*円" options:NSRegularExpressionSearch];
            if(m.location != NSNotFound) _lbl1.text = [s substringWithRange:m];
			
            m = [s rangeOfString:@"有効期限：.*日" options:NSRegularExpressionSearch];
            if(m.location != NSNotFound) _lbl2.text = [s substringWithRange:m];
            
			[UserDefault setFloat:[[NSDate date] timeIntervalSince1970] forKey:@"last"];
		});
	}];
}



@end
