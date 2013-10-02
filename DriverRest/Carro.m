#import "Carro.h"
#import "Condutor.h"

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

- (void)recomecarViagem
{
    deposito = [NSNumber numberWithFloat:1.0];
    condutor.tempoConducao = [NSNumber numberWithInt:0];
}


@end

