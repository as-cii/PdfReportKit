# Pdf Report Kit
Pdf Report Kit is a small library that helps you in the process of creating reports starting with some HTML code. With a simple syntax you can generate pdf in seconds!

## Mustache-ready!
Pdf Report Kit uses Mustache (GRMustache implementation) to render content. With his basic syntax you can write templates with any tag you desider. For more information read the official documentation, then come back later to see how to use it in Pdf Report Kit.

**Mustache Official Documentation** (http://mustache.github.com/mustache.5.html)

**GRMustache Implementation Repository** (https://github.com/groue/GRMustache)

## Running the Demo

    git clone git@github.com:as-cii/PdfReportKit.git # or wherever your fork is located.
    git submodule init
    git submodule update


## How to install
If you want to include Pdf Report Kit in your application just follow these simple steps:

- Clone this project (it will download also GRMustache automatically)
- Go to GRMustache repository and follow the guide to include it in your application
- Copy and paste all the files (.h and .m) with PRK prefix that you find in the PdfReportKit directory
- Enjoy!

## Templates
Using Pdf Report Kit is really simple. Just create a valid html template with the following tags (NOTE THAT THESE ARE THE ONLY TAGS THAT PRK WILL MANAGE SO DO NOT USE THEM IMPROPERLY):

**Document Header** (header generated in the first report page):

	{{#documentHeader}}
		Whatever you want
	{{/documentHeader}}

**Page Header** (header generated for every page)

	{{#pageHeader}}
		foo
	{{/pageHeader}}

**Page Content** (content generated for every page)

	{{#pageContent}}
		foo
	{{/pageContent}}

**Page Footer** (footer generate for every page)

	{{#pageFooter}}
		foo
	{{/pageFooter}}

For other information about the template syntax please check the example provided in the source code.

## OK, now I want to see my report!
Once you have set up everything you can generate your report in a few steps.

Import "PRKGenerator.h" and access the singleton via: `[PRKGenerator sharedGenerator]` and then use it as follows:

	NSError * error;
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"foo" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"foo" templateURLString:templatePath itemsPerPage:20 totalItems:articles.count pageOrientation:PRKLandscapePage dataSource:self delegate:self error:&error];

Then you must conform to `PRKGeneratorDataSource` and `PRKGeneratorDelegate` in the delegates specified previously in order to provide data to the generator and to be notified when the report has finished. You could for example do something like this:

	- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber
	{
		// Return the data you want for the tag
	    return [foo dataForTag: tagName];
	}

	- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data
	{
		// Report generated!!! Now we can use NSData as we want!
	}

## Result
Here it is your wonderful report generated in few simple steps (you can skip all the steps above and see the result just by executing the example application provided)!
![Report](http://img706.imageshack.us/img706/6599/captureylw.png)
