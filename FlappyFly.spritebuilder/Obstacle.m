//
//  Obstacle.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 22/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Obstacle.h"

@implementation Obstacle {
    CCNode *_obstacle;
}

-(void) didLoadFromCCB {
    _obstacle.physicsBody.collisionType = @"obstacleCollision";
    _obstacle.physicsBody.sensor = TRUE;
}

@end
