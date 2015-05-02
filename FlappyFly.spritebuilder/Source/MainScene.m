#import "MainScene.h"

static const CGFloat scrollSpeed = 80.f;
static const CGFloat firstObstaclePosition = 280.f;
static const CGFloat distanceBetweenObstacles = 160.f;

@implementation MainScene {
    CCSprite *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_ground3;
    CCNode *_ground4;
    NSArray *_grounds;
    BOOL _impulse;
    NSMutableArray *_obstacles;
    NSTimeInterval _sinceTouch;
}

- (void)update:(CCTime)delta {
    if(_impulse==true){
        [_hero.physicsBody applyImpulse:ccp(0, 100.f)];
        [_hero.physicsBody applyAngularImpulse:300.f];
        _sinceTouch = 0.f;
    }
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
    // clamp velocity
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);
    _sinceTouch += delta;
    _hero.rotation = clampf(_hero.rotation, -10.f, 50.f);
    if (_hero.physicsBody.allowsRotation) {
        float angularVelocity = clampf(_hero.physicsBody.angularVelocity, -2.f, 1.f);
        _hero.physicsBody.angularVelocity = angularVelocity;
    }
    if ((_sinceTouch > 0.5f)) {
        [_hero.physicsBody applyAngularImpulse:-200.f*delta];
    }
}

- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        // this is the first obstacle
        previousObstacleXPosition = firstObstaclePosition;
    }
    CCNode *obstacle = [CCBReader load:@"Carnivorous"];
    obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    self.userInteractionEnabled = TRUE;
    _obstacles = [NSMutableArray array];
    [self spawnNewObstacle];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _impulse=true;
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    _impulse=false;
}

@end
