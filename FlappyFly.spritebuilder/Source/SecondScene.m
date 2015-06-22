#import "SecondScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

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

@end
