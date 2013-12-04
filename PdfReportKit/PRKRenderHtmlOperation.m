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

@interface PRKRenderHtmlOperation ()

@property (nonatomic, assign) PRKSectionType htmlSectionType;
@property (nonatomic, copy)   NSString  * htmlSource;
@property (nonatomic, strong) UIWebView * renderingWebView;

@property (atomic, assign) BOOL executing;
@property (atomic, assign) BOOL finished;

@end

@implementation PRKRenderHtmlOperation

- (id)initWithHtmlContent:(NSString *)html andSectionType: (PRKSectionType)sectionType
{
    self = [super init];
    if (self)
    {        
        self.htmlSource = html;
        self.htmlSectionType = sectionType;
        
        self.renderingWebView = [[UIWebView alloc] init];
        self.renderingWebView.delegate = self;
    }
    
    return self;
}

- (void)start
{
    self.executing = YES;
    NSURL * baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.renderingWebView loadHTMLString:self.htmlSource baseURL:baseURL];
}

- (BOOL)isConcurrent
{
    return NO;
}

- (BOOL)isFinished
{
    return self.finished;
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished
{
    return [NSSet setWithObjects:NSStringFromSelector(@selector(finished)), nil];
}

- (BOOL)isExecuting
{
    return self.executing;
}

+ (NSSet *)keyPathsForValuesAffectingIsExecuting
{
    return [NSSet setWithObjects:NSStringFromSelector(@selector(executing)), nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.delegate = nil;
    [self.delegate didFinishLoadingSection:self.htmlSectionType withPrintFormatter:self.renderingWebView.viewPrintFormatter];
    self.finished = YES;
    self.executing = NO;
}

@end
