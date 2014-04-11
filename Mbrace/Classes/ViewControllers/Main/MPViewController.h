//
//  MPViewController.h
//  MbraceChallenge
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import "MPBaseViewController.h"

@interface MPViewController : MPBaseViewController <
    UITableViewDataSource,
    UITableViewDelegate,
    NSFetchedResultsControllerDelegate
>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)reloadMainTableView;

@end
