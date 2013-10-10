//
//  CardMatchingGame.h
//  matchismo
//
//  Created by Marin Fischer on 10/7/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer. (Counts how many cards you are playing with using a deck of cards)
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

//An index to access the cards. This does all the work, gets score, flips cards over and checks if the cards match, flips cards back down
- (void)flipCardAtIndex:(NSUInteger)index;

//another way to access a card (returns a card so you can update the UI)
- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property(readonly, nonatomic) NSString *descriptionOfLastFlip;
@property (nonatomic) NSUInteger numberOfCardsToMatch;
@property (readonly, nonatomic) NSArray* lastMatchedCards;
@end
