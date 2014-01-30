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

#import "PRKPageRenderer.h"

@implementation PRKPageRenderer

- (CGRect)paperRect
{
    return self.pageRect;
}

- (CGRect)printableRect
{
    return CGRectInset([self paperRect], 20, 20);
}

- (id)initWithHeaderFormatter:(UIPrintFormatter *)headerFormatter headerHeight:(CGFloat)headerHeight andContentFormatter:(UIPrintFormatter *)contentFormatter andFooterFormatter:(UIPrintFormatter *)footerFormatter footerHeight:(CGFloat)footerHeight
{
    self = [super init];
    if (self)
    {
        self.pageRect = UIGraphicsGetPDFContextBounds();
        self.headerHeight = headerHeight;
        self.footerHeight = footerHeight;
        
        headerPrintFormatter = headerFormatter;
        footerPrintFormatter = footerFormatter;
        [self addPrintFormatter:contentFormatter startingAtPageAtIndex:0];
    }
    
    return self;
}

- (void)addPagesToPdfContext
{
    [self prepareForDrawingPages:NSMakeRange(0, 1)];
    
    NSInteger pages = [self numberOfPages];
    for (int i = 0; i < pages; i++)
    {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex:i inRect:self.pageRect];
    }
}

- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect
{
    PRKPageRenderer * headerRenderer = [[PRKPageRenderer alloc] init];
    headerRenderer.pageRect = self.pageRect;
    
    [headerRenderer addPrintFormatter:headerPrintFormatter startingAtPageAtIndex:0];    
    [headerRenderer drawPageAtIndex:0 inRect:headerRect];
}

- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)footerRect
{
    PRKPageRenderer * r = [[PRKPageRenderer alloc] init];
    r.pageRect = CGRectMake(footerRect.origin.x, footerRect.origin.y - 20, footerRect.size.width, footerRect.size.height + self.footerHeight);
    
    [r addPrintFormatter:footerPrintFormatter startingAtPageAtIndex:0];
    [r drawPageAtIndex:0 inRect:footerRect];
}

@end
