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
#import "PRKRenderHtmlOperation.h"

typedef NS_ENUM(NSInteger, PRKPageOrientation) {
    PRKPortraitPage,
    PRKLandscapePage
};

@interface PRKGenerator : NSObject<PRKGeneratorDataSource, PRKRenderHtmlOperationDelegate>
{
    NSString        * currentReportName;
    NSUInteger        currentReportPage;
    NSUInteger        currentReportItemsPerPage;
    NSMutableData          * currentReportData;
    
    NSMutableDictionary * renderedTags;
    
    UIPrintFormatter    * headerFormatter;
    UIPrintFormatter    * contentFormatter;
    UIPrintFormatter    * footerFormatter;
}


@property (nonatomic, weak)     id<PRKGeneratorDataSource> dataSource;
@property (nonatomic, weak)     id<PRKGeneratorDelegate> delegate;
@property (nonatomic, retain)   enum PRKPageSize;
@property (nonatomic, retain)   NSOperationQueue * renderingQueue;

// Instance methods
- (void) createReportWithName: (NSString *)reportName templateURLString:(NSString *)templatePath itemsPerPage: (NSUInteger)itemsPerPage totalItems: (NSUInteger)totalItems pageOrientation: (PRKPageOrientation)orientation error: (NSError **)error;

// Static methods
+ (PRKGenerator *) sharedGenerator;


@end
