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
    if(_throwMiniRoofStick > 5.0f) {
        CCNode *_miniRoofStick = [CCBReader load:@"RoofStickProjectile"];
        CGPoint point = self.position;
        _miniRoofStick.position = point;
        _throwMiniRoofStick = 0;
        [self.physicsNode addChild:_miniRoofStick];
    }
    _throwMiniRoofStick +=delta;
}

-(NSInteger)getVerticalPosition {
    return 270;
}
@end