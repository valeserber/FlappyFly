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

typedef enum obstacles {
    BLACKY,
    SPIKY,
    ROOFSTICK,
    CARNIVOROUS,
    STATUE,
    ROOFSTICK2,
    ROOFSTICK3,
    GRAVITYBALL
}obstacles;

@implementation Obstacle {
    
}

-(id) initWithObstacleName: (NSString *)obstacleName {
    self = (Obstacle *) [CCBReader load:obstacleName];
    return self;
}

+ (Obstacle *) getRandomObstacle {
    NSString *obstacleName;
    long r = arc4random_uniform(8);
    switch (r) {
        case BLACKY:
            obstacleName = @"Blacky";
            break;
        case SPIKY:
            obstacleName = @"Spiky";
            break;
        case CARNIVOROUS:
            obstacleName = @"Carnivorous";
            break;
        case ROOFSTICK:
            obstacleName = @"RoofStick";
            break;
        case STATUE:
            obstacleName = @"Statue";
            break;
        case ROOFSTICK2:
            obstacleName = @"RoofStick2";
            break;
        case ROOFSTICK3:
            obstacleName = @"RoofStick3";
            break;
        case GRAVITYBALL:
            obstacleName = @"gravityBall";
            break;
        default:
            break;
    }
    return [[self alloc] initWithObstacleName:obstacleName];
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

