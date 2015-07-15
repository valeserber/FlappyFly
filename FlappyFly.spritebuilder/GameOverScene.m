//
//  GameOverScene.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 14/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#import "GameOverScene.h"
#import "HighestScoresTableView.h"
#import "LevelScene.h"
#import "MainScene.h"
#import "FirstScene.h"
#import "SecondScene.h"

@implementation GameOverScene {
    CCLabelTTF* _yourScore;
    CCLabelTTF* _highestScore;
    CCButton* _quitButton;
    CCButton *_restartButton;
}
+ (GameOverScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"GameOverScene"]];
    return (GameOverScene*)scene;
}

- (void)didLoadFromCCB {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSInteger currentLevel = (NSInteger)[preferences integerForKey:@"currentLevel"];
    NSString *highestScoreLevel;
    if(currentLevel == LEVEL_ONE){
        highestScoreLevel = @"highestScoreLevelOne";
    }
    else {
        highestScoreLevel = @"highestScoreLevelTwo";
    }
    NSInteger highestScore = (NSInteger)[preferences integerForKey:highestScoreLevel];
    NSInteger currentScore = (NSInteger)[preferences integerForKey:@"currentScore"];
    [_yourScore setString:[NSString stringWithFormat:@"%i", (int)currentScore]];
    [_highestScore setString:[NSString stringWithFormat:@"%i", (int)highestScore]];
    
}

- (void)quitButtonPressed {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

-(void)restartButtonPressed {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSInteger currentLevel = (NSInteger)[preferences integerForKey:@"currentLevel"];
    if(currentLevel == LEVEL_ONE){
        [[CCDirector sharedDirector] replaceScene:[FirstScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
    }
    if(currentLevel ==LEVEL_TWO){
        [[CCDirector sharedDirector] replaceScene:[SecondScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];

    }
}
@end