#import "LevelScene.h"
#import "PauseScene.h"
#import "Obstacle.h"
#import "GameOverScene.h"
#import "WinScene.h"
#import "cocos2d.h"


@implementation LevelScene {
    CCNode *_hero;
    CCPhysicsNode *_physicsNode;
    CCButton *_pauseButton;
    CCNode *_health1, *_health2, *_health3, *_health4, *_health5;
    BOOL _impulse,_normalGravity, _gameFinished;
    NSMutableArray *_obstacles, *_healthSprites;
    NSTimeInterval _sinceTouch, _sinceLastObstacle, _checkOffScreenTime;
    int _healthCount, i, _timeLeft;
    CGFloat _heroImpulse,_heroAngularImpulse, _scrollSpeed, _restoreImpulse, _inverseImpulse;
    CCLabelTTF *_countTime;
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
        _timeLeft = TIME_LAPSE;
        _healthCount = 5;
        
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playBg:@"background-music.wav" loop:YES];

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
    _pauseButton = [CCButton buttonWithTitle:@"Pause" fontName:@"Helvetica" fontSize:15.0f];
    _pauseButton.positionType = CCPositionTypeNormalized;
    _pauseButton.position = ccp(0.65f, 0.95f);
    _pauseButton.color = [CCColor whiteColor];
    [_pauseButton setTarget:self selector:@selector(onPauseClicked)];
    [self addChild:_pauseButton];
}


- (void) onPauseClicked {
    [[CCDirector sharedDirector] pushScene:[PauseScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
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
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"gravity-ball-sound.wav"];
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
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"game-over.wav"];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSInteger currentLevel = (NSInteger)[preferences integerForKey:@"currentLevel"];
    NSString *highestScore;
    NSLog(@"%d",(int)currentLevel);
    int currentScore = (int)currentLevel*(TIME_LAPSE - _timeLeft);
    if(currentLevel == LEVEL_ONE){
        highestScore = @"highestScoreLevelOne";
    }
    else {
        highestScore = @"highestScoreLevelTwo";
    }
    if(currentScore > (int)[preferences integerForKey:highestScore]){
        [preferences setInteger:currentScore forKey:highestScore];
    }
    [preferences setInteger:currentScore forKey:@"currentScore"];
    [[CCDirector sharedDirector] replaceScene:[GameOverScene scene]
                                 withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void) winGame {
    _gameFinished = true;
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"win-game.wav"];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSInteger currentLevel = (NSInteger)[preferences integerForKey:@"currentLevel"];
    NSString *highestScore;
    int currentScore = (int)currentLevel*(TIME_LAPSE - _timeLeft);
    if(currentLevel == LEVEL_ONE){
        highestScore = @"highestScoreLevelOne";
    }
    else {
        highestScore = @"highestScoreLevelTwo";
    }
    if(currentScore > (int)[preferences integerForKey:highestScore]){
        [preferences setInteger:currentScore forKey:highestScore];
    }
    [preferences setInteger:currentScore forKey:@"currentScore"];
    [[CCDirector sharedDirector] replaceScene:[WinScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void) checkOffScreen {
    CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:_hero.position];
    CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
    if (obstacleScreenPosition.x < -_hero.contentSize.width) {
        [self loseGame];
    }
}

-(void) checkHighestScores:(NSMutableArray *)scores forCurrentScore:(int)currentScore {
    if([scores count]< 5){
        [scores insertObject:[NSNumber numberWithInt:currentScore] atIndex:[scores count]];
    }
    else {
        int min = 0;
        int j;
        for(j=0; i < [scores count]; j++) {
            if([scores objectAtIndex:j] < [scores objectAtIndex:min]) {
                min = j;
            }
        }
        if([[scores objectAtIndex:min] intValue] < currentScore){
            [scores insertObject:[NSNumber numberWithInt: currentScore] atIndex:min];
        }
    }
    NSLog(scores);
}

-(BOOL) heroCrush {
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"heroCrush"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = _hero.position;
    [_physicsNode addChild:explosion];
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"crush.wav"];
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
