#import "SecondScene.h"
#import "MainScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

typedef enum obstacles2 {
    ROOFSTICK,
    BLACKY,
    GRAVITYBALL,
    WORM,
    SEMIWALL
}obstacles2;

@implementation SecondScene {
    CCNode *_ground1, *_ground2, *_ground3, *_ground4;
    CCNode *_roof1, *_roof2, *_roof3, *_roof4;
    int _gravityCount;
}

+ (SecondScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"SecondScene"]];
    return (SecondScene*)scene;
}

-(id) init {
    self= [super init];
    [super initScroll: 130.f initGround: 3.5 initRoof: 2.5 initObsDist: 310 initImpulse:70.f initInverseImpulse:-60.f];
    _gravityCount = 0;
    return self;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    _roofs = @[_roof1, _roof2, _roof3, _roof4];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:2 forKey:@"currentLevel"];
    [super didLoadFromCCB];
}

- (NSString *) getRandomObstacle {
    NSString *obstacleName;
    int r = arc4random_uniform(5);
    switch (r) {
        case ROOFSTICK:
            obstacleName = @"RoofStick";
            break;
        case BLACKY:
            obstacleName = @"Blacky";
            break;
        case WORM:
            obstacleName = @"Worm";
            break;
        case GRAVITYBALL:
            if (_gravityCount == 2 ) return @"SemiWall";
            obstacleName = @"gravityBall";
            _gravityCount++;
            break;
        case SEMIWALL:
            obstacleName = @"SemiWall";
        default:
            break;
    }
    return obstacleName;
}

@end
