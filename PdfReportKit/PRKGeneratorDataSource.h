//
//  PRKGeneratorDataSource.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PRKGenerator;

@protocol PRKGeneratorDataSource <NSObject>

@required
- (id)         reportsGenerator: (PRKGenerator *)generator dataForReport: (NSString *)reportName withTag: (NSString *)tagName;
- (NSString *) reportsGenerator: (PRKGenerator *)generator templateForReportName: (NSString *)reportName withURLString: (NSString *)fileName;


@end
