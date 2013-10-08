
#import "ViewController.h"
//#import "Carro.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bbttiRecomecar.style = UIBarButtonItemStylePlain;
    bbttiRecomecar.enabled = NO;
    
    carro = [[Carro alloc] initWithFrame:self.view.bounds];
    carro.delegate = self;
    [carro addObserver:self forKeyPath:@"condutor.tempoConducao" options:NSKeyValueObservingOptionNew context:NULL];
    //[carro addObserver:self forKeyPath:@"deposito" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self.view insertSubview:carro atIndex:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"condutor.tempoConducao"])
    {
        
        lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[change objectForKey:NSKeyValueChangeNewKey]];
     
        NSUInteger novoTempo = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        
        if (novoTempo != 0 && novoTempo % [[carro valueForKeyPath:@"condutor.tempoDescanco"] intValue] == 0)
        {
            UIColor *red = [UIColor redColor];
           
            bttTempoVoa.enabled = YES;
            
            for (id eachView in [self.view subviews])
                if (![eachView isKindOfClass:[UIButton class]])
                    [eachView setBackgroundColor:red];
        }
        else
        {
            
            UIColor *white = [UIColor whiteColor];
            
            for (id eachView in [self.view subviews])
                    [eachView setBackgroundColor:white];
        }
    }

    // CarroDelegate Protocol substitutes the following code avoiding the use of GCD.
    // ViewController does not have to "know" that for enabling a button onto itself it has to dispatch to main queue.
    /*if ([keyPath isEqualToString:@"deposito"])
    {
        if ([[change objectForKey:NSKeyValueChangeNewKey] floatValue] == 0.0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                bbttiRecomecar.enabled = YES;
            });
        }
    }*/
}

- (NSString*)deTempoIntParaTempoHHmmss:(NSNumber*)tempo
{
    NSDateComponents* tempoMinutos = [[NSDateComponents alloc] init];
    
    [tempoMinutos setMinute:[tempo intValue]];
    
    NSCalendar* calendario = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate* data = [calendario dateFromComponents:tempoMinutos];
    
    NSDateComponents* relogio = [calendario components:NSHourCalendarUnit |
                                 NSMinuteCalendarUnit |
                                 NSSecondCalendarUnit
                                              fromDate:data];
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",[relogio hour], [relogio minute], [relogio second]];
}

- (IBAction)tempoPassa:(id)sender
{
    bttTempoVoa.enabled = NO;
    [carro atualizarTempoDeposito];
}

- (IBAction)recomecarViagem:(id)sender
{
    bbttiRecomecar.enabled = NO;
    bttTempoVoa.enabled = YES;
    
    [carro recomecarViagem];
    
    lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[carro valueForKeyPath:@"condutor.tempoConducao"]];
}

- (void)carroSemCombustivel
{
    bbttiRecomecar.enabled = YES;
    
}

- (void)dealloc
{
    [carro removeObserver:self forKeyPath:@"condutor.tempoConducao"];
    // [carro removeObserver:self forKeyPath:@"deposito"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

