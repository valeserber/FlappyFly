#import "MainScene.h"
#import "FirstScene.h"
#import "cocos2d.h"

@implementation MainScene {
    CCNode *_hero;
    CCButton *_button1;
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    self.userInteractionEnabled = YES;
    return self;
}

- (void)onButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]];
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    [_button1 setTarget:self selector:@selector(onButtonClicked:)];
}

@end
