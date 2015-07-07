//
//  PCUMessageItemInteractor.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageItemInteractor.h"
#import "PCUMessageEntity.h"
#import "PCUTextMessageEntity.h"
#import "PCUTextMessageItemInteractor.h"

@implementation PCUMessageItemInteractor

+ (PCUMessageItemInteractor *)itemInteractorWithMessageItem:(PCUMessageEntity *)messageItem {
    if ([messageItem isKindOfClass:[PCUTextMessageEntity class]]) {
        return [[PCUTextMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
    else {
        return [[PCUMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
}

- (instancetype)initWithMessageItem:(PCUMessageEntity *)messageItem
{
    self = [super init];
    if (self) {
        _ownSender = messageItem.ownSender;
        _messageOrder = messageItem.messageOrder;
        _avatarURLString = messageItem.senderAvatarURLString;
        _nicknameString = messageItem.senderNicknameString;
    }
    return self;
}

@end
