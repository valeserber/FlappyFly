#import "SemiWall.h"

@implementation SemiWall {
    NSTimeInterval _semiWallAppears;
}


-(void) didLoadFromCCB {
    _semiWallAppears = 0.f;
}


- (void)update:(CCTime)delta {
    if(_semiWallAppears > 4.0f) {
        [self spawnSemiWall];
        _semiWallAppears = 0;
    }
    _semiWallAppears +=delta;
}

//-(NSInteger)getVerticalPosition {
//    return 270;
//}

-(void)spawnSemiWall {
    CCNode *_otherWall = [CCBReader load:@"SemiWall2"];
    CGPoint point = self.position;
    _otherWall.position = ccp(point.x,0);
    [self.physicsNode addChild:_otherWall];
}

@end