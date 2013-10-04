
#import "ViewController.h"
#import "Carro.h"


/*#define CONSUMO_POR_KM 0.06
#define DEPOSITO_CHEIO_LITROS 60
#define VELOCIDADE_KM_H 100
#define DEPOSITO_CHEIO_HUE 0.36
#define TEMPO_DESCANCO 120*/
#define TIME_HOLDER_MILISEC 0.003


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
    // progDeposito.progressTintColor = [UIColor colorWithHue:carro.depositoCheioHue saturation:0.88 brightness:0.88 alpha:1];
    
    carro = [[Carro alloc] initWithFrame:self.view.bounds];
    carro.userInteractionEnabled = NO;
    [self.view insertSubview:carro atIndex:0];
    // carro.progViewDeposito.progressView.progress = 1.0;
    
    // KVO - Definir o viewController como observador para alterações na propriedade tempoConducao
    [carro addObserver:self forKeyPath:@"condutor.tempoConducao" options:NSKeyValueObservingOptionNew context:NULL];
    
    // KVO - Definir o viewController como observador para alterações na propriedade deposito
    [carro addObserver:self forKeyPath:@"deposito" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    queue = [NSOperationQueue new];
}

// Quando as propriedades observadas têm valores novos, programar as ações recorrentes disso. A classe NSObject adota o protocolo NSValueKeyCoding que permite ter este método disponível num UIViewController
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // A propriedade tempoConducao do objeto condutor mudou
    if ([keyPath isEqualToString:@"condutor.tempoConducao"])
    {
        NSUInteger novoTempo = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
                
        if (novoTempo != 0 && novoTempo % [[carro valueForKeyPath:@"condutor.tempoDescanco"] intValue] == 0){
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
        /*// Obter a tonalidade da cor atual da ProgressBar Deposito
        CGFloat hue;
        UIColor *cor = progDeposito.progressTintColor;
        [cor getHue:&hue saturation:nil brightness:nil alpha:nil];
        
        hue -= DEPOSITO_CHEIO_HUE/((DEPOSITO_CHEIO_LITROS*60)/(VELOCIDADE_KM_H*CONSUMO_POR_KM)); // À medida que o depósito fica mais vazio a cor vai-se aproximando do vermelho
        
        progDeposito.progressTintColor = [UIColor colorWithHue:hue saturation:0.88 brightness:0.88 alpha:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [progDeposito setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
            //[myProgDeposito.progressView setProgress:[[change objectForKey:NSKeyValueChangeNewKey] floatValue] animated:YES];
            //myProgDeposito.numProgress=[change objectForKey:NSKeyValueChangeNewKey];
        });*/
        
        if ([[change objectForKey:NSKeyValueChangeNewKey] floatValue] == 0.0)
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
    // [operation setCompletionBlock:^{ NSLog(@"Terminou InvocationcOperation"); }];
    [queue addOperation:operation];
    
}

- (void)atualizarTempoDeposito
{
    NSUInteger tempoViagem = [[carro valueForKeyPath:@"condutor.tempoConducao"] intValue];
    CGFloat nivelDeposito = [[carro valueForKey:@"deposito"] floatValue];
    
    CGFloat consumido = 0;
    NSUInteger distancia = 0;

    while (nivelDeposito > 0.0 && nivelDeposito <= 1.0) {
        
        [NSThread sleepForTimeInterval:TIME_HOLDER_MILISEC];
            
        // consumido = tempoViagem * VELOCIDADE_KM_H * CONSUMO_POR_KM / 60;
        consumido = tempoViagem * carro.velocidadeKmH * carro.consumoPorKm / 60;
        // distancia = tempoViagem * VELOCIDADE_KM_H / 60; // Não utilizado. Apenas informativo.
        distancia = tempoViagem * carro.velocidadeKmH / 60; // Não utilizado. Apenas informativo.
        // nivelDeposito = 1.0 - (consumido / DEPOSITO_CHEIO_LITROS);
        nivelDeposito = 1.0 - (consumido / carro.capacidadeDepositoLitros);
    
        tempoViagem += 1; // minutos
        
        // KVC - Atribuir o valor à propriedade de um objeto "dentro" de outro objeto através do key path
        [carro setValue:[NSNumber numberWithInt:tempoViagem] forKeyPath:@"condutor.tempoConducao"];
        [carro setValue:[NSNumber numberWithFloat:nivelDeposito] forKey:@"deposito"];

        if (tempoViagem % [[carro valueForKeyPath:@"condutor.tempoDescanco"] intValue] == 0 && tempoViagem != 0)
            break;
        
        [self performSelectorOnMainThread:@selector(actualizarRelogio) withObject:nil waitUntilDone:YES];
    }
}

- (void)actualizarRelogio
{
    // NSLog(@"[carro valueForKeyPath:@'condutor.tempoConducao']:%@", [carro valueForKeyPath:@"condutor.tempoConducao"]);
    lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[carro valueForKeyPath:@"condutor.tempoConducao"]];
}
    
- (IBAction)recomecar:(id)sender
{
    // progDeposito.progress = 1.0;
    // myProgDeposito.progressView.progress = 1.0;
    bbttiRecomecar.enabled = NO;
    
    // [myProgDeposito recomecarViagem];
    
    [carro recomecarViagem];
    //progDeposito.progressTintColor = [UIColor colorWithHue:carro.depositoCheioHue saturation:0.88 brightness:0.88 alpha:1];
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

