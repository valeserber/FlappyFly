//
//  WinScene.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 15/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WinScene.h"
#import "LevelScene.h"
#import "MainScene.h"
#import "SecondScene.h"

@implementation WinScene {
    CCLabelTTF* _yourScore;
    CCLabelTTF* _highestScore;
    CCButton* _quitButton;
    CCButton *_continueButton;
}
+ (WinScene *) scene {
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:[CCBReader load: @"WinScene"]];
    return (WinScene*)scene;
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
        _continueButton.visible = NO;
    }
    NSInteger highestScore = (NSInteger)[preferences integerForKey:highestScoreLevel];
    NSInteger currentScore = (NSInteger)[preferences integerForKey:@"currentScore"];
    [_yourScore setString:[NSString stringWithFormat:@"%i", (int)currentScore]];
    [_highestScore setString:[NSString stringWithFormat:@"%i", (int)highestScore]];
    
}

- (void)quitButtonPressed {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];

}

- (void)continueButtonPressed {
        [[CCDirector sharedDirector] replaceScene:[SecondScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end