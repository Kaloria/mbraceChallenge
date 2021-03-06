//
//  MPViewController.m
//  MbraceChallenge
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import "MPViewController.h"
#import "MPNoteCell.h"
#import "MPNote.h"
#import "MPDetailViewController.h"

@implementation MPViewController

#pragma mark - TableView Data Source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (MPNoteCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"notesCell";
    MPNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MPNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSeque"]) {
        MPDetailViewController *detailViewController = (MPDetailViewController *)[segue destinationViewController];
        MPNoteCell *selectedCell = (MPNoteCell *)sender; //TODO: fix that
        MPNote *note = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:selectedCell]];
        detailViewController.note = note;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteId" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)configureCell:(MPNoteCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MPNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([note.text length] > 0) {
        cell.noteTextView.text = note.text;
        cell.noteTextView.textColor = [UIColor blackColor];
    } else {
        cell.noteTextView.text = NSLocalizedString(@"EMPTY_NOTE", nil);
        cell.noteTextView.textColor = [UIColor redColor];
    }
    
    cell.noteId.text = [NSString stringWithFormat:@"%@", note.noteId];
}

#pragma mark -

- (void)reloadMainTableView
{
    //TODO: refresh 
    [self.tableView reloadData];
}

@end
