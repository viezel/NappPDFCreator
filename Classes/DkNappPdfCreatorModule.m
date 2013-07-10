/**
 * Module developed by Napp
 * Author Mads Møller
 * www.napp.dk
 */

#import "DkNappPdfCreatorModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation DkNappPdfCreatorModule

@synthesize PDFCreator;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"94511658-4141-475b-982f-9a466dc1f69c";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"dk.napp.pdf.creator";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs


- (void)generatePDFWithURL:(id)args
{
    ENSURE_UI_THREAD(generatePDFWithURL,args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *url = [TiUtils stringValue:@"url" properties:args def:nil];
    NSString *filename = [TiUtils stringValue:@"filename" properties:args def:nil];
    
    
    
    if(url == nil || filename == nil){
        NSLog(@"[ERROR] generatePDFWithURL: url & filename must be defined");
        if ([self _hasListeners:@"error"]) {
            [self fireEvent:@"error" withObject:@{ @"success": NUMBOOL(NO) } propagate:YES];
        }
        return;
    }
    
    
    
    //NSString *filePath = @"~/Documents/";
    //filePath = [filePath stringByAppendingString:filename];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    self.PDFCreator = [NappHTMLtoPDF createPDFWithURL:[NSURL URLWithString:url]
                                         pathForPDF:[filePath stringByExpandingTildeInPath]
                                         delegate:self
                                         pageSize:kPaperSizeA4
                                         margins:UIEdgeInsetsMake(10, 5, 10, 5)];
}

- (void)generatePDFWithHTML:(id)args
{
    ENSURE_UI_THREAD(generatePDFWithHTML,args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *html = [TiUtils stringValue:@"html" properties:args def:nil];
    NSString *filename = [TiUtils stringValue:@"filename" properties:args def:nil];
    
    if(html == nil || filename == nil){
        NSLog(@"[ERROR] generatePDFWithHTML: html & filename must be defined");
        if ([self _hasListeners:@"error"]) {
            [self fireEvent:@"error" withObject:@{ @"success": NUMBOOL(NO) } propagate:YES];
        }
        return;
    }
    
    //NSString *filePath = @"~/Documents/";
    //filePath = [filePath stringByAppendingString:filename];
    
    
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:filename];
    self.PDFCreator = [NappHTMLtoPDF createPDFWithHTML:html
                                            baseURL:[[NSBundle mainBundle] bundleURL] //local images
                                            pathForPDF:[filePath stringByExpandingTildeInPath]
                                            delegate:self
                                            pageSize:kPaperSizeA4
                                            margins:UIEdgeInsetsMake(10, 5, 10, 5)];
}

- (void)HTMLtoPDFDidSucceed:(NappHTMLtoPDF*)htmlToPDF
{
    NSLog(@"NappHTMLtoPDF did succeed");
    
    if ([self _hasListeners:@"complete"]) {
		[self fireEvent:@"complete" withObject:@{
         @"success": NUMBOOL(TRUE),
         @"path": htmlToPDF.PDFpath
         } propagate:YES];
	}
}

- (void)HTMLtoPDFDidFail:(NappHTMLtoPDF*)htmlToPDF
{
    NSLog(@"NappHTMLtoPDF did fail");
    
    if ([self _hasListeners:@"error"]) {
		[self fireEvent:@"error" withObject:@{ @"success": NUMBOOL(NO) } propagate:YES];
	}
}


@end
