#import "MainScene.h"
#import "FirstScene.h"
#import "SecondScene.h"
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

- (void)onFirstLevelClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]];
}

- (void)onSecondLevelClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SecondScene scene]];
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    [_button1 setTarget:self selector:@selector(onFirstLevelClicked:)];
    [_button2 setTarget:self selector:@selector(onSecondLevelClicked:)];
}

@end
