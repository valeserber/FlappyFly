//
//  Obstacle.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 22/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Obstacle.h"
#import "RoofStick.h"



@implementation Obstacle {
    
}

-(id) initWithObstacleName: (NSString *)obstacleName {
    self = (Obstacle *) [CCBReader load:obstacleName];
    return self;
}

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    NSInteger r= min + arc4random_uniform((unsigned int)max);
    return r;
}

- (void) update:(CCTime)delta
{
    
}

-(NSInteger)getVerticalPosition {
    return 75;
}

@end

@implementation Statue {
    NSTimeInterval _movementInterval;
}

-(id) initWithObstacleName: (NSString *)obstacleName {
    self = [super initWithObstacleName:obstacleName];
    return self;
}

-(void) didLoadFromCCB {
    _movementInterval = 0.f;
}

- (void)scheduleUpdate {
}

- (void)update:(CCTime)delta {
    if ((_movementInterval > 2.0f)) {
        _movementInterval = 0.f;
        [self.physicsBody applyImpulse:ccp(0, 800.f)];
        [self.physicsBody applyAngularImpulse:900.f];
    }
    _movementInterval+=delta;
}

@end

@implementation Blacky {
    NSTimeInterval _movementInterval;
}

-(id) initWithObstacleName: (NSString *)obstacleName {
    self = [super initWithObstacleName:obstacleName];
    return self;
}

-(void) didLoadFromCCB {
    _movementInterval = 0.f;
}

- (void)scheduleUpdate {
}

- (void)update:(CCTime)delta {
    if ((_movementInterval > 2.0f)) {
        _movementInterval = 0.f;
        [self.physicsBody applyImpulse:ccp(0, 1200.f)];
    }
    _movementInterval+=delta;
}

@end

@implementation GravityBall

- (void)didLoadFromCCB {
    
}
@end

