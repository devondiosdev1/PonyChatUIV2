//
//  PCUMainViewController.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUMainPresenter;

@interface PCUMainViewController : UIViewController

@property (nonatomic, strong) PCUMainPresenter *eventHandler;

@end