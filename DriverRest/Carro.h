
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Condutor;
@class OWProgressView;

@protocol CarroDelegate
- (void)carroSemCombustivel;
@end

@interface Carro : UIView {
    OWProgressView *viewDeposito;
}

@property (nonatomic) Condutor *condutor;
@property (nonatomic) NSNumber *deposito;
@property (nonatomic) NSNumber *velocidade;

@property (nonatomic, readonly) CGFloat consumoPorKm;
@property (nonatomic, readonly) NSUInteger capacidadeDepositoLitros;
@property (nonatomic, readonly) NSUInteger velocidadeKmH;
@property (nonatomic, readonly) CGFloat depositoCheioHue;

@property (nonatomic, strong) OWProgressView *viewDeposito;

@property (nonatomic, weak) id <CarroDelegate> delegate;

- (void)atualizarTempoDeposito;
- (void)recomecarViagem;

@end
