#import "Carro.h"
#import "Condutor.h"
#import "OWProgressView.h"

#define CONSUMO_POR_KM 0.06
#define CAPACIDADE_DEPOSITO_LITROS 60
#define VELOCIDADE_KM_H 100 
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO_MIN 1000
#define TIME_HOLDER_SEC 0.05 // Not a Car property. Keep it as macro/const

@implementation Carro

@synthesize condutor, deposito, velocidade;
@synthesize consumoPorKm, capacidadeDepositoLitros, velocidadeKmH, depositoCheioHue, tempoDescancoMin;
@synthesize viewDeposito;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        condutor = [[Condutor alloc]init];
        
        consumoPorKm = CONSUMO_POR_KM;
        capacidadeDepositoLitros = CAPACIDADE_DEPOSITO_LITROS;
        velocidadeKmH = VELOCIDADE_KM_H;
        depositoCheioHue = DEPOSITO_CHEIO_HUE;
        tempoDescancoMin = TEMPO_DESCANCO_MIN;
        
        condutor.tempoConducao = [NSNumber numberWithInt:0];
        condutor.tempoDescanco = [NSNumber numberWithInt:tempoDescancoMin];
        deposito = [NSNumber numberWithFloat:1.0];

        viewDeposito = [[OWProgressView alloc]initWithFrame:CGRectMake(20, 321, 280, 40)];
        viewDeposito.progressTintColor = [NSNumber numberWithFloat:depositoCheioHue];
        viewDeposito.description = @"combústivel";
        viewDeposito.maxLabelValue = [NSNumber numberWithFloat:capacidadeDepositoLitros];

        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)viewDeposito];
    }
    return self;
}

- (void)setDeposito:(NSNumber *)umDeposito
{
    deposito = umDeposito;

    if ([umDeposito floatValue] == 0)
        dispatch_sync(dispatch_get_main_queue(), ^{ [self.delegate carroSemCombustivel]; });

    dispatch_sync(dispatch_get_main_queue(), ^{
        CGFloat hue;
        UIColor *cor = [UIColor colorWithHue:[viewDeposito.progressTintColor floatValue] saturation:0.88 brightness:0.88 alpha:1];
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];

        hue -= depositoCheioHue / ( (capacidadeDepositoLitros * 60) / (velocidadeKmH * consumoPorKm) );
        viewDeposito.progressTintColor = [NSNumber numberWithFloat:hue];
    });
    
}


- (void)atualizarTempoDeposito
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSUInteger tempoViagem = [condutor.tempoConducao intValue];
        CGFloat nivelDeposito = [deposito floatValue];
        
        CGFloat consumido = 0;
        NSUInteger distancia = 0;
        
        while (nivelDeposito >= 0.0 && nivelDeposito <= 1.0) {
            
            [NSThread sleepForTimeInterval:TIME_HOLDER_SEC];
            
            consumido = tempoViagem * velocidadeKmH * consumoPorKm / 60;
            distancia = tempoViagem * velocidadeKmH / 60; // Variable not used. Just info.
            nivelDeposito = 1.0 - (consumido / capacidadeDepositoLitros);
            
            tempoViagem += 1; // trip time in minutes
            
            self.deposito = [NSNumber numberWithFloat:nivelDeposito];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                condutor.tempoConducao = [NSNumber numberWithInt:tempoViagem];
                viewDeposito.progressValue = deposito;
            });
           
            if (tempoViagem % [condutor.tempoDescanco intValue] == 0 && tempoViagem != 0)
                break;
        }
    });
}

- (void)recomecarViagem
{
    deposito = [NSNumber numberWithFloat:1.0];
    condutor.tempoConducao = [NSNumber numberWithInt:0];
    
    viewDeposito.progressValue = [NSNumber numberWithFloat:1.0];
    viewDeposito.maxLabelValue = [NSNumber numberWithFloat:capacidadeDepositoLitros];
    viewDeposito.progressTintColor = [NSNumber numberWithFloat:depositoCheioHue];
    
    [viewDeposito reset];
}

@end

