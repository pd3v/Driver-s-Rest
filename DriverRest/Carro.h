#import <Foundation/Foundation.h>

@class Condutor;
@class OWProgressView;

@interface Carro : NSObject {
    OWProgressView *myProgDeposito;
}

@property (nonatomic, strong) Condutor *condutor;
@property (nonatomic, strong) NSNumber *deposito;
@property (nonatomic, strong) NSNumber *velocidade;

- (void)recomecarViagem;

@end
