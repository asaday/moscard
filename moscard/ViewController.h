//
//  ViewController.h
//  mos
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;
- (IBAction)doubleTap:(id)sender;
@end
