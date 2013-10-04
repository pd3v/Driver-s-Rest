#import "Carro.h"
#import "Condutor.h"
#import "OWProgressView.h"

#define CONSUMO_POR_KM 0.06
#define CAPACIDADE_DEPOSITO_LITROS 60
#define VELOCIDADE_KM_H 100 
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 240
#define TIME_HOLDER_SEC 0.005

@implementation Carro

NSMutableArray *graficoVelocidade;

@synthesize condutor, deposito, velocidade;
@synthesize consumoPorKm, capacidadeDepositoLitros, velocidadeKmH, depositoCheioHue/*, tempoDescancoMin*/;
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

        condutor.tempoConducao = [NSNumber numberWithInt:0];
        condutor.tempoDescanco = [NSNumber numberWithInt:TEMPO_DESCANCO];
        deposito = [NSNumber numberWithFloat:1.0];

        viewDeposito = [[OWProgressView alloc]initWithFrame:CGRectMake(20, 321, 280, 40)];
        //viewDeposito.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1];
        viewDeposito.progressTintColor = [NSNumber numberWithFloat:depositoCheioHue];
        //viewDeposito.lblDescription.text = @"combústivel";
        viewDeposito.description = @"combústivel";
        viewDeposito.maxValue = [NSNumber numberWithInt:capacidadeDepositoLitros];
        
        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)viewDeposito];
        
        [self addObserver:self forKeyPath:@"deposito" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}



- (void)recomecarViagem
{
    deposito = [NSNumber numberWithFloat:1.0];
    condutor.tempoConducao = [NSNumber numberWithInt:0];
    
    //[viewDeposito reset:[NSNumber numberWithFloat:1.0] max:[NSNumber numberWithInt:CAPACIDADE_DEPOSITO_LITROS] hue:[NSNumber numberWithFloat:depositoCheioHue]];
    
    viewDeposito.progressValue = [NSNumber numberWithFloat:1.0];
    viewDeposito.maxValue = [NSNumber numberWithInt:capacidadeDepositoLitros];
    //viewDeposito.progressTintColor = [UIColor colorWithHue:depositoCheioHue saturation:0.88 brightness:0.88 alpha:1];
    viewDeposito.progressTintColor = [NSNumber numberWithFloat:depositoCheioHue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // A propriedade deposito do objeto carro mudou
    if ([keyPath isEqualToString:@"deposito"])
    {
        
        CGFloat hue;
        //UIColor *cor = viewDeposito.progressTintColor;
        UIColor *cor = [UIColor colorWithHue:[viewDeposito.progressTintColor floatValue] saturation:0.88 brightness:0.88 alpha:1];;
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
        
        hue -= depositoCheioHue/((capacidadeDepositoLitros * 60)/(velocidadeKmH * consumoPorKm)); // À medida que o depósito fica mais vazio a cor vai-se aproximando do vermelho
        
        viewDeposito.progressValue = deposito;
        //viewDeposito.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
        viewDeposito.progressTintColor = [NSNumber numberWithFloat:hue];
    }
}



@end

