//
//  CardGameHistoryViewController.m
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameHistoryViewController.h"

@interface CardGameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation CardGameHistoryViewController

- (void) setHistoryText:(NSAttributedString *)historyText
{
    _historyText = historyText;
    if(self.view.window)[self updateUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}
- (void) updateUI
{
    self.historyTextView.attributedText = self.historyText;
}

@end
