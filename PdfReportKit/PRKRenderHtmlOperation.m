/* Copyright 2012 Antonio Scandurra
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. */

#import "PRKRenderHtmlOperation.h"
#import "PRKGenerator.h"
#import "NSURLWebViewProtocol.h"

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
        
        // Register the custom NSURL WebView Protocol
        [NSURLWebViewProtocol registerClass:[NSURLWebViewProtocol class]];
    }
    
    return self;
}

- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [renderingWebView loadHTMLString:htmlSource baseURL:baseURL];
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
