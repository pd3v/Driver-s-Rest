#import <Foundation/Foundation.h>

@class Condutor;

@interface Carro : NSObject

@property (nonatomic, strong) Condutor *condutor;
@property (nonatomic, strong) NSNumber *deposito;
@property (nonatomic, strong) NSNumber *velocidade;

- (void)recomecarViagem;

@end
