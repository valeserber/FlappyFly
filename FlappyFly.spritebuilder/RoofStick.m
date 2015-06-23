//
//  RoofStick2.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 18/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoofStick.h"

@implementation RoofStick {
    NSTimeInterval _throwMiniRoofStick;
}

-(void) didLoadFromCCB {
    _throwMiniRoofStick = 0.f;
}


- (void)update:(CCTime)delta {
    if(_throwMiniRoofStick > 4.0f) {
        [self spawnMiniRoofStick:-5];
        [self spawnMiniRoofStick:5];
        _throwMiniRoofStick = 0;
    }
    _throwMiniRoofStick +=delta;
}

-(NSInteger)getVerticalPosition {
    return 270;
}

-(void)spawnMiniRoofStick:(NSInteger) r {
    CCNode *_miniRoofStick = [CCBReader load:@"RoofStickProjectile"];
    CGPoint point = self.position;
    _miniRoofStick.position = ccp(point.x+r,point.y);
    _miniRoofStick.physicsBody.velocity = CGPointMake(0,-500);
    [self.physicsNode addChild:_miniRoofStick];
}
@end