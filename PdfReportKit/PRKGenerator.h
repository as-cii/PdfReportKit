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

#import <Foundation/Foundation.h>
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"
#import "GRMustache.h"
#import "PRKRenderHtmlOperation.h"

typedef NS_ENUM(NSInteger, PRKPageFormat) {
    PRKA4Format,
    PRKLetterFormat
};

typedef NS_ENUM(NSInteger, PRKPageOrientation) {
    PRKPortraitPage,
    PRKLandscapePage
};

@interface PRKGenerator : NSObject <PRKGeneratorDataSource, PRKRenderHtmlOperationDelegate>

@property (nonatomic, weak) id<PRKGeneratorDataSource> dataSource;
@property (nonatomic, weak) id<PRKGeneratorDelegate> delegate;

// Instance methods
- (void)createReportWithName:(NSString *)reportName itemsPerPage:(NSUInteger)itemsPerPage totalItems:(NSUInteger)totalItems pageOrientation:(PRKPageOrientation)orientation dataSource:(id<PRKGeneratorDataSource>)dataSource delegate:(id<PRKGeneratorDelegate>)delegate error:(NSError *__autoreleasing *)error;
- (void)createReportWithName:(NSString *)reportName templateURLString:(NSString *)templatePath itemsPerPage:(NSUInteger)itemsPerPage totalItems:(NSUInteger)totalItems pageFormat:(PRKPageFormat)format pageOrientation:(PRKPageOrientation)orientation dataSource:(id<PRKGeneratorDataSource>)dataSource delegate:(id<PRKGeneratorDelegate>)delegate error:(NSError *__autoreleasing *)error;
- (void)createReportWithName:(NSString *)reportName templateURLString:(NSString *)templatePath itemsPerPage:(NSUInteger)itemsPerPage totalItems:(NSUInteger)totalItems pageSize:(CGSize)pageSize dataSource:(id<PRKGeneratorDataSource>)dataSource delegate:(id<PRKGeneratorDelegate>)delegate error:(NSError *__autoreleasing *)error;

// Static methods
+ (instancetype)sharedGenerator;

+ (CGSize)pageSizeForLetterWithOrientation:(PRKPageOrientation)orientation;
+ (CGSize)pageSizeForA4WithOrientation:(PRKPageOrientation)orientation;

+ (PRKPageFormat)defaultPageFormatForLocale:(NSLocale *)locale;

@end
