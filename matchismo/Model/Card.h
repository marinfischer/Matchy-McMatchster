//
//  Card.h
//  matchismo
//
//  Created by Marin Fischer on 10/7/13.
//  Copyright (c) 2013 Marin Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;


@end
