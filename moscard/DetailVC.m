//
//  DetailVC.m
//  mos
//

#import "DetailVC.h"
#import "misc.h"

@interface DetailVC () <UIWebViewDelegate>
@end

@implementation DetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	NSURLRequest *req = [Util makeRequest];
	if(!req)
	{
		[MsgBox error:@"please input card"];
		return;
	}
	
	[_web loadRequest:req];
}


- (IBAction)tapHP:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mos.jp"]];
}

@end
