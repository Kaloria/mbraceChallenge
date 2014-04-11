//
//  MPBaseViewController.m
//  MbraceChallenge
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import "MPBaseViewController.h"
#import "MPAppDelegate.h"

@interface MPBaseViewController ()

@end

@implementation MPBaseViewController
@synthesize managedObjectContext;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        MPAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

@end
