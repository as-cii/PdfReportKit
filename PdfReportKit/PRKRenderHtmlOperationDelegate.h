//
//  PRKRenderHtmlOperationDelegate.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/22/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PRKSectionType) {
    PRKSectionTypeHeader,
    PRKSectionTypeContent,
    PRKSectionTypeFooter
};

@protocol PRKRenderHtmlOperationDelegate <NSObject>

- (void) didFinishLoadingSection: (PRKSectionType)sectionType withPrintFormatter: (UIPrintFormatter *)formatter;

@end
