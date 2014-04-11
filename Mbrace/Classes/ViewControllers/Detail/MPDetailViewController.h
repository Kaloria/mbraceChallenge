//
//  MPDetailViewController.h
//  Mbrace
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import "MPBaseViewController.h"
#import "MPDetailView.h"
#import "MPNote.h"

@interface MPDetailViewController : MPBaseViewController

@property (strong, nonatomic) MPNote *note;
@property (strong, nonatomic) IBOutlet MPDetailView *detailView;

- (IBAction)saveButtonTapped:(id)sender;

@end
