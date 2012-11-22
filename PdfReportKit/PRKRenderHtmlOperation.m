//
//  PRKRenderHtmlOperation.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/22/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "PRKRenderHtmlOperation.h"

@implementation PRKRenderHtmlOperation

- (id)initWithHtmlContent:(NSString *)html
{
    self = [super init];
    if (self)
    {
        htmlSource = html;
        
        renderingWebView = [[UIWebView alloc] init];
        renderingWebView.delegate = self;
    }
    
    return self;
}

- (void)start
{
    [renderingWebView loadHTMLString:htmlSource baseURL:[NSURL URLWithString:@"localhost"]];    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isFinished
{
    return finished;
}

- (BOOL)isExecuting
{
    return executing;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
