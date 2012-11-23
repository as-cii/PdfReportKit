//
//  PRKRenderHtmlOperation.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/22/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "PRKRenderHtmlOperation.h"
#import "PRKGenerator.h"

@implementation PRKRenderHtmlOperation

- (id)initWithHtmlContent:(NSString *)html andSectionType: (PRKSectionType)sectionType
{
    self = [super init];
    if (self)
    {        
        htmlSource = html;
        htmlSectionType = sectionType;
        
        renderingWebView = [[UIWebView alloc] init];
        renderingWebView.delegate = self;
    }
    
    return self;
}

- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [renderingWebView loadHTMLString:htmlSource baseURL:[NSURL URLWithString:@"localhost"]];
}

- (BOOL)isConcurrent
{
    return NO;
}

- (BOOL)isFinished
{
    @synchronized(self)
    {
        return finished;
    }
}

- (BOOL)isExecuting
{
    @synchronized(self)
    {
        return executing;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.delegate = nil;
    [self.delegate didFinishLoadingSection:htmlSectionType withPrintFormatter:renderingWebView.viewPrintFormatter];
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
}

@end
