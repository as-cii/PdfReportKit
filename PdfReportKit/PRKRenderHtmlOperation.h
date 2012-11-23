//
//  PRKRenderHtmlOperation.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/22/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRKRenderHtmlOperationDelegate.h"


@interface PRKRenderHtmlOperation : NSOperation<UIWebViewDelegate>
{
    PRKSectionType      htmlSectionType;
    NSString            * htmlSource;
    UIWebView           * renderingWebView;
    
    BOOL executing;
    BOOL finished;
}


@property (nonatomic, weak) id<PRKRenderHtmlOperationDelegate> delegate;

- (id) initWithHtmlContent: (NSString *)html andSectionType: (PRKSectionType)sectionType;

@end
