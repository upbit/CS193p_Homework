//
//  Card.h
//  Matchismo
//
//  Created by Zhou Hao on 14-8-7.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
