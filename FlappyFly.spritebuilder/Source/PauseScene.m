#import "PauseScene.h"
#import "MainScene.h"

@implementation PauseScene {
    CCButton *_resumeButton;
}

+ (PauseScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"PauseScene"]];
    return (PauseScene*)scene;
}

- (void)didLoadFromCCB {
    _resumeButton = [CCButton buttonWithTitle:@"Resume" fontName:@"Helvetica" fontSize:18.0f];
    _resumeButton.positionType = CCPositionTypeNormalized;
    _resumeButton.position = ccp(0.5f, 0.5f);
    _resumeButton.color = [CCColor grayColor];
    [_resumeButton setTarget:self selector:@selector(onResumeClicked)];
    [self addChild:_resumeButton];
}

- (void) onResumeClicked {
    [[CCDirector sharedDirector] popScene];
}

- (void) onExitClicked {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
}
@end