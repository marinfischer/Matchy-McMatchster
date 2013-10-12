//
//  CardGameViewController.m
//  matchismo
//
//  Created by Marin Fischer on 10/7/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"


@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
//proprty that points to the model for the rules of teh game
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlip;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
- (IBAction)dealButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeControl;
- (IBAction)changeGameType:(id)sender;
@property (strong, nonatomic) GameResult *gameResult;

@end


@implementation CardGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

//lazy instanciation to create a new deck with the card count(how many buttons there are)
- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

//sets cards per the model
- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 :1.0);
        //Add background image to card. If the card is selected, destroy image, if card is not selected show image for back of card
        [cardButton setBackgroundImage:(cardButton.selected) ? [UIImage imageNamed:nil] : [UIImage imageNamed:@"images.png"] forState:UIControlStateNormal];
    
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastFlip.text = self.game.descriptionOfLastFlip;
}


- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
    self.gameResult.score = self.game.score;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}


- (IBAction)dealButton:(id)sender
{
    //resetting the SegmentedControl
    [[self gameTypeControl] setSelectedSegmentIndex:0];
    //get current selection of segmented control
    int currentSelectedValue =  [[self gameTypeControl] selectedSegmentIndex];
    
    self.flipCount = 0; //reset flip count
    self.game = nil; //destroying the object and allocation
    //create a new instance of game with selected segment mode
    [[self game] setNumberOfCardsToMatch:currentSelectedValue];

    [self updateUI];
}

- (IBAction)changeGameType:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0)
        self.game.numberOfCardsToMatch = 2;
    else
        self.game.numberOfCardsToMatch = 3;
}
@end
