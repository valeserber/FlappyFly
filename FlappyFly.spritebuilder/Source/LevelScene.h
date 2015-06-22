#import "CCNode.h"

@interface LevelScene : CCScene <CCPhysicsCollisionDelegate> {

    @protected NSArray *_grounds, *_roofs;
}

- (NSString *) getRandomObstacle;

-(void) initScroll: (CGFloat)scroll
        initGround: (CGFloat)ground
        initRoof: (CGFloat) roof
        initObsDist: (CGFloat) dist
        initImpulse: (CGFloat) imp
        initInverseImpulse: (CGFloat) invImp;

- (void)didLoadFromCCB;

@end