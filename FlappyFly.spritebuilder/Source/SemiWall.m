#import "SemiWall.h"

@implementation SemiWall {
    NSTimeInterval _semiWallAppears;
}


-(void) didLoadFromCCB {
    _semiWallAppears = 0.f;
}


- (void)update:(CCTime)delta {
    if(_semiWallAppears > 4.0f) {
        [self spawnSemiWall:-5];
        _semiWallAppears = 0;
    }
    _semiWallAppears +=delta;
}

//-(NSInteger)getVerticalPosition {
//    return 270;
//}

-(void)spawnSemiWall:(NSInteger) r {
    CCNode *_otherWall = [CCBReader load:@"SemiWall2"];
//    CCNode *_wall = [CCBReader load:@"SemiWall"];
    CGPoint point = self.position;
    _otherWall.position = ccp(point.x,0);
//    _wall.position = ccp(point.x, point.y);
//    [self.physicsNode addChild:_wall];
    [self.physicsNode addChild:_otherWall];
}

@end