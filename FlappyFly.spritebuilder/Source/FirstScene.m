#import "FirstScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

static const CGFloat scrollSpeed = 80.f;

@implementation FirstScene {
    CCNode *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1, *_ground2, *_ground3, *_ground4;
    CCNode *_roof1, *_roof2, *_roof3, *_roof4;
    CCButton *_restartButton;
    CCNode *_health1, *_health2, *_health3, *_health4, *_health5;
    NSArray *_grounds, *_roofs;
    BOOL _impulse,_normalGravity;
    NSMutableArray *_obstacles, *_healthSprites;
    NSTimeInterval _sinceTouch, _sinceLastObstacle, _checkOffScreenTime;
    int _healthCount, i, _timeLeft;
    CGFloat _heroImpulse,_heroAngularImpulse;
    CCLabelTTF *_countTime;
    
    
}

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    NSInteger r= min + arc4random_uniform((unsigned int)max);
    return r;
}

+ (FirstScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"FirstScene"]];
    return (FirstScene*)scene;
}

-(id) init {
    if( (self=[super init] )) {
        _timeLeft = 30;
        [_countTime setString:[NSString stringWithFormat:@"%i", _timeLeft]];
        
        [self schedule:@selector(countDown:) interval:1.0f];
    }
    return self;
}

-(void)countDown:(CCTime)delta {
    _timeLeft--;
    [_countTime setString:[NSString stringWithFormat:@"%i", _timeLeft]];
    if (_timeLeft <= 0) {
        [self unschedule:@selector(countDown:)];
        [self loseGame];
    }
}


- (void)update:(CCTime)delta {
    if(_impulse==true){
        [_hero.physicsBody applyImpulse:ccp(0, _heroImpulse)];
        [_hero.physicsBody applyAngularImpulse:_heroAngularImpulse];
        _sinceTouch = 0.f;
    }
    _hero.position = ccp(_hero.position.x + delta * scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    
    
    //BORRAR
    //_physicsNode.debugDraw = YES;
    
    
    for (CCNode *ground in _grounds) {
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 3.5 * ground.contentSize.width, ground.position.y);
        }
    }
    for (CCNode *roof in _roofs) {
        CGPoint roofWorldPosition = [_physicsNode convertToWorldSpace:roof.position];
        CGPoint roofScreenPosition = [self convertToNodeSpace:roofWorldPosition];
        if (roofScreenPosition.x <= (-1 * roof.contentSize.width)) {
            roof.position = ccp(roof.position.x + 2.5 * roof.contentSize.width, roof.position.y);
        }
    }
    
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);
    _sinceTouch += delta;
    _sinceLastObstacle += delta;
    _checkOffScreenTime += delta;
    _hero.rotation = clampf(_hero.rotation, -10.f, 50.f);
    if (_hero.physicsBody.allowsRotation) {
        float angularVelocity = clampf(_hero.physicsBody.angularVelocity, -2.f, 1.f);
        _hero.physicsBody.angularVelocity = angularVelocity;
    }
    if ((_sinceTouch > 0.5f)) {
        [_hero.physicsBody applyAngularImpulse:-200.f*delta];
    }
    if (_sinceLastObstacle >= 2.f) {
        _sinceLastObstacle = 0.f;
        [self spawnNewObstacle: 210 *i++];
    }
    if (_checkOffScreenTime >= 1.0f) {
        _checkOffScreenTime = 0.f;
        [self checkOffScreen];
    }
}

- (void)spawnNewObstacle: (int) x {
    Obstacle* _obstacle = [Obstacle getRandomObstacle];
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    NSInteger r = [FirstScene randomNumberBetween: 0 maxNumber: 140];
    CGPoint point = ccp(winSize.width + x + r, [_obstacle getVerticalPosition]);
    _obstacle.position = point;
    [_obstacles addObject:_obstacle];
    [_physicsNode addChild:_obstacle];
    
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2, _ground3, _ground4];
    _roofs = @[_roof1, _roof2, _roof3, _roof4];
    self.userInteractionEnabled = YES;
    _restartButton.visible = NO;
    _physicsNode.collisionDelegate = self;
    _obstacles = [NSMutableArray array];
    _sinceLastObstacle = 0.f;
    _checkOffScreenTime = 0.f;
    _heroImpulse = 100.0f;
    _normalGravity = YES;
    _heroAngularImpulse = 300.0f;
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

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero obstacleCollision:(CCNode *)obstacle {
    return [self heroCrush];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair groundCollision:(CCNode *)ground projectileCollision:(CCNode *)projectile {
    [projectile removeFromParent];
    return TRUE;
}

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair heroCollision:(CCNode *)hero projectileCollision:(CCNode *)projectile{
    [projectile removeFromParent];
    return [self heroCrush];
}

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gravityBallCollision:(CCNode *)gravityBall heroCollision:(CCNode *)hero {
    [gravityBall removeFromParent];
    [self changeGravity];
    return YES;
}

-(void) loseLife: (int)num {
    ((CCSprite*)[_healthSprites objectAtIndex:num]).visible = NO;
}

-(void) loseGame {
    _restartButton.visible = YES;
}

-(void) checkOffScreen {
    CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:_hero.position];
    CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
    if (obstacleScreenPosition.x < -_hero.contentSize.width) {
        [self loseGame];
    }
}

-(BOOL)heroCrush {
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"heroCrush"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = _hero.position;
    [_physicsNode addChild:explosion];
    
    if (_healthCount != 1) {
        _healthCount--;
        [self loseLife:_healthCount];
        return YES;
    }
    [self loseLife:0];
    [self loseGame];
    return NO;
}

-(void)changeGravity {
    if(_normalGravity){
        _physicsNode.gravity = ccp(0,400);
        _heroImpulse = -60.0f;
        _heroAngularImpulse = -300.0f;
        _normalGravity = NO;
        return;
    }
    _physicsNode.gravity = ccp(0,-400);
    _heroImpulse = 100.0f;
    _heroAngularImpulse = 300.0f;
    _normalGravity = YES;
    return;
}


@end
