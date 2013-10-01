
#import "ViewController.h"
#import "Carro.h"

#define CONSUMO_POR_KM 0.06
#define DEPOSITO_CHEIO_LITROS 60
#define VELOCIDADE_KM_H 100
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 120
#define TIME_HOLDER_SEC 0.005


@interface ViewController (){

    NSOperationQueue *queue;
    NSInvocationOperation *operation;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Definir o botão de Recomeçar da Toolbar com o estilo plano e desativado
    bbttiRecomecar.style = UIBarButtonItemStylePlain;
    bbttiRecomecar.enabled = NO;
    
    // Colocar a barra de combustível a verde -> depósito cheio
    progDeposito.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1];
    
    carro = [[Carro alloc] init];
    
    // KVO - Definir o viewController como observador para alterações na propriedade tempoConducao
    [carro addObserver:self forKeyPath:@"condutor.tempoConducao" options:NSKeyValueObservingOptionNew context:NULL];
    
    // KVO - Definir o viewController como observador para alterações na propriedade deposito
    [carro addObserver:self forKeyPath:@"deposito" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    queue = [NSOperationQueue new];
}

// Quando as propriedades observadas têm valores novos, programar as ações recorrentes disso. A classe NSObject adota o protocolo NSValueKeyCoding que permite ter este método disponível num UIViewController
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // A propriedade tempoConducao do objeto condutor mudou
    if ([keyPath isEqualToString:@"condutor.tempoConducao"])
    {
        NSUInteger novoTempo = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
                
        if (novoTempo != 0 && novoTempo % TEMPO_DESCANCO == 0){
            UIColor *red = [UIColor redColor];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.backgroundColor = red;
                for (id eachView in [self.view subviews])
                    [eachView setBackgroundColor:red];
             });
        }
        else {
            UIColor *white = [UIColor whiteColor];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.backgroundColor = white;
                for (id eachView in [self.view subviews])
                    [eachView setBackgroundColor:white];
            });
        }
    }

    // A propriedade deposito do objeto carro mudou
    if ([keyPath isEqualToString:@"deposito"])
    {
        // Obter a tonalidade da cor atual da ProgressBar Deposito
        CGFloat hue;
        UIColor *cor = progDeposito.progressTintColor;
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
        
        hue -= DEPOSITO_CHEIO_HUE/((DEPOSITO_CHEIO_LITROS*60)/(VELOCIDADE_KM_H*CONSUMO_POR_KM)); // À medida que o depósito fica mais vazio a cor vai-se aproximando do vermelho*/
        
        progDeposito.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [progDeposito setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
        });
        
        CGFloat nivelDeposito = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        if (nivelDeposito == 0.0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                bbttiRecomecar.enabled = YES;
            });
        }
    }
}

- (NSString*)deTempoIntParaTempoHHmmss:(NSNumber*)tempo
{
    NSDateComponents* tempoMinutos = [[NSDateComponents alloc] init];
    
    // KVC - Obter o valor da propriedade de um objeto "dentro" de outro objeto através do key path
    [tempoMinutos setMinute:[tempo intValue]];
    
    // Criação e formatação dos minutos (int) em HH:mm:ss
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
    [queue setMaxConcurrentOperationCount:4];
    
    operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(atualizarTempoDeposito) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [operation setCompletionBlock:^{ NSLog(@"Terminou InvocationcOperation"); }];
    [queue addOperation:operation];
    
}

- (void)atualizarTempoDeposito
{
    NSUInteger tempoViagem = [[carro valueForKeyPath:@"condutor.tempoConducao"] intValue];
    CGFloat nivelDeposito = [[carro valueForKey:@"deposito"] floatValue];
    

    // KVC - Atribuir o valor à propriedade de um objeto "dentro" de outro objeto através do key path
    /*[carro setValue:[NSNumber numberWithInt:[tempoViagem intValue] + MINUTOS_A_INCREMENTAR] forKeyPath:@"condutor.tempoConducao"];
     [carro setValue:[NSNumber numberWithFloat:[deposito floatValue] - COMBUSTIVEL_POR_KM] forKey:@"deposito"];
     
     lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[carro valueForKeyPath:@"condutor.tempoConducao"]]; */
    
    // NSLog(@"tempo min:%d", [tempoViagem intValue]);
    // CGFloat comb = [deposito floatValue];
    
    /*for (NSUInteger i=[tempoViagem intValue]; i<=6000; i++) {
        // KVC - Atribuir o valor à propriedade de um objeto "dentro" de outro objeto através do key path
        [carro setValue:[NSNumber numberWithInt:[tempoViagem intValue] + i/30] forKeyPath:@"condutor.tempoConducao"];
        comb -= COMBUSTIVEL_POR_KM;
        // [carro setValue:[NSNumber numberWithFloat:[deposito floatValue] - COMBUSTIVEL_POR_KM] forKey:@"deposito"];
        //[carro setValue:[NSNumber numberWithFloat:comb] forKey:@"deposito"];
        
        if ([[carro valueForKeyPath:@"condutor.tempoConducao"] intValue] % TEMPO_DESCANSO == 0 && [[carro valueForKeyPath:@"condutor.tempoConducao"] intValue] !=0){
            bttTempoVoa.enabled = YES;
            break;
        }
        
        [self performSelectorOnMainThread:@selector(relogio) withObject:nil waitUntilDone:YES];
    }*/
    
    CGFloat consumido = 0;
    NSUInteger distancia = 0;

    while (nivelDeposito > 0.0 && nivelDeposito <= 1.0) {
        
        [NSThread sleepForTimeInterval:TIME_HOLDER_SEC];
            
        consumido = tempoViagem * VELOCIDADE_KM_H * CONSUMO_POR_KM / 60;
        distancia = tempoViagem * VELOCIDADE_KM_H / 60; // Não utilizado. Apenas informativo.
        nivelDeposito = 1.0 - (consumido / DEPOSITO_CHEIO_LITROS);
    
        tempoViagem += 1; // minutos
        
        // KVC - Atribuir o valor à propriedade de um objeto "dentro" de outro objeto através do key path
        [carro setValue:[NSNumber numberWithInt:tempoViagem] forKeyPath:@"condutor.tempoConducao"];
        [carro setValue:[NSNumber numberWithFloat:nivelDeposito] forKey:@"deposito"];
        
        if (tempoViagem % TEMPO_DESCANCO == 0 && tempoViagem != 0)
            break;
        
        [self performSelectorOnMainThread:@selector(actualizarRelogio) withObject:nil waitUntilDone:YES];
    }
}

- (void)actualizarRelogio
{
    lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[carro valueForKeyPath:@"condutor.tempoConducao"]];
}
    
- (IBAction)recomecar:(id)sender
{
    progDeposito.progress = 1.0;
    bbttiRecomecar.enabled = NO;
 
    [carro recomecarViagem];
    
    progDeposito.progressTintColor = [UIColor colorWithHue:DEPOSITO_CHEIO_HUE saturation:0.88 brightness:0.88 alpha:1];
    lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[carro valueForKeyPath:@"condutor.tempoConducao"]];
}

// Quando não existem mais referências a este objecto ViewController.
- (void)dealloc
{
    // Remover os KVO's
    [carro removeObserver:self forKeyPath:@"condutor.tempoConducao"];
    [carro removeObserver:self forKeyPath:@"deposito"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

