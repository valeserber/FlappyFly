#import "FirstScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

typedef enum obstacles {
    SPIKY,
    BLACKY,
    ROOFSTICK,
    CARNIVOROUS,
    STATUE,
    ROOFSTICK2,
    ROOFSTICK3,
    GRAVITYBALL
}obstacles;

@implementation FirstScene {
    CCNode *_ground1, *_ground2, *_ground3, *_ground4;
    CCNode *_roof1, *_roof2, *_roof3, *_roof4;
}

+ (FirstScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"FirstScene"]];
    return (FirstScene*)scene;
}

-(id) init {
    self= [super init];
    [super initScroll: 80.f initGround: 3.5 initRoof: 2.5 initObsDist: 210 initImpulse: 100.f initInverseImpulse:-60.f];
    return self;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    _roofs = @[_roof1, _roof2, _roof3, _roof4];
    [super didLoadFromCCB];
}

- (NSString *) getRandomObstacle {
    NSString *obstacleName;
    int r = arc4random_uniform(8);
    switch (r) {
        case BLACKY:
            obstacleName = @"Blacky";
            break;
        case SPIKY:
            obstacleName = @"Spiky";
            break;
        case CARNIVOROUS:
            obstacleName = @"Carnivorous";
            break;
        case ROOFSTICK:
            obstacleName = @"RoofStick";
            break;
        case STATUE:
            obstacleName = @"Statue";
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
