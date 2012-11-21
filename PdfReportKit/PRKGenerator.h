//
//  PRKGenerator.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRKGeneratorDataSource.h"

@interface PRKGenerator : NSObject
{
    NSOperationQueue * workQueue;
}


@property (nonatomic, weak) id<PRKGeneratorDataSource> dataSource;


// Instance methods
- (void) createReportWithName: (NSString *)reportName;

// Static methods
+ (PRKGenerator *) sharedGenerator;

@end
