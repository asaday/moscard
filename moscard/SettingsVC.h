//
//  SettingsVC.h
//  mos
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtCard;
@property (weak, nonatomic) IBOutlet UITextField *txtPIN;
- (IBAction)tapCancel:(id)sender;
- (IBAction)tapDone:(id)sender;

@end
