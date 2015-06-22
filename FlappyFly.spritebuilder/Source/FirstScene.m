#import "FirstScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

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
    [super initScroll: 80.f initGround: 3.5 initRoof: 2.5];
    return self;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    _roofs = @[_roof1, _roof2, _roof3, _roof4];
    [super didLoadFromCCB];
}

@end
