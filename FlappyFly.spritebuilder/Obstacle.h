//
//  Obstacle.h
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 22/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#ifndef FlappyFly_Obstacle_h
#define FlappyFly_Obstacle_h
#import "CCNode.h"

@interface Obstacle : CCNode

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max;
+ (Obstacle*)getRandomObstacle;

@end

@interface Blacky : Obstacle

@end
#endif
