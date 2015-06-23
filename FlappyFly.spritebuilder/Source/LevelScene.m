#import "LevelScene.h"
#import "PauseScene.h"
#import "Obstacle.h"
#import "cocos2d.h"

@implementation LevelScene {
    CCNode *_hero;
    CCPhysicsNode *_physicsNode;
    CCButton *_restartButton, *_continueButton, *_pauseButton;
    CCNode *_health1, *_health2, *_health3, *_health4, *_health5;
    BOOL _impulse,_normalGravity, _gameFinished;
    NSMutableArray *_obstacles, *_healthSprites;
    NSTimeInterval _sinceTouch, _sinceLastObstacle, _checkOffScreenTime;
    int _healthCount, i, _timeLeft;
    CGFloat _heroImpulse,_heroAngularImpulse, _scrollSpeed, _restoreImpulse, _inverseImpulse;
    CCLabelTTF *_countTime, *_gameLost, *_gameWon;
    CGFloat _groundVar, _roofVar, _obstDistVar;
}

+ (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    NSInteger r= min + arc4random_uniform((unsigned int)max);
    return r;
}

-(id) init {
    if( (self=[super init] )) {
        _gameFinished = false;
        _timeLeft = 30;
        _healthCount = 5;
        [_countTime setString:[NSString stringWithFormat:@"%i", _timeLeft]];
        [self schedule:@selector(countDown:) interval:1.0f];
    }
    return self;
}

-(void) initScroll: (CGFloat)scroll
        initGround: (CGFloat)ground
        initRoof: (CGFloat) roof
        initObsDist: (CGFloat) dist
        initImpulse: (CGFloat) imp
        initInverseImpulse:(CGFloat)invImp {
    _scrollSpeed = scroll;
    _groundVar = ground;
    _roofVar = roof;
    _obstDistVar = dist;
    _heroImpulse = imp;
    _inverseImpulse = invImp;
}

- (NSString *) getRandomObstacle {
    return nil;
}

-(void)countDown: (CCTime)delta {
    _timeLeft--;
    [_countTime setString:[NSString stringWithFormat:@"%i", _timeLeft]];
    if (_timeLeft <= 0) {
        [self unschedule:@selector(countDown:)];
        if (_healthCount > 1) {
            [self winGame];
        } else {
            [self loseGame];
        }
    }
}


- (void)update:(CCTime)delta {
    if (_gameFinished == true) {
        return;
    }
    
    if(_impulse==true){
        [_hero.physicsBody applyImpulse:ccp(0, _heroImpulse)];
        [_hero.physicsBody applyAngularImpulse:_heroAngularImpulse];
        _sinceTouch = 0.f;
    }
    _hero.position = ccp(_hero.position.x + delta * _scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    
    
    //BORRAR
//    _physicsNode.debugDraw = YES;
    
    
    for (CCNode *ground in _grounds) {
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + _groundVar * ground.contentSize.width, ground.position.y);
        }
    }
    for (CCNode *roof in _roofs) {
        CGPoint roofWorldPosition = [_physicsNode convertToWorldSpace:roof.position];
        CGPoint roofScreenPosition = [self convertToNodeSpace:roofWorldPosition];
        if (roofScreenPosition.x <= (-1 * roof.contentSize.width)) {
            roof.position = ccp(roof.position.x + _roofVar * roof.contentSize.width, roof.position.y);
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
        [self spawnNewObstacle: _obstDistVar *i++];
    }
    if (_checkOffScreenTime >= 1.0f) {
        _checkOffScreenTime = 0.f;
        [self checkOffScreen];
    }
}

- (void)spawnNewObstacle: (int) x {
    NSString * obstacleName = [self getRandomObstacle];
    Obstacle * _obstacle = [[Obstacle alloc] initWithObstacleName:obstacleName];
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    NSInteger r = [LevelScene randomNumberBetween: 0 maxNumber: 140];
    CGPoint point = ccp(winSize.width + x + r, [_obstacle getVerticalPosition]);
    _obstacle.position = point;
    [_obstacles addObject:_obstacle];
    [_physicsNode addChild:_obstacle];
    
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    _restartButton.visible = NO;
    _gameLost.visible = NO;
    _gameWon.visible = NO;
    _continueButton.visible = NO;
    _physicsNode.collisionDelegate = self;
    _obstacles = [NSMutableArray array];
    _sinceLastObstacle = 0.f;
    _checkOffScreenTime = 0.f;
    _normalGravity = YES;
    _heroAngularImpulse = 300.0f;
    i=1;
    _healthSprites = [NSMutableArray array];
    [_healthSprites addObject:_health1];
    [_healthSprites addObject:_health2];
    [_healthSprites addObject:_health3];
    [_healthSprites addObject:_health4];
    [_healthSprites addObject:_health5];
    [_restartButton setTarget:self selector:@selector(onRestartClicked)];
    [_continueButton setTarget:self selector:@selector(onContinueClicked)];
    _pauseButton = [CCButton buttonWithTitle:@"Pause" fontName:@"Helvetica" fontSize:15.0f];
    _pauseButton.positionType = CCPositionTypeNormalized;
    _pauseButton.position = ccp(0.65f, 0.95f);
    _pauseButton.color = [CCColor whiteColor];
    [_pauseButton setTarget:self selector:@selector(onPauseClicked)];
    [self addChild:_pauseButton];
}

- (void) onRestartClicked {
    
}

- (void) onContinueClicked {
    
}

- (void) onPauseClicked {
    [[CCDirector sharedDirector] pushScene:self];
    [[CCDirector sharedDirector] replaceScene:[PauseScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
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

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair projectileCollision:(CCNode *)projectile roofCollision:(CCNode *)roof {
    [projectile removeFromParent];
    return YES;
}

-(void) loseLife: (int)num {
    ((CCSprite*)[_healthSprites objectAtIndex:num]).visible = NO;
}

-(void) loseGame {
    _gameFinished = true;
    _restartButton.visible = YES;
    _gameLost.visible = YES;
}

-(void) winGame {
    _gameFinished = true;
    _gameWon.visible = YES;
    _continueButton.visible = YES;
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
    
    if (_gameFinished == true) return NO;
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
        _restoreImpulse = _heroImpulse;
        _heroImpulse = _inverseImpulse;
        _heroAngularImpulse = -300.0f;
        _normalGravity = NO;
        return;
    }
    _physicsNode.gravity = ccp(0,-400);
    _heroImpulse = _restoreImpulse;
    _heroAngularImpulse = 300.0f;
    _normalGravity = YES;
    return;
}


@end
