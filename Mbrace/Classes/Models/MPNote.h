//
//  MPNote.h
//  MbraceChallenge
//
//  Created by Dom-Mac on 11.04.2014.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MPNote : NSManagedObject

@property (nonatomic, retain) NSNumber * noteId;
@property (nonatomic, retain) NSString * text;

@end
