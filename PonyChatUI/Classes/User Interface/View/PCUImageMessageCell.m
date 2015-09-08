//
//  PCUImageMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUImageMessageCell.h"
#import "PCUImageMessageItemInteractor.h"
#import "PCUCore.h"
#import "PCUImageManager.h"
#import "PCUPopMenuViewController.h"

@interface PCUImageMessageCell ()<PCUPopMenuViewControllerDelegate>

@property (nonatomic, strong) ASNetworkImageNode *imageNode;

@property (nonatomic, strong) ASImageNode *maskNode;

@property (nonatomic, strong) PCUPopMenuViewController *popMenuViewController;

@end

@implementation PCUImageMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self addSubnode:self.imageNode];
        [self addSubnode:self.maskNode];
    }
    return self;
}

#pragma mark - Event

- (void)handleImageNodeTapped {
    if ([self.delegate respondsToSelector:@selector(PCUImageMessageItemTapped:)]) {
        [self.delegate PCUImageMessageItemTapped:(id)self.messageInteractor.messageItem];
    }
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGFloat topSpace = 0.0;
    if (self.showNickname) {
        topSpace = 18.0;
    }
    CGSize superSize = [super calculateSizeThatFits:constrainedSize];
    CGSize imageSize = CGSizeMake([[self imageMessageInteractor] imageWidth], [[self imageMessageInteractor] imageHeight]);
    
    return CGSizeMake(constrainedSize.width, MAX(superSize.height, imageSize.height) + kCellGaps + topSpace);
}

- (void)layout {
    CGFloat topSpace = 0.0;
    if (self.showNickname) {
        topSpace = 18.0;
    }
    [super layout];
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.imageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 14.0 - [self imageMessageInteractor].imageWidth, 0.0 + topSpace, [self imageMessageInteractor].imageWidth, [self imageMessageInteractor].imageHeight);
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.imageNode.frame = CGRectMake(kAvatarSize + 14.0, 0.0 + topSpace, [self imageMessageInteractor].imageWidth, [self imageMessageInteractor].imageHeight);
    }
    else {
        self.imageNode.hidden = YES;
    }
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.maskNode.image = [[UIImage imageNamed:@"SenderTextNodeBkgReversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 30, 15, 30) resizingMode:UIImageResizingModeStretch];
        self.maskNode.frame = self.imageNode.frame;
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.maskNode.image = [[UIImage imageNamed:@"ReceiverTextNodeBkgReversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 30, 15, 30) resizingMode:UIImageResizingModeStretch];
        self.maskNode.frame = self.imageNode.frame;
    }
    else {
        self.maskNode.hidden = YES;
    }
    [self updateLayoutWithContentFrame:self.maskNode.frame];
}

- (void)resume {
    [super resume];
    if ([[[self imageMessageInteractor] imageURLString] hasPrefix:@"/"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[self imageMessageInteractor] imageURLString]];
        _imageNode.image = image;
    }
}

#pragma mark - PCUPopMenuViewControllerDelegate

- (void)handleBackgroundImageNodeTapped:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.imageNode.alpha = 0.5;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint thePoint = [sender.view.superview convertPoint:sender.view.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
        thePoint.x += CGRectGetWidth(sender.view.frame) / 2.0;
        [self.popMenuViewController presentMenuViewControllerWithReferencePoint:thePoint];
        self.imageNode.alpha = 1.0;
    }
}

- (void)menuItemDidPressed:(PCUPopMenuViewController *)menuViewController itemIndex:(NSUInteger)itemIndex {
    if (itemIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(PCURequireDeleteMessageItem:)]) {
            [self.delegate PCURequireDeleteMessageItem:self.messageInteractor.messageItem];
        }
    }
    else if (itemIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(PCURequireForwardMessageItem:)]) {
            [self.delegate PCURequireForwardMessageItem:self.messageInteractor.messageItem];
        }
    }
}

#pragma mark - Getter

- (PCUImageMessageItemInteractor *)imageMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASNetworkImageNode *)imageNode {
    if (_imageNode == nil) {
        _imageNode = [[ASNetworkImageNode alloc] initWithCache:[PCUImageManager sharedInstance]
                                                    downloader:[PCUImageManager sharedInstance]];
        [_imageNode addTarget:self action:@selector(handleImageNodeTapped) forControlEvents:ASControlNodeEventTouchUpInside];
        _imageNode.contentMode = UIViewContentModeScaleAspectFit;
        if ([[[self imageMessageInteractor] imageURLString] hasPrefix:@"/"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[self imageMessageInteractor] imageURLString]];
            _imageNode.image = image;
        }
        else if ([[self imageMessageInteractor] thumbURLString] != nil) {
            _imageNode.URL = [NSURL URLWithString:[[self imageMessageInteractor] thumbURLString]];
        }
        else {
            _imageNode.URL = [NSURL URLWithString:[[self imageMessageInteractor] imageURLString]];
        }
        _imageNode.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundImageNodeTapped:)];
        gesture.minimumPressDuration = 0.15;
        [_imageNode.view addGestureRecognizer:gesture];
    }
    return _imageNode;
}

- (ASImageNode *)maskNode {
    if (_maskNode == nil) {
        _maskNode = [[ASImageNode alloc] init];
    }
    return _maskNode;
}

- (PCUPopMenuViewController *)popMenuViewController {
    if (_popMenuViewController == nil) {
        _popMenuViewController = [[PCUPopMenuViewController alloc] init];
        _popMenuViewController.titles = @[@"删除", @"转发"];
        _popMenuViewController.delegate = self;
    }
    return _popMenuViewController;
}

@end
