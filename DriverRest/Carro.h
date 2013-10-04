// #import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Condutor;
@class OWProgressView;

@interface Carro : UIView {
    OWProgressView *viewDeposito;
}

@property (nonatomic, strong) Condutor *condutor;
@property (nonatomic, strong) NSNumber *deposito;
@property (nonatomic, strong) NSNumber *velocidade;

@property (nonatomic, readonly) CGFloat consumoPorKm;
@property (nonatomic, readonly) NSUInteger capacidadeDepositoLitros;
@property (nonatomic, readonly) NSUInteger velocidadeKmH;
@property (nonatomic, readonly) CGFloat depositoCheioHue;
// @property (nonatomic, readonly) NSUInteger tempoDescancoMin;

@property (nonatomic, strong) OWProgressView *viewDeposito;

- (void)recomecarViagem;

@end
