//
//  PRKPageRenderer.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

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
    
    int pages = [self numberOfPages];
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
