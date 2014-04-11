//
//  MPAppDelegate.m
//  MbraceChallenge
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import "MPAppDelegate.h"
#import "MPNote.h"
#import "MPViewController.h"

@implementation MPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   //In order to load notes in background tread
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block MPAppDelegate *blockSelf = self;
    
    dispatch_async(queue, ^{
        [blockSelf loadNotes];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            UINavigationController *navigationViewController = (UINavigationController *)self.window.rootViewController;
            MPViewController *mainViewController = [navigationViewController.viewControllers objectAtIndex:0];
            [mainViewController reloadMainTableView];
        });
    });
    
    return YES;
}

- (void)loadNotes
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSError* error;
    
    if (error == nil) {
        NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
       
        //Add notes into core date
        if ([fetchedRecords count] == 0) {
            [self insertNotes];
        }
    }
}

- (void)insertNotes
{
    // It is a mess, but I was in hurry
    NSArray *notes = [NSArray arrayWithObjects:@{@"id":@1, @"text": @"First note"},
                        @{@"id":@2, @"text": @"Secon note with a link to http://www.google.de"},
                        @{@"id":@3, @"text": @"Third note"},
                       @{@"id":@4, @"text": @"Fourth note"},
                       @{@"id":@5, @"text": @"Fifth note with an email adress to jakob@mbraceapp.com"},
                       @{@"id":@6, @"text": @"6th note"},
                       @{@"id":@6, @"text": @"6th note updated"},
                       @{@"id":@7, @"text": @"7th note"},
                       @{@"id":@8, @"text": @"8th note"},
                       @{@"id":@9, @"text": @"9th note"},
                       @{@"id":@10, @"text": @"10th note"},
                       @{@"id":@11, @"text": @"11th note"},
                       @{@"id":@12, @"text": @"12th note"},
                       @{@"id":@13, @"text": @"13th note"},
                       @{@"id":@14, @"text": @"14th note"},
                       @{@"id":@15, @"text": @"get mbrace at http://www.getmbrace.com"},
                       @{@"id":@16, @"text": @"16th note"},
                       @{@"id":@17, @"text": @"17th note"},
                       @{@"id":@18, @"text": @"18th note"},
                       @{@"id":@19, @"text": @"19th note"},
                       @{@"id":@20, @"text": @"20th note"},
                       @{@"id":@21, @"text": [NSNull null]},
                       @{@"id":@22, @"text": @"22th note"},
                       @{@"id":@23, @"text": @"23th note"},
                       @{@"id":@24, @"text": @"Visit www.mbraceapp.com"},
                       @{@"id":@25, @"text": @"25th note"},
                       @{@"id":@26, @"text": @"Note that is a little bit longer than all the other notes because of consiting of some strings that are  useless and take a lot of space"},
                         @{@"id":@27, @"text": @"27th note"}, 
                        @{@"id":@28, @"text": @"28th note"},
                         
                         @{@"id":@29, @"text": @"29th note"}, 
                         
                         @{@"id":@30, @"text": @"another email to lukas@mbraceapp.com"}, 
                         
                         @{@"id":@31, @"text": @"31th note"}, 
                         
                         @{@"id":@32, @"text": @"32th note"}, 
                         
                         @{@"id":@33, @"text": @"33th note"}, 
                         
                         @{@"id":@34, @"text": @"almost at the end note"}, 
                         
                         @{@"id":@35, @"text": @"Last note note"}, 
                         
                         @{@"id":@12, @"text": @"Updated 12th note"}, nil];
    
    
    for (NSDictionary *note in notes) {
        MPNote *noteEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                                       inManagedObjectContext:self.managedObjectContext];
        noteEntity.noteId = [note valueForKey:@"id"];
        if ([note valueForKey:@"text"] != [NSNull null]) noteEntity.text = [note valueForKey:@"text"];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mbrace" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mbrace.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
