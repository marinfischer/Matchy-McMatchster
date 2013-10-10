//
//  PlayingCard.m
//  matchismo
//
//  Created by Marin Fischer on 10/7/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


//the 4 suits as strings
+ (NSArray *)validSuits
{
    return @[@"♥", @"♣", @"♠", @"♦"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }



- (int)match:(NSArray *)otherCards
{
    int score = 0;
    //only match if there is one other card
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];/*lastObject(gives the last object in the array) never gives you array index out of bounds. it will just give you nil.*/
        
            //if the other card has the same suit, then the score=1
            if ([otherCard.suit isEqualToString:self.suit]) {
                score = 1;
                //if the other card has the same #, then the score=4
                } else if (otherCard.rank == self.rank) {
                score = 4;
            }
    //only match is there are 2 other cards (3 card match total)
    } else if ([otherCards count] == 2) {
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        if ([firstCard.suit isEqualToString:self.suit] && [secondCard.suit isEqualToString:self.suit]) {
            score = 4;
        } else if ((firstCard.rank ==self.rank) && (secondCard.rank == self.rank)){
            score = 16;
        }
    }
    return score;
}


//contents is concatenation of rank and suit. rank is represented as a string by indexing into +rankStrings
- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

//must synthesize suit b/c we implement both setter and getter
@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}


- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
