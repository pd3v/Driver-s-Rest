
#import <UIKit/UIKit.h>

@class Carro;

@interface ViewController : UIViewController {
    
    Carro *carro;
    
    IBOutlet UILabel *lblTempoDeViagem;
    IBOutlet UIButton *bttTempoVoa;
    IBOutlet UIBarButtonItem *bbttiRecomecar;
}

- (IBAction)tempoPassa:(id)sender;
- (IBAction)recomecar:(id)sender;

@end

