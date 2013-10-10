//
//  PlayingCard.h
//  matchismo
//
//  Created by Marin Fischer on 10/7/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

//the suit must be one of the valid strings returned by +validSuits. A suit of nil means the Card has never had its suit set. invalid suits (including nil) will be ignored by the setter
@property (strong, nonatomic) NSString *suit;

//rank must be between 0 and +maxRank. a rank of 0 means this Card has never had its rank set (or was reset). invalid ranks will be ignored by the setter
@property (nonatomic)NSUInteger rank;

//array of valid suit strings (this should be an NSSet)
+ (NSArray *)validSuits; //of NSString

//max legal rank
+(NSUInteger)maxRank;

@end
