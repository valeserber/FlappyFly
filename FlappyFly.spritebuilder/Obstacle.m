//
//  Obstacle.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 22/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Obstacle.h"
typedef enum obstacles {
    BLACKY,
    SPIKY,
    ROOFSTICK,
    CARNIVOROUS,
    STATUE
}obstacles;

@implementation Obstacle {

}

-(id) initWithObstacleName: (NSString *)obstacleName {
    self = (Obstacle *) [CCBReader load:obstacleName];
    return self;
}

+ (Obstacle *) getRandomObstacle {
    NSString *obstacleName;
    long r = arc4random_uniform(1);
    switch (r) {
        case BLACKY:
            return (Obstacle*)[CCBReader load:@"Blacky"];//[[Blacky alloc] initWithObstacleName:@"Blacky"];
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
    NSLog(@"update obstacle");
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
    NSLog(@"update blacky");
    [self.physicsBody applyImpulse:ccp(0, 100.f)];
    [self.physicsBody applyAngularImpulse:300.f];
}

@end
