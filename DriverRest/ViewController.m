
#import "ViewController.h"
#import "Carro.h"

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
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(atualizarRelogio:) name:@"AtualizarRelogio" object:nil];
    
        
    // queue = [NSOperationQueue new];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // A propriedade tempoConducao do objeto condutor mudou
    if ([keyPath isEqualToString:@"condutor.tempoConducao"])
    {
        
        //NSLog(@"deTempoIntParaTempoHHmmss:%@", [self deTempoIntParaTempoHHmmss:[change objectForKey:NSKeyValueChangeNewKey]]);
        dispatch_async(dispatch_get_main_queue(), ^{
            lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[change objectForKey:NSKeyValueChangeNewKey]];
            //lblTempoDeViagem.text = [NSString stringWithFormat:@"%@", [change objectForKey:NSKeyValueChangeNewKey]];
        });

        
        NSUInteger novoTempo = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        
        if (novoTempo != 0 && novoTempo % [[carro valueForKeyPath:@"condutor.tempoDescanco"] intValue] == 0){
            UIColor *red = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id eachView in [self.view subviews])
                    if (![eachView isKindOfClass:[UIButton class]])
                        [eachView setBackgroundColor:red];
             });
        }
        else {
            UIColor *white = [UIColor whiteColor];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id eachView in [self.view subviews])
                    [eachView setBackgroundColor:white];
            });
        }
    }

    if ([keyPath isEqualToString:@"deposito"])
    {
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
    /*[queue setMaxConcurrentOperationCount:4];
    
    operation = [[NSInvocationOperation alloc] initWithTarget:carro selector:@selector(atualizarTempoDeposito) object:nil];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [operation setCompletionBlock:^{ NSLog(@"Terminou InvocationcOperation"); }];
    [queue addOperation:operation];*/
    
    [carro atualizarTempoDeposito];
}

//- (void)atualizarTempoDeposito
//{
//    NSUInteger tempoViagem = [[carro valueForKeyPath:@"condutor.tempoConducao"] intValue];
//    CGFloat nivelDeposito = [[carro valueForKey:@"deposito"] floatValue];
//    
//    CGFloat consumido = 0;
//    NSUInteger distancia = 0;
//
//    while (nivelDeposito > 0.0 && nivelDeposito <= 1.0) {
//        
//        [NSThread sleepForTimeInterval:TIME_HOLDER_MILISEC];
//            
//        // consumido = tempoViagem * VELOCIDADE_KM_H * CONSUMO_POR_KM / 60;
//        consumido = tempoViagem * carro.velocidadeKmH * carro.consumoPorKm / 60;
//        // distancia = tempoViagem * VELOCIDADE_KM_H / 60; // Não utilizado. Apenas informativo.
//        distancia = tempoViagem * carro.velocidadeKmH / 60; // Não utilizado. Apenas informativo.
//        // nivelDeposito = 1.0 - (consumido / DEPOSITO_CHEIO_LITROS);
//        nivelDeposito = 1.0 - (consumido / carro.capacidadeDepositoLitros);
//    
//        tempoViagem += 1; // minutos
//        
//        // KVC - Atribuir o valor à propriedade de um objeto "dentro" de outro objeto através do key path
//        [carro setValue:[NSNumber numberWithInt:tempoViagem] forKeyPath:@"condutor.tempoConducao"];
//        [carro setValue:[NSNumber numberWithFloat:nivelDeposito] forKey:@"deposito"];
//
//        if (tempoViagem % [[carro valueForKeyPath:@"condutor.tempoDescanco"] intValue] == 0 && tempoViagem != 0)
//            break;
//        
//        [self performSelectorOnMainThread:@selector(actualizarRelogio) withObject:nil waitUntilDone:YES];
//    }
//}

- (void)atualizarRelogio/*:(NSNotification*)notification*/
{
    //NSLog(@"Entrou *atualizarRelogio*:%@", [notification.object valueForKey:@"tempoConducao"]);
    // NSLog(@"[carro valueForKeyPath:@'condutor.tempoConducao']:%@", [carro valueForKeyPath:@"condutor.tempoConducao"]);
    //  dispatch_async(dispatch_get_main_queue(), ^{
    //       lblTempoDeViagem.text = [self deTempoIntParaTempoHHmmss:[notification.object valueForKey:@"tempoConducao"]];
    //   });
    
    //[self performSelectorOnMainThread:@selector(deTempoIntParaTempoHHmmss:) withObject:[notification.object valueForKey:@"tempoConducao"] waitUntilDone:NO];
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

