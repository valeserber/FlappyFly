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

}

+ (NSString *)obstacleName
{
    static NSArray *_names;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _names = @[@"Carnivorous",
                    @"Blacky",
                    @"Spiky"];
    });
    NSInteger r = [self randomNumberBetween:0 maxNumber: [_names count]];
    return _names[r];
}

-(id) init {
    NSString *name = [[self class] obstacleName];
    self = (Obstacle *)[CCBReader load: name];
    return self;
}

-(void) didLoadFromCCB {


}

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    NSInteger r= min + arc4random_uniform((unsigned int)max);
    return r;
}


@end
