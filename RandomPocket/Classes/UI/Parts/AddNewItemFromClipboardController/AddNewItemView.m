//
//  AddNewItemView.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/04/13.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "AddNewItemView.h"

@interface AddNewItemView()
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@end

@implementation AddNewItemView

+ (instancetype)loadFromNib
{
    return [[UINib nibWithNibName:@"AddNewItemView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (IBAction)addButtonTapped:(id)sender
{
}

@end
