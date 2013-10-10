
#import <UIKit/UIKit.h>
#import "Car.h"

@interface ViewController : UIViewController <CarDelegate> {
    Car *car;
    
    IBOutlet UILabel *lblTripTime;
    IBOutlet UIButton *bttGo;
    IBOutlet UIButton *bttStop;
    IBOutlet UIBarButtonItem *bbttiRestartTrip;
}

- (IBAction)goingOnATrip:(id)sender;
- (IBAction)stopTrip:(id)sender;
- (IBAction)restartTrip:(id)sender;

@end

