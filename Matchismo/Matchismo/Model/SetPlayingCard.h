//
//  SetPlayingCard.h
//  Matchismo
//
//  Created by Zhou Hao on 14-8-14.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "Card.h"

@interface SetPlayingCard : Card

@property (strong, nonatomic) NSAttributedString *attributedContents;

@property (nonatomic) NSUInteger rank;                  // 1-3
@property (strong, nonatomic) NSString *symbol;         // ▲ ● ■
@property (strong, nonatomic) NSString *shading;        // solid, striped, or open
@property (strong, nonatomic) UIColor *color;           // red, green, or purple

+ (NSUInteger)maxRank;
+ (NSArray *)validSymbol;
+ (NSArray *)validShading;
+ (NSArray *)validColor;

@end
