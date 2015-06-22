#import "SemiWall.h"

@implementation SemiWall {
    NSTimeInterval _semiWallAppears;
    CCNode * _otherWall;
}


-(void) didLoadFromCCB {
    _semiWallAppears = 0.f;
}


- (void)update:(CCTime)delta {
    [self spawnSemiWall];
}


-(void)spawnSemiWall {
    if (_otherWall != nil) return;
    _otherWall = [CCBReader load:@"SemiWall2"];
    CGPoint point = self.position;
    _otherWall.position = ccp(point.x,0);
    [self.physicsNode addChild:_otherWall];
}

@end