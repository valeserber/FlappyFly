#import "MainScene.h"
#import "Obstacle.h"

static const CGFloat scrollSpeed = 80.f;

@implementation MainScene {
    CCNode *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_ground3;
    CCNode *_ground4;
    CCButton *_restartButton;
    CCNode *_health1;
    CCNode *_health2;
    CCNode *_health3;
    CCNode *_health4;
    CCNode *_health5;;
    NSArray *_grounds;
    BOOL _impulse;
    NSMutableArray *_obstacles;
    NSMutableArray *_healthSprites;
    NSTimeInterval _sinceTouch;
    NSTimeInterval _sinceLastObstacle;
    int _healthCount;
    int i;
    
}

- (void)update:(CCTime)delta {
    if(_impulse==true){
        [_hero.physicsBody applyImpulse:ccp(0, 100.f)];
        [_hero.physicsBody applyAngularImpulse:300.f];
        _sinceTouch = 0.f;
    }
    
    _hero.position = ccp(_hero.position.x + delta * scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    
    for (CCNode *ground in _grounds) {
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 3.5 * ground.contentSize.width, ground.position.y);
        }
    }
    
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);
    _sinceTouch += delta;
    _sinceLastObstacle += delta;
    _hero.rotation = clampf(_hero.rotation, -10.f, 50.f);
    if (_hero.physicsBody.allowsRotation) {
        float angularVelocity = clampf(_hero.physicsBody.angularVelocity, -2.f, 1.f);
        _hero.physicsBody.angularVelocity = angularVelocity;
    }
    if ((_sinceTouch > 0.5f)) {
        [_hero.physicsBody applyAngularImpulse:-200.f*delta];
    }
    if(_sinceLastObstacle >= 2.f){
        _sinceLastObstacle = 0.f;
        [self spawnNewObstacle: 200 *i++];
    }
}

- (void)spawnNewObstacle: (int) x {
    CCNode *_obstacle = (CCNode *)[CCBReader load:@"Carnivorous3"];
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    CGPoint point = ccp(winSize.width + x, 75);
    _obstacle.position = point;
    [_obstacles addObject:_obstacle];
    [_physicsNode addChild:_obstacle];
    }

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    self.userInteractionEnabled = YES;
    _restartButton.visible = NO;
    _physicsNode.collisionDelegate = self;
    _obstacles = [NSMutableArray array];
    _sinceLastObstacle = 0.f;
    i=1;
    _healthCount = 5;
    _healthSprites = [NSMutableArray array];
    [_healthSprites addObject:_health1];
    [_healthSprites addObject:_health2];
    [_healthSprites addObject:_health3];
    [_healthSprites addObject:_health4];
    [_healthSprites addObject:_health5];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _impulse=true;
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    _impulse=false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero obstacleCollision:(CCNode *)obstacle {
    _healthCount--;
    if (_healthCount == 0) {
        return NO;
    }
    ((CCSprite*)[_healthSprites objectAtIndex:_healthCount]).visible = NO;
    return YES;
}
@end
