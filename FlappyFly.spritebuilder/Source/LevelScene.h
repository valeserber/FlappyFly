#import "CCNode.h"

#define TIME_LAPSE 30
#define LEVEL_ONE 1
#define LEVEL_TWO 2

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