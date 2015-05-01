#import "MainScene.h"

static const CGFloat scrollSpeed = 80.f;

@implementation MainScene {
    CCSprite *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_ground3;
    CCNode *_ground4;
    NSArray *_grounds;
}

- (void)update:(CCTime)delta {
    _hero.position = ccp(_hero.position.x + delta * scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    // loop the ground
    for (CCNode *ground in _grounds) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 3.5 * ground.contentSize.width, ground.position.y);
        }
    }
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
}

@end
