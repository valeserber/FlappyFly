#import "CCNode.h"

@interface LevelScene : CCScene <CCPhysicsCollisionDelegate> {

    @protected NSArray *_grounds, *_roofs;

}

-(void) initScroll: (CGFloat)scroll initGround: (CGFloat)ground initRoof: (CGFloat) roof;

- (void)didLoadFromCCB;

@end