
#import <UIKit/UIKit.h>
#import "Carro.h"
//@class Carro;

@interface ViewController : UIViewController <CarroDelegate> {
    
    Carro *carro;
    
    IBOutlet UILabel *lblTempoDeViagem;
    IBOutlet UIButton *bttTempoVoa;
    IBOutlet UIBarButtonItem *bbttiRecomecar;
}

- (IBAction)tempoPassa:(id)sender;
- (IBAction)recomecar:(id)sender;

@end

