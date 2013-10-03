#import "Carro.h"
#import "Condutor.h"
#import "OWProgressView.h"

#define CONSUMO_POR_KM 0.06
#define CAPACIDADE_DEPOSITO_LITROS 60
#define VELOCIDADE_KM_H 100 
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 120
#define TIME_HOLDER_SEC 0.005

@implementation Carro

NSMutableArray *graficoVelocidade;

@synthesize condutor, deposito, velocidade;
@synthesize consumoPorKm, capacidadeDepositoLitros, velocidadeKmH, depositoCheioHue, tempoDescancoMin;
@synthesize viewDeposito;

/*- (id)init {
    if (self = [super init]) {
        
        condutor = [[Condutor alloc]init];

        deposito = [NSNumber numberWithFloat:1.0];
        condutor.tempoConducao = [NSNumber numberWithInt:0];
        
        progViewDeposito = [[OWProgressView alloc]initWithFrame:CGRectMake(20, 321, 280, 40)];
        [self addSubview:progViewDeposito];
    }
    
    return self;
}*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        condutor = [[Condutor alloc]init];
        
        consumoPorKm = CONSUMO_POR_KM;
        capacidadeDepositoLitros = CAPACIDADE_DEPOSITO_LITROS;
        velocidadeKmH = VELOCIDADE_KM_H;
        depositoCheioHue = DEPOSITO_CHEIO_HUE;
        tempoDescancoMin = TEMPO_DESCANCO;

        condutor.tempoConducao = [NSNumber numberWithInt:0];
        deposito = [NSNumber numberWithFloat:1.0];

        viewDeposito = [[OWProgressView alloc]initWithFrame:CGRectMake(20, 321, 280, 40)];
        viewDeposito.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1];
        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)viewDeposito];
                
        // KVO - Definir o viewController como observador para alterações na propriedade tempoConducao
        [self addObserver:self forKeyPath:@"deposito" options:NSKeyValueObservingOptionNew context:NULL];

    }
    return self;
}

- (void)recomecarViagem
{
    deposito = [NSNumber numberWithFloat:1.0];
    condutor.tempoConducao = [NSNumber numberWithInt:0];
    
    [viewDeposito resetToProgress:[NSNumber numberWithFloat:1.0] andHue:[NSNumber numberWithFloat:depositoCheioHue]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // A propriedade deposito do objeto carro mudou
    if ([keyPath isEqualToString:@"deposito"])
    {
        // Obter a tonalidade da cor atual da ProgressView Deposito
        CGFloat hue;
        UIColor *cor = viewDeposito.progressTintColor;
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
        
        hue -= DEPOSITO_CHEIO_HUE/((CAPACIDADE_DEPOSITO_LITROS*60)/(VELOCIDADE_KM_H*CONSUMO_POR_KM)); // À medida que o depósito fica mais vazio a cor vai-se aproximando do vermelho
        
        /*viewDeposito.progressView.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
        NSLog(@"progress:%.2f", [[change objectForKey:NSKeyValueChangeNewKey] floatValue] * viewDeposito.progressView.frame.size.width);
        //CGRect lblProgressValueFrame = CGRectMake(lblProgressValue.frame.origin.x * ([[change objectForKey:NSKeyValueChangeNewKey] floatValue]/50), lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width, lblProgressValue.frame.size.height);
        
        CGRect lblProgressValueFrame = viewDeposito.progressValue.frame;
        if (lblProgressValue.frame.origin.x >= [[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progressView.frame.size.width)
            lblProgressValueFrame = CGRectMake([[change objectForKey:NSKeyValueChangeNewKey] floatValue] * progressView.frame.size.width, lblProgressValue.frame.origin.y, lblProgressValue.frame.size.width, lblProgressValue.frame.size.height);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
            lblProgressValue.frame = lblProgressValueFrame;
            lblProgressValue.text = [NSString stringWithFormat:@"%.f l", progressView.progress*DEPOSITO_CHEIO_LITROS];
            //[myProgDeposito.progress setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
            //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
        });*/
        
        /*CGFloat nivelDeposito = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
         if (nivelDeposito == 0.0)
         {
         dispatch_async(dispatch_get_main_queue(), ^{
         bbttiRecomecar.enabled = YES;
         });
         }*/
        
        //NSLog(@"hue:%f", hue);
        
        viewDeposito.progressValue = deposito;
        viewDeposito.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
    }
}



@end

