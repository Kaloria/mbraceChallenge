//
//  MPDetailViewController.m
//  Mbrace
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import "MPDetailViewController.h"

@implementation MPDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailView.noteTextView.text = self.note.text;
}

- (IBAction)saveButtonTapped:(id)sender
{
    __block NSString *text = self.detailView.noteTextView.text;
    
    //In order to load notes in background tread
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
    dispatch_async(queue, ^{
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *sysCounters = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:sysCounters];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"noteId = %@", self.note.noteId]];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        MPNote *tempObject = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
        if (error == nil) {
            tempObject.text = text;
            [self.managedObjectContext save:&error];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOULD_REFRESH_HOME" object:nil]; //TODO: did not have the time to finished it
        });
    });
}
@end
