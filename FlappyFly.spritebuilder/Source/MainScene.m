#import "MainScene.h"
#import "FirstScene.h"
#import "SecondScene.h"
#import "CCTransition.h"
#import "cocos2d.h"

@implementation MainScene {
    CCNode *_hero;
    CCButton *_button1, *_button2;
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    self.userInteractionEnabled = YES;
    return self;
}

+ (MainScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"MainScene"]];
    return (MainScene*)scene;
}

- (void)onFirstLevelClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:self];
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onSecondLevelClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:self];
    [[CCDirector sharedDirector] replaceScene:[SecondScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    [_button1 setTarget:self selector:@selector(onFirstLevelClicked:)];
    [_button2 setTarget:self selector:@selector(onSecondLevelClicked:)];
}

@end
