//
//  PRKRenderHtmlOperation.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/22/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRKRenderHtmlOperation : NSOperation<UIWebViewDelegate>
{
    NSString    * htmlSource;
    UIWebView   * renderingWebView;
    
    BOOL executing;
    BOOL finished;
}

- (id) initWithHtmlContent: (NSString *)html;

@end
