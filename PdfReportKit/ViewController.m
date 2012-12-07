//
//  ViewController.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "ViewController.h"
#import "PRKGenerator.h"
#import "PRKRenderHtmlOperation.h"
#import "InvoiceItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    double total = 0;
    NSMutableArray * articles = [NSMutableArray array];
    for (int i = 0; i < 200; i++) {
        int element = i + 123456;
        InvoiceItem * item = [[InvoiceItem alloc] init];
        item.number = element;
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy";
        
        item.date = [formatter stringFromDate:[NSDate date]];
        item.due = [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:30 * 24 * 60 * 60]];
        item.notes = @"";
        item.originalTotal = element;
        item.effectiveTotal = element;
        item.receivedTotal = element * 0.8;
        
        total += item.receivedTotal;
        [articles addObject:item];
    }

    defaultValues = @{
        @"articles"         : articles,
        @"companyName"      : @"Teseo s.r.l.",
        @"companyAddress"   : @"Via A. Carrante, 31",
        @"companyTelephone" : @"0802205198",
        @"companyEmail"     : @"info@teseo.it",
        @"otherCompanyName" : @"Rossi Paolo s.r.l.",
        @"total"            : [NSString stringWithFormat: @"%f", total]
    };
    
    NSError * error;    
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"template1" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"template1" templateURLString:templatePath itemsPerPage:20 totalItems:articles.count pageOrientation:PRKLandscapePage dataSource:self delegate:self error:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber
{
    if ([tagName isEqualToString:@"articles"])
        return [[defaultValues valueForKey:tagName] subarrayWithRange:NSMakeRange((pageNumber - 1) * 20, 20)];
    
    return [defaultValues valueForKey:tagName];
}

- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data
{
    NSString * basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * fileName = [basePath stringByAppendingPathComponent:@"report.pdf"];
    
    [data writeToFile:fileName atomically:YES];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"OK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
