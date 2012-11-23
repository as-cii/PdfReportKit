//
//  PRKGeneratorDelegate.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRKGenerator;

@protocol PRKGeneratorDelegate <NSObject>

- (void) reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData: (NSData *)data;

@end
