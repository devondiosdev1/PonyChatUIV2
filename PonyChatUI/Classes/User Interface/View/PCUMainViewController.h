//
//  PCUMainViewController.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUMainPresenter;

@protocol PCUDelegate;

@interface PCUMainViewController : UIViewController

@property (nonatomic, weak) id<PCUDelegate> delegate;

@property (nonatomic, strong) PCUMainPresenter *eventHandler;

- (CGSize)contentSize;

- (void)reloadData;

- (void)deleteDataWithRow:(NSUInteger)row;

- (void)pushData;

- (void)pushDataTwice;

- (void)insertData;

- (void)insertDataTwice;

- (void)autoScroll;

- (void)forceScroll;

- (void)reloadSlideUpData;

- (void)deleteSlideUpDataWithRow:(NSUInteger)row;

@end
