#import "Carro.h"
#import "Condutor.h"

#define CONSUMO_POR_KM 0.06
#define DEPOSITO_CHEIO_LITROS 60
#define VELOCIDADE_KM_H 100
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 120

@implementation Carro

NSMutableArray *graficoVelocidade;

@synthesize condutor;
@synthesize deposito;
@synthesize velocidade;

- (id)init {
    if (self = [super init]) {
        
        condutor = [[Condutor alloc]init];
        
        deposito = [NSNumber numberWithFloat:1.0];
        condutor.tempoConducao = [NSNumber numberWithInt:0];
    }
    
    return self;
}

/*- (NSNumber *)velocidade:(NSUInteger)aoMinuto
{
    return [graficoVelocidade objectAtIndex:aoMinuto];
}*/

- (void)recomecarViagem
{
    deposito = [NSNumber numberWithFloat:1.0];
    condutor.tempoConducao = [NSNumber numberWithInt:0];
}

- (void)velocidadeEmCadaMinuto
{
    NSUInteger tempoViagem = 0.0;
    CGFloat nivelDeposito = DEPOSITO_CHEIO_LITROS;

    
    CGFloat consumido = 0;
    NSUInteger distancia = 0;
    
    /*while (nivelDeposito > 0.0 && nivelDeposito <= 1.0) {
        
        consumido = tempoViagem * VELOCIDADE_KM_H * CONSUMO_POR_KM / 60;
        distancia = tempoViagem * VELOCIDADE_KM_H / 60; // Não utilizado. Apenas informativo.
        nivelDeposito = 1.0 - (consumido / DEPOSITO_CHEIO_LITROS);
        
        tempoViagem += 1; // minutos
        
        // KVC - Atribuir o valor à propriedade de um objeto "dentro" de outro objeto através do key path
        //[carro setValue:[NSNumber numberWithInt:tempoViagem] forKeyPath:@"condutor.tempoConducao"];
        //[carro setValue:[NSNumber numberWithFloat:nivelDeposito] forKey:@"deposito"];
        //CGFloat y = amplitude * sinf(2 * M_PI * (x / width) * frequency) + halfHeight;
        //CGFloat y = x;
        NSLog(@"x=%.2f y=%.2f", x, y);

        
        graficoVelocidade addObject:<#(id)#>
        
        if (tempoViagem % TEMPO_DESCANCO == 0 && tempoViagem != 0)
            break;
        
        [self performSelectorOnMainThread:@selector(actualizarRelogio) withObject:nil waitUntilDone:YES];
    }*/
    
    
}

@end

