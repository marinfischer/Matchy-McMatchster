//
//  CardMatchingGame.m
//  matchismo
//
//  Created by Marin Fischer on 10/7/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CardGameViewController.h"

@interface CardMatchingGame ()

//the eradwrite allows you to set the score not just get it
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (readwrite, nonatomic) NSString *descriptionOfLastFlip;
@property (nonatomic, readwrite) int scoreChange;
@end

@implementation CardMatchingGame

//returns a collection of game cards
- (NSMutableArray *)cards
{
    if (!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}


//this draws out a count of the cards from the deck
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; //when making your own initializer you must call the super class's initializer
    if (self) {
        
        //this is a for loop that counts how many cards there are
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                //if i (the card) doesnt have a card, then it will return an empty array
                self.cards[i] = card;
                //if we run out of cards, then we will return nil (theres only 52 cards in a deck)
            } else {
                self = nil;
                break;
            }
        }
    }
    self.numberOfCardsToMatch = 2;
    return self;
}


- (Card *)cardAtIndex:(NSUInteger)index
{
    //if return index is less than the amount of cards we have, then return the card. if you ask for more cards than we have in a deck, return nil
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
//flips the card and does the matching
- (void)flipCardAtIndex:(NSUInteger)index
{
    //gets the card at that index
    Card *card = [self cardAtIndex:index];
    
    //make sure there is a card at that index and make sure isnt not unplayable. it wont do anything if there is no card or if the card isnt playable.
    if (card && !card.isUnplayable) {
        //Only do ths if the card is not face up (its face down).if the above is true, flip the card
        if (!card.isFaceUp) {
            self.descriptionOfLastFlip = [NSString stringWithFormat:@"Flipped the %@", card.contents];
            
            NSMutableArray *cardsFacedUp = [[NSMutableArray alloc] init];
            //looks at other cards
            for (Card *otherCard in self.cards) {
                //if another card is face up and its not unplayable,
                if (otherCard.faceUp && !otherCard.unplayable) {
                    [cardsFacedUp addObject:otherCard]; //add flipped cards to array to match
                    if (_numberOfCardsToMatch ==  3) {  //match 3 cards
                        if (cardsFacedUp.count == 2) {  //wait till 2 other cards are flipped
                            int matchScore = [card match:cardsFacedUp];
                            if (matchScore) {
                                card.unplayable = YES;
                                for (Card *matchedCard in cardsFacedUp) { //loop over  matched cards
                                    matchedCard.unplayable = YES;
                                    self.score +=matchScore * MATCH_BONUS;
                                    self.descriptionOfLastFlip = [NSString stringWithFormat:@"Matched the %@, %@ and %@ for %d points!", card.contents, otherCard.contents, otherCard.contents, matchScore *MATCH_BONUS];
                                }
                            } else {
                                card.faceUp = NO;
                                for (Card *mismatchedCard in cardsFacedUp) {  //no match loop over mis-matched cards
                                    mismatchedCard.faceUp = NO;
                                    self.score -= MISMATCH_PENALTY;
                                    self.descriptionOfLastFlip = [NSString stringWithFormat:@"%@, %@ and %@ dont match! %d point penalty!", card.contents, otherCard.contents, otherCard.contents, MISMATCH_PENALTY];
                                }
                            }
                        }
                    } else {
                    //see if the playable card that is face up matches the card you just turned over
                    int matchScore = [card match:cardsFacedUp];
                    //if the card matches the previous card
                    if (matchScore) {
                        //make the 2 matching cards unplayable
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        //and increase score by the match score
                        self.score += matchScore *MATCH_BONUS;
                        self.descriptionOfLastFlip = [NSString stringWithFormat:@"Matched the %@ and %@ for %d points!", card.contents, otherCard.contents, matchScore *MATCH_BONUS];
                        //if the cards dont match
                    } else {
                        //turn the other card back to facedown and subtract points
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.descriptionOfLastFlip = [NSString stringWithFormat:@"%@ and %@ dont match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                    //this breaks for loop if we found a match
                    break;
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}


@end
