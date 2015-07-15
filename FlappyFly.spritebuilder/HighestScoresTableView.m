//
//  HighestScoresTableView.m
//  FlappyFly
//
//  Created by Melisa Anabella Rossi on 14/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HighestScoresTableView.h"

@implementation HighestScoresTableView {
    
}

- (id)init
{
    self = [super init];
    if (self) {
        CCTableView* table = [CCTableView node];
        table.dataSource = self; // make our class the data source
        table.block = ^(CCTableView* table) {
            NSLog(@"Cell %d was pressed", (int) table.selectedRow);
        };
        [self addChild:table];
    }
    return self;
}

- (CCTableViewCell*) tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger) index {
    CCTableViewCell* cell = [CCTableViewCell node];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitUIPoints);
    cell.contentSize = CGSizeMake(1.0f, 32.0f);
    float colorFactor = (index / 5);
    // Just a sample node that changes color with each index value
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithRed:colorFactor green:(1.0f - colorFactor) blue:(0.2f + 0.5 * colorFactor) ] width:100.0f height:18.0f];
    [cell addChild:colorNode];
    return cell;
}

- (NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView {
    return 5; // just a demo
}
@end