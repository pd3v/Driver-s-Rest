
#import <UIKit/UIKit.h>

@class Carro;
// @class OWProgressView;

@interface ViewController : UIViewController {
    
    Carro *carro;
    
    IBOutlet UILabel *lblTempoDeViagem;
    IBOutlet UIButton *bttTempoVoa;
    IBOutlet UIBarButtonItem *bbttiRecomecar;
    
    IBOutlet UIProgressView *progDeposito;
    
    // OWProgressView *myProgDeposito;
    
}

- (IBAction)tempoPassa:(id)sender;
- (IBAction)recomecar:(id)sender;

@end

