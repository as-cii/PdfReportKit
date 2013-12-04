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

#import "PRKGenerator.h"
#import "PRKRenderHtmlOperation.h"
#import "GRMustache.h"
#import "PRKPageRenderer.h"
#import "PRKFakeRenderer.h"

@interface PRKGenerator ()

@property (nonatomic, copy)   NSString * currentReportName;
@property (nonatomic, assign) NSUInteger currentReportPage;
@property (nonatomic, assign) NSUInteger currentReportItemsPerPage;
@property (nonatomic, assign) NSUInteger currentReportTotalItems;
@property (nonatomic, assign) NSUInteger currentNumberOfItems;
@property (nonatomic, assign) NSUInteger remainingItems;
@property (nonatomic, assign) NSUInteger currentMaxItemsSinglePage;
@property (nonatomic, assign) NSUInteger currentMinItemsSinglePage;
@property (nonatomic, assign) BOOL       currentSuccessSinglePage;

@property (nonatomic, strong) NSMutableData      * currentReportData;
@property (nonatomic, strong) GRMustacheTemplate * template;

@property (nonatomic, strong) NSMutableDictionary * renderedTags;

@property (nonatomic, strong) UIPrintFormatter * headerFormatter;
@property (nonatomic, strong) UIPrintFormatter * contentFormatter;
@property (nonatomic, strong) UIPrintFormatter * footerFormatter;

@property (nonatomic, strong) NSOperationQueue * renderingQueue;

@end

@implementation PRKGenerator

// Static fields

+ (instancetype)sharedGenerator {
	static id instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!instance) {
			instance = [[self alloc] init];
		}
	});
	return instance;
}

+ (NSSet *)reportDefaultTags {
	static NSSet *tags = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!tags) {
			tags = [NSSet setWithObjects:@"documentHeader", @"pageHeader", @"pageContent", @"pageFooter", @"pageNumber", nil];
		}
	});
	return tags;
}

- (id)init
{
    self = [super init];
    if (self)
    {        
        // Initialize rendering queue
        self.renderingQueue = [NSOperationQueue mainQueue];
        self.renderingQueue.name = @"Rendering Queue";
        self.renderingQueue.maxConcurrentOperationCount = 1;
        
        self.renderedTags = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (CGSize)pageSizeForLetterWithOrientation:(PRKPageOrientation)orientation {
    CGFloat resolution = 72.0;
    CGSize sizeInInches = (orientation == PRKPortraitPage) ? CGSizeMake(8.5, 11.0) : CGSizeMake(11.0, 8.5);
    return CGSizeMake(sizeInInches.width * resolution, sizeInInches.height * resolution);
}

+ (CGSize)pageSizeForA4WithOrientation:(PRKPageOrientation)orientation {
    CGFloat resolution = 72.0;
    CGSize sizeInInches = (orientation == PRKPortraitPage) ? CGSizeMake(8.27, 11.69) : CGSizeMake(11.69, 8.27);
    return CGSizeMake(sizeInInches.width * resolution, sizeInInches.height * resolution);
}

+ (PRKPageFormat)defaultPageFormatForLocale:(NSLocale *)locale {
    NSDictionary * components = [NSLocale componentsFromLocaleIdentifier:locale.localeIdentifier];
    NSString * country = components[NSLocaleCountryCode];
    NSSet * letterCountries = [NSSet setWithObjects:@"US", @"CA", @"MX", @"CO", @"VE", @"AR", @"CL", @"PH", nil];
    if ([letterCountries containsObject:country]) {
        return PRKLetterFormat;
    }
    return PRKA4Format;
}

- (void)createReportWithName:(NSString *)reportName templateURLString:(NSString *)templatePath itemsPerPage:(NSUInteger)itemsPerPage totalItems:(NSUInteger)totalItems pageOrientation:(PRKPageOrientation)orientation dataSource:(id<PRKGeneratorDataSource>)dataSource delegate:(id<PRKGeneratorDelegate>)delegate error:(NSError *__autoreleasing *)error {
    PRKPageFormat pageFormat = [[self class] defaultPageFormatForLocale:[NSLocale currentLocale]];
    [self createReportWithName:reportName
             templateURLString:templatePath
                  itemsPerPage:itemsPerPage
                    totalItems:totalItems
                    pageFormat:pageFormat
               pageOrientation:orientation
                    dataSource:dataSource
                      delegate:delegate
                         error:error];
}

- (void)createReportWithName:(NSString *)reportName templateURLString:(NSString *)templatePath itemsPerPage:(NSUInteger)itemsPerPage totalItems:(NSUInteger)totalItems pageFormat:(PRKPageFormat)format pageOrientation:(PRKPageOrientation)orientation dataSource: (id<PRKGeneratorDataSource>)dataSource delegate: (id<PRKGeneratorDelegate>)delegate error:(NSError *__autoreleasing *)error
{
    CGSize pageSize = [[self class] pageSizeForA4WithOrientation:orientation];
    if (format == PRKLetterFormat)
        pageSize = [[self class] pageSizeForLetterWithOrientation:orientation];
    
    [self createReportWithName:reportName
             templateURLString:templatePath
                  itemsPerPage:itemsPerPage
                    totalItems:totalItems
                    pageSize:pageSize
                    dataSource:dataSource
                      delegate:delegate
                         error:error];
}

- (void)createReportWithName:(NSString *)reportName templateURLString:(NSString *)templatePath itemsPerPage:(NSUInteger)itemsPerPage totalItems:(NSUInteger)totalItems pageSize:(CGSize)pageSize dataSource: (id<PRKGeneratorDataSource>)dataSource delegate: (id<PRKGeneratorDelegate>)delegate error:(NSError *__autoreleasing *)error
{
    // TODO: replace and add report processing to queue
    if (self.renderingQueue.operationCount > 0)
        return;
    
    self.dataSource = dataSource;
    self.delegate = delegate;
    self.currentReportData = [NSMutableData data];
    self.template = [GRMustacheTemplate templateFromContentsOfFile:templatePath error:error];
    if (*error)
        return;
    
    UIGraphicsBeginPDFContextToData(self.currentReportData, CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    
    self.currentReportItemsPerPage = itemsPerPage;
    self.currentNumberOfItems = self.currentReportItemsPerPage;
    self.currentMaxItemsSinglePage = itemsPerPage;
    self.currentMinItemsSinglePage = itemsPerPage;
    self.currentReportTotalItems = totalItems;
    self.currentSuccessSinglePage = NO;
    self.remainingItems = 0;
    
    [self.renderingQueue addOperationWithBlock:^{
        [self createPage:0];
    }];
}

- (void)createPage:(NSUInteger)page
{
    int i = page;
    if (self.remainingItems < self.currentReportTotalItems)
    {
        [self.renderedTags removeAllObjects];
        self.currentReportPage = i + 1;
        
        NSError * error;
        // PRKGenerator is key-value "get" compliant (as GRMustache needs), so we could use self
        NSString * renderedHtml = [self.template renderObject:self error:&error];
        
        NSMutableString * wellFormedHeader = [NSMutableString stringWithString:renderedHtml];
        NSMutableString * wellFormedContent = [NSMutableString stringWithString:renderedHtml];
        NSMutableString * wellFormedFooter = [NSMutableString stringWithString:renderedHtml];
        
        // Trim content and footer to get header
        [wellFormedHeader replaceOccurrencesOfString:[self.renderedTags objectForKey:@"pageContent"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedHeader.length)];
        [wellFormedHeader replaceOccurrencesOfString:[self.renderedTags objectForKey:@"pageFooter"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedHeader.length)];
        
        // Trim header and footer to get content
        [wellFormedContent replaceOccurrencesOfString:[self.renderedTags objectForKey:@"documentHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedContent.length)];
        [wellFormedContent replaceOccurrencesOfString:[self.renderedTags objectForKey:@"pageHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedContent.length)];
        [wellFormedContent replaceOccurrencesOfString:[self.renderedTags objectForKey:@"pageFooter"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedContent.length)];
        
        // Trim content and header to get footer
        [wellFormedFooter replaceOccurrencesOfString:[self.renderedTags objectForKey:@"documentHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedFooter.length)];
        [wellFormedFooter replaceOccurrencesOfString:[self.renderedTags objectForKey:@"pageHeader"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedFooter.length)];
        [wellFormedFooter replaceOccurrencesOfString:[self.renderedTags objectForKey:@"pageContent"] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, wellFormedFooter.length)];
        
        PRKRenderHtmlOperation * headerOperation = [[PRKRenderHtmlOperation alloc] initWithHtmlContent:wellFormedHeader andSectionType:PRKSectionTypeHeader];
        headerOperation.delegate = self;
        PRKRenderHtmlOperation * contentOperation = [[PRKRenderHtmlOperation alloc] initWithHtmlContent:wellFormedContent andSectionType:PRKSectionTypeContent];
        contentOperation.delegate = self;
        PRKRenderHtmlOperation * footerOperation = [[PRKRenderHtmlOperation alloc] initWithHtmlContent:wellFormedFooter andSectionType:PRKSectionTypeFooter];
        footerOperation.delegate = self;
        
        NSInvocationOperation * renderToPdf = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(renderPage) object:[NSNumber numberWithInteger:i]];
        
        [self.renderingQueue addOperations:@[headerOperation,
                                             contentOperation,
                                             footerOperation,
                                             renderToPdf] waitUntilFinished:NO];
    }
    else
    {
        [self.renderingQueue addOperationWithBlock:^{
            // Invoke on main thread, otherwise it won't work!
            [self closePdfContext];
        }];
    }
}

- (id)valueForKey:(NSString *)key
{
    id<PRKGeneratorDataSource> source = [[[self class] reportDefaultTags] containsObject:key] ? self : self.dataSource;
    id data = [source reportsGenerator:self
                         dataForReport:self.currentReportName
                               withTag:key
                               forPage:self.currentReportPage
                                offset:self.remainingItems
                            itemsCount:self.currentNumberOfItems];
    
    return data;
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber offset:(NSUInteger)offset itemsCount:(NSUInteger)itemsCount
{
        
    return [GRMustache renderingObjectWithBlock:^NSString *(GRMustacheTag *tag, GRMustacheContext *context, BOOL *HTMLSafe, NSError *__autoreleasing *error)
    {
        NSString * renderedTag;
        if (pageNumber > 1 && [tagName isEqualToString:@"documentHeader"])
        {
            renderedTag =  @"";
        }
        else if ([tagName isEqualToString:@"pageNumber"])
        {
            renderedTag = [NSString stringWithFormat:@"%d", pageNumber];
        }
        else
            renderedTag = [tag renderContentWithContext:context HTMLSafe:HTMLSafe error:error];
        
        [self.renderedTags setObject:renderedTag forKey:tagName];
            
        return renderedTag;
    }];
}

- (void)didFinishLoadingSection:(PRKSectionType)sectionType withPrintFormatter:(UIPrintFormatter *)formatter
{
    if (sectionType == PRKSectionTypeHeader)
        self.headerFormatter = formatter;
    else if (sectionType == PRKSectionTypeContent)
        self.contentFormatter = formatter;
    else if (sectionType == PRKSectionTypeFooter)
        self.footerFormatter = formatter;
    else
        [NSException raise:@"Invalid Section Type" format:@"Section Type: %d is invalid", sectionType];
}

- (void)renderPage
{
    // Invoke this operation on UI Thread, otherwise it won't work!
    [self internalRenderPage];
}

- (void)internalRenderPage
{
    PRKFakeRenderer * headerFakeRenderer = [[PRKFakeRenderer alloc] init];
    [headerFakeRenderer addPrintFormatter:self.headerFormatter startingAtPageAtIndex:0];
    PRKFakeRenderer * footerFakeRenderer = [[PRKFakeRenderer alloc] init];
    [footerFakeRenderer addPrintFormatter:self.footerFormatter startingAtPageAtIndex:0];
    
    int headerHeight = [headerFakeRenderer contentHeight];
    int footerHeight = [footerFakeRenderer contentHeight];
    
    PRKPageRenderer * pageRenderer = [[PRKPageRenderer alloc] initWithHeaderFormatter:self.headerFormatter headerHeight:headerHeight andContentFormatter:self.contentFormatter andFooterFormatter:self.footerFormatter footerHeight:footerHeight];
    
    NSUInteger pageNumber = self.currentReportPage;
    if (pageRenderer.numberOfPages > 1)
    {
        if (self.currentSuccessSinglePage) {
            self.currentNumberOfItems --;
        }
        else
        {
            self.currentNumberOfItems = self.currentNumberOfItems / 2;
        }
        pageNumber--;
    }
    else
    {
        // è il massimo numero di elementi che posso stampare quindi stampo il pdf
        if (self.currentMinItemsSinglePage == self.currentNumberOfItems) {
            [pageRenderer addPagesToPdfContext];
            self.remainingItems += self.currentNumberOfItems;
            self.currentNumberOfItems =  self.currentMaxItemsSinglePage;
            self.currentMinItemsSinglePage = self.currentNumberOfItems;
            self.currentSuccessSinglePage = NO;
        }
        else
        {
            //provo a stampare un elemento in piu e setto il minimo con cui funziona
            self.currentMinItemsSinglePage = self.currentNumberOfItems;
            self.currentNumberOfItems = self.currentNumberOfItems + 1;
            self.currentSuccessSinglePage = YES;
            pageNumber--;
        }
    }
    
    [self.renderingQueue addOperationWithBlock:^{
        [self createPage:pageNumber];
    }];
}

- (void)closePdfContext
{    
    UIGraphicsEndPDFContext();
    [self.delegate reportsGenerator:self didFinishRenderingWithData:self.currentReportData];
    self.currentReportData = nil;
}

@end
