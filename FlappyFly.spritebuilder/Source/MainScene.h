#ifndef FlappyFly_MainScene_h
#define FlappyFly_MainScene_h

#import "cocos2d.h"

@interface MainScene : CCScene <CCPhysicsCollisionDelegate>

- (id)init;
+ (MainScene*) scene;

@end
#endif