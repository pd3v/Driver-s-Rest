
#import "OWProgressView.h"

#define CONSUMO_POR_KM 0.06
#define DEPOSITO_CHEIO_LITROS 60
#define VELOCIDADE_KM_H 100
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 120
#define TIME_HOLDER_SEC 0.005

@implementation OWProgressView

@synthesize progress, numProgress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setFrame:frame];
        
        progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        progress.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1];
        progress.progress = 1.0;
        
        CGFloat depositoCheio = DEPOSITO_CHEIO_LITROS;
        lblGasLevel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 26, progress.frame.size.height+2, 30, 15)];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
        lblGasLevel.font = font;
        lblGasLevel.text = [NSString stringWithFormat:@"%.f l", depositoCheio];
        
        [self addSubview:(UIView *) progress];
        [self addSubview:(UIView *) lblGasLevel];
        
        // KVO - Definir o viewController como observador para alterações na propriedade tempoConducao
        [self addObserver:self forKeyPath:@"numProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// Quando as propriedades observadas têm valores novos, programar as ações recorrentes disso. A classe NSObject adota o protocolo NSValueKeyCoding que permite ter este método disponível num UIViewController
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // A propriedade deposito do objeto carro mudou
    if ([keyPath isEqualToString:@"numProgress"])
    {
        // Obter a tonalidade da cor atual da ProgressBar Deposito
        CGFloat hue;
        UIColor *cor = progress.progressTintColor;
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
        
        hue -= DEPOSITO_CHEIO_HUE/((DEPOSITO_CHEIO_LITROS*60)/(VELOCIDADE_KM_H*CONSUMO_POR_KM)); // À medida que o depósito fica mais vazio a cor vai-se aproximando do vermelho*/
        
        progress.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
        NSLog(@"progress:%.2f", [[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progress.frame.size.width);
        //CGRect lblGasLevelFrame = CGRectMake(lblGasLevel.frame.origin.x * ([[change objectForKey:NSKeyValueChangeNewKey] floatValue]/50), lblGasLevel.frame.origin.y, lblGasLevel.frame.size.width, lblGasLevel.frame.size.height);

        CGRect lblGasLevelFrame = lblGasLevel.frame;
        if (lblGasLevel.frame.origin.x >= [[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progress.frame.size.width)
            lblGasLevelFrame = CGRectMake([[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progress.frame.size.width, lblGasLevel.frame.origin.y, lblGasLevel.frame.size.width, lblGasLevel.frame.size.height);


        dispatch_async(dispatch_get_main_queue(), ^{
            [progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
            lblGasLevel.frame = lblGasLevelFrame;
            lblGasLevel.text = [NSString stringWithFormat:@"%.f l", progress.progress*DEPOSITO_CHEIO_LITROS];
            //[myProgDeposito.progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
            //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
        });
        
        /*CGFloat nivelDeposito = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        if (nivelDeposito == 0.0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                bbttiRecomecar.enabled = YES;
            });
        }*/
    }
}

-(void)recomecarViagem
{
    lblGasLevel.frame = CGRectMake(self.frame.size.width - 26, progress.frame.size.height + 2, 30, 15);
    
    progress.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1.0];
}


@end
