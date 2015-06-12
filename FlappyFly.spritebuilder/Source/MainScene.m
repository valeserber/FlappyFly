#import "MainScene.h"
#import "Obstacle.h"
#import "FirstScene.h"

@implementation MainScene {
    CCButton *_button1;
}

//    + (MainScene *)scene
//    {
//        return [[self alloc] init];
//    }
//    

- (id)init
{
//    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    self.userInteractionEnabled = YES;
//
//    // Create a colored background (Dark Grey)
////    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
////    [self addChild:background];
////   
////    // Spinning scene button
////    CCButton *spinningButton = [CCButton buttonWithTitle:@"[LEVEL]" fontName:@"Verdana-Bold" fontSize:18.0f];
////    spinningButton.positionType = CCPositionTypeNormalized;
////    spinningButton.position = ccp(0.5f, 0.35f);
////    [spinningButton setTarget:self selector:@selector(onSpinningClicked:)];
////    [self addChild:spinningButton];
//
//    
    return self;
}
//

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
//    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
//                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]];
}


- (void)didLoadFromCCB {
    
//    // Spinning scene button
//    CCButton *spinningButton = [CCButton buttonWithTitle:@"[ Simple Sprite ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    spinningButton.positionType = CCPositionTypeNormalized;
//    spinningButton.position = ccp(0.5f, 0.35f);
        self.userInteractionEnabled = YES;
    [_button1 setTarget:self selector:@selector(onSpinningClicked:)];
//    [self addChild:spinningButton];

}


@end
