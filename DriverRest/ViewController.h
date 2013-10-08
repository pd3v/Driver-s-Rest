
#import <UIKit/UIKit.h>
#import "Carro.h"

@interface ViewController : UIViewController <CarroDelegate> {
    
    Carro *carro;
    
    IBOutlet UILabel *lblTempoDeViagem;
    IBOutlet UIButton *bttTempoVoa;
    IBOutlet UIBarButtonItem *bbttiRecomecar;
}

- (IBAction)tempoPassa:(id)sender;
- (IBAction)recomecarViagem:(id)sender;

@end

