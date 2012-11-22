//
//  PRKGenerator.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "PRKGenerator.h"
#import "PRKRenderHtmlOperation.h"
#import "GRMustache.h"

@implementation PRKGenerator

// Static fields
static PRKGenerator * instance = nil;
static NSArray * reportDefaultTags = nil;

+ (PRKGenerator *)sharedGenerator
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[PRKGenerator alloc] init];
            
            
            reportDefaultTags = @[ @"documentHeader", @"pageHeader", @"pageContent", @"pageFooter" ];
        }
        
        return instance;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {        
        // Initialize rendering queue
        self.renderingQueue = [[NSOperationQueue alloc] init];
        self.renderingQueue.name = @"Rendering Queue";
        
        renderedTags = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)createReportWithName:(NSString *)reportName itemsPerPage:(NSUInteger)itemsPerPage error:(NSError *__autoreleasing *)error
{    
    NSString * templatePath = [self.dataSource reportsGenerator:self templateURLStringForReportName:reportName];
    GRMustacheTemplate * template = [GRMustacheTemplate templateFromContentsOfFile:templatePath error:error];
    if (*error)
        return;
    
    for (int i = 0; i < itemsPerPage; i++)
    {
        [renderedTags removeAllObjects];
        currentReportPage = i;
                
        // PRKGenerator is key-value "get" compliant (as GRMustache needs), so we could use self
        NSString * renderedHtml = [template renderObject:self error:error];
        
        NSMutableString * wellFormedHeader = [NSMutableString stringWithString:renderedHtml];
        [wellFormedHeader replaceOccurrencesOfString:[renderedTags objectForKey:@"pageContent"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedHeader.length)];
        [wellFormedHeader replaceOccurrencesOfString:[renderedTags objectForKey:@"pageFooter"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedHeader.length)];
        
        NSMutableString * wellFormedContent = [NSMutableString stringWithString:renderedHtml];
        [wellFormedContent replaceOccurrencesOfString:[renderedTags objectForKey:@"documentHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedContent.length)];
        [wellFormedContent replaceOccurrencesOfString:[renderedTags objectForKey:@"pageHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedContent.length)];
        [wellFormedContent replaceOccurrencesOfString:[renderedTags objectForKey:@"pageFooter"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedContent.length)];
        
        NSMutableString * wellFormedFooter = [NSMutableString stringWithString:renderedHtml];
        [wellFormedFooter replaceOccurrencesOfString:[renderedTags objectForKey:@"documentHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedFooter.length)];
        [wellFormedFooter replaceOccurrencesOfString:[renderedTags objectForKey:@"pageHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedFooter.length)];
        [wellFormedFooter replaceOccurrencesOfString:[renderedTags objectForKey:@"pageContent"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedFooter.length)];
    }
}

- (id)valueForKey:(NSString *)key
{
    id<PRKGeneratorDataSource> source = [reportDefaultTags containsObject:key] ? self : self.dataSource;
    return [source reportsGenerator:self dataForReport:currentReportName withTag:key forPage: currentReportPage];
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber
{
        
    return [GRMustache renderingObjectWithBlock:^NSString *(GRMustacheTag *tag, GRMustacheContext *context, BOOL *HTMLSafe, NSError *__autoreleasing *error)
    {
        NSString * renderedTag;
        if (pageNumber != 0 && [tagName isEqualToString:@"documentHeader"])
        {
            renderedTag =  @"";
        }
        else
            renderedTag = [tag renderContentWithContext:context HTMLSafe:HTMLSafe error:error];
        
        [renderedTags setObject:renderedTag forKey:tagName];
            
        return renderedTag;
    }];
}


@end
