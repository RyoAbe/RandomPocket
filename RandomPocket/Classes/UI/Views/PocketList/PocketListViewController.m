//
//  PocketListViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/25.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketListViewController.h"
#import "RandomPocketUI.h"

@interface PocketListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString* const PokcetListCellIdentifier = @"PokcetListCell";

@implementation PocketListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PokcetListCellIdentifier];
    
//    [[PocketAPI sharedAPI] callAPIMethod:@"get"
//                          withHTTPMethod:PocketAPIHTTPMethodPOST
//                               arguments:nil
//                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
//                                     NSLog(@"response : %@", [response description]);
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PokcetListCellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


@end
