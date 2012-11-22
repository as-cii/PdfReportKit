//
//  PRKGenerator.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"
#import "GRMustache.h"

enum PRKPageSize
{
    PRKA4Page,
    PRKA3Page
};

@interface PRKGenerator : NSObject<PRKGeneratorDataSource>
{
    NSString            * currentReportName;
    NSUInteger            currentReportPage;
    NSMutableDictionary * renderedTags;
}


@property (nonatomic, weak)     id<PRKGeneratorDataSource> dataSource;
@property (nonatomic, weak)     id<PRKGeneratorDelegate> delegate;
@property (nonatomic, retain)   enum PRKPageSize;
@property (nonatomic, retain)   NSOperationQueue * renderingQueue;

// Instance methods
- (void) createReportWithName: (NSString *)reportName itemsPerPage: (NSUInteger)itemsPerPage error: (NSError **)error;

// Static methods
+ (PRKGenerator *) sharedGenerator;


@end
