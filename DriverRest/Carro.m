#import "Carro.h"
#import "Condutor.h"
#import "OWProgressView.h"

#define CONSUMO_POR_KM 0.06
#define CAPACIDADE_DEPOSITO_LITROS 60
#define VELOCIDADE_KM_H 100 
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 1000
#define TIME_HOLDER_SEC 0.000



@implementation Carro

@synthesize condutor, deposito, velocidade;
@synthesize consumoPorKm, capacidadeDepositoLitros, velocidadeKmH, depositoCheioHue/*, tempoDescancoMin*/;
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

        condutor.tempoConducao = [NSNumber numberWithInt:0];
        condutor.tempoDescanco = [NSNumber numberWithInt:TEMPO_DESCANCO];
        deposito = [NSNumber numberWithFloat:1.0];

        viewDeposito = [[OWProgressView alloc]initWithFrame:CGRectMake(20, 321, 280, 40)];
        viewDeposito.progressTintColor = [NSNumber numberWithFloat:depositoCheioHue];
        viewDeposito.description = @"combústivel";
        viewDeposito.maxValue = [NSNumber numberWithInt:capacidadeDepositoLitros];

        self.userInteractionEnabled = NO;
        [self addSubview:(UIView *)viewDeposito];
        
        //[self addObserver:self forKeyPath:@"deposito" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)setDeposito:(NSNumber *)umDeposito
{
    deposito = umDeposito;
    
    if ([umDeposito floatValue] == 0) {
        dispatch_sync(dispatch_get_main_queue(), ^{ [self.delegate carroSemCombustivel]; });
    }

    
    // Obter a tonalidade da cor atual da ProgressBar Deposito
    //CGFloat hue;
    //UIColor *cor = [UIColor colorWithHue:[viewDeposito.progressTintColor floatValue] saturation:0.88 brightness:0.88 alpha:1];
    
    //[cor getHue:&hue saturation:nil brightness:nil alpha:nil];
    
    
    //NSLog(@"CONST hue = %f", depositoCheioHue / ( (capacidadeDepositoLitros * 60) / (velocidadeKmH * consumoPorKm)));
    //hue -= depositoCheioHue / ( (capacidadeDepositoLitros * 60) / (velocidadeKmH * consumoPorKm) );
    
    
    //NSLog(@"hue = %f iterations:%d", hue, iterations++);
    // viewDeposito.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
    dispatch_sync(dispatch_get_main_queue(), ^{
        CGFloat hue;
        UIColor *cor = [UIColor colorWithHue:[viewDeposito.progressTintColor floatValue] saturation:0.88 brightness:0.88 alpha:1];
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];

        hue -= depositoCheioHue / ( (capacidadeDepositoLitros * 60) / (velocidadeKmH * consumoPorKm) );
        // NSLog(@"hue = %f iterations:%d", hue, iterations++);
        viewDeposito.progressTintColor = [NSNumber numberWithFloat:hue];
    });
        
    // NSLog(@"hue = %f iterations:%d", a, iterations++);
    
    /*dispatch_async(dispatch_get_main_queue(), ^{
     [progDeposito setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
     //[myProgDeposito.progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
     //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
     });*/
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
            distancia = tempoViagem * velocidadeKmH / 60; // Não utilizado. Apenas informativo.
            nivelDeposito = 1.0 - (consumido / capacidadeDepositoLitros);
            
            // NSLog(@"condutor.tempoConducao:%.d deposito:%.2f", tempoViagem, nivelDeposito);
            
            tempoViagem += 1; // minutos
            
            dispatch_async(dispatch_get_main_queue(), ^{
                condutor.tempoConducao = [NSNumber numberWithInt:tempoViagem];
            });
            
            self.deposito = [NSNumber numberWithFloat:nivelDeposito];
            viewDeposito.progressValue = deposito;

            if (tempoViagem % [condutor.tempoDescanco intValue] == 0 && tempoViagem != 0)
                break;
            
            // [self performSelectorOnMainThread:@selector(actualizarRelogio) withObject:nil waitUntilDone:YES];
            /*dispatch_async(dispatch_get_main_queue(), ^{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"AtualizarRelogio" object:condutor];
             //viewDeposito.progressValue = [NSNumber numberWithFloat:nivelDeposito];
             });*/
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"AtualizarRelogio" object:condutor];
            //NSLog(@"condutor.tempoConducao:%.d deposito:%.f", tempoViagem, [deposito floatValue]);
            //[self performSelectorOnMainThread:@selector(actualizarRelogio) withObject:nil waitUntilDone:YES];

        }
    });
}

- (void)recomecarViagem
{
    deposito = [NSNumber numberWithFloat:1.0];
    condutor.tempoConducao = [NSNumber numberWithInt:0];
    
    //[viewDeposito reset:[NSNumber numberWithFloat:1.0] max:[NSNumber numberWithInt:CAPACIDADE_DEPOSITO_LITROS] hue:[NSNumber numberWithFloat:depositoCheioHue]];
    
    viewDeposito.progressValue = [NSNumber numberWithFloat:1.0];
    viewDeposito.maxValue = [NSNumber numberWithInt:capacidadeDepositoLitros];
    viewDeposito.progressTintColor = [NSNumber numberWithFloat:depositoCheioHue];
    
    [viewDeposito reset];
}

@end

