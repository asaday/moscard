//
//  SettingsVC.m
//  mos
//

#import "SettingsVC.h"
#import "misc.h"
#import "JAN13.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	_txtCard.text = [UserDefault stringForKey:@"card"];
	_txtPIN.text = [UserDefault stringForKey:@"pin"];
}


- (IBAction)tapCancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapDone:(id)sender
{
	NSString *card = _txtCard.text;
	NSString *pin = _txtPIN.text;
	
	if(![card isRegularMatch:@"\\d{16}"])
	{
		[MsgBox error:@"wrong card number"];
		return;
	}
	
	if(![pin isRegularMatch:@"\\d{6}"])
	{
		[MsgBox error:@"wrong PIN number"];
		return;
	}
	
	[UserDefault setObject:card forKey:@"card"];
	[UserDefault setObject:pin forKey:@"pin"];
	[UserDefault removeObjectForKey:@"last"];
	[UserDefault synchronize];
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

@end
