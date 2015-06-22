#import "SecondScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

typedef enum obstacles2 {
    ROOFSTICK,
    ROOFSTICK2,
    ROOFSTICK3,
    GRAVITYBALL
}obstacles2;

@implementation SecondScene {
    CCNode *_ground1, *_ground2, *_ground3, *_ground4;
    CCNode *_roof1, *_roof2, *_roof3, *_roof4;
}

+ (SecondScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"SecondScene"]];
    return (SecondScene*)scene;
}

-(id) init {
    self= [super init];
    [super initScroll: 130.f initGround: 3.5 initRoof: 2.5 initObsDist: 310 initImpulse:70.f initInverseImpulse:-60.f];
    return self;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    _roofs = @[_roof1, _roof2, _roof3, _roof4];
    [super didLoadFromCCB];
}

- (NSString *) getRandomObstacle {
    NSString *obstacleName;
    int r = arc4random_uniform(4);
    switch (r) {
        case ROOFSTICK:
            obstacleName = @"RoofStick";
            break;
        case ROOFSTICK2:
            obstacleName = @"RoofStick2";
            break;
        case ROOFSTICK3:
            obstacleName = @"RoofStick3";
            break;
        case GRAVITYBALL:
            obstacleName = @"gravityBall";
            break;
        default:
            break;
    }
    return obstacleName;
}


@end
