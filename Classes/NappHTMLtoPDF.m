/**
 * Module developed by Napp
 * Author Mads Møller
 * www.napp.dk
 */

#import "NappHTMLtoPDF.h"
#import "TiUtils.h"
#import "TiProxy.h"

@interface NappHTMLtoPDF ()

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *HTML;
@property (nonatomic, strong) NSString *PDFpath;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) UIEdgeInsets pageMargins;

@end

@interface UIPrintPageRenderer (PDF)

- (NSData*) printToPDF;

@end

@implementation NappHTMLtoPDF

@synthesize URL=_URL,webview,delegate=_delegate,PDFpath=_PDFpath,pageSize=_pageSize,pageMargins=_pageMargins;

// Create PDF by passing in the URL to a webpage
+ (id)createPDFWithURL:(NSURL*)URL pathForPDF:(NSString*)PDFpath delegate:(id <NappHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    NappHTMLtoPDF *creator = [[NappHTMLtoPDF alloc] initWithURL:URL delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    
    return creator;
}

// Create PDF by passing in the HTML as a String
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id <NappHTMLtoPDFDelegate>)delegate
               pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    NappHTMLtoPDF *creator = [[NappHTMLtoPDF alloc] initWithHTML:HTML baseURL:nil delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    
    return creator;
}

// Create PDF by passing in the HTML as a String, with a base URL
+ (id)createPDFWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL pathForPDF:(NSString*)PDFpath delegate:(id <NappHTMLtoPDFDelegate>)delegate
               pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    NappHTMLtoPDF *creator = [[NappHTMLtoPDF alloc] initWithHTML:HTML baseURL:baseURL delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    
    return creator;
}

- (id)initWithURL:(NSURL*)URL delegate:(id <NappHTMLtoPDFDelegate>)delegate pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    self = [super init];
    if (self)
    {
        self.URL = URL;
        self.delegate = delegate;
        self.PDFpath = PDFpath;
                
        self.pageMargins = pageMargins;
        self.pageSize = pageSize;

        [[UIApplication sharedApplication].delegate.window addSubview:self.view];

        self.view.frame = CGRectMake(0, 0, 1, 1);
        self.view.alpha = 0.0;
    }
    return self;
}

- (id)initWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL delegate:(id <NappHTMLtoPDFDelegate>)delegate
        pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    self = [super init];
    if (self)
    {
        self.HTML = HTML;
        self.URL = baseURL;
        self.delegate = delegate;
        self.PDFpath = PDFpath;
        
        self.pageMargins = pageMargins;
        self.pageSize = pageSize;
        
        [[UIApplication sharedApplication].delegate.window addSubview:self.view];
        
        self.view.frame = CGRectMake(0, 0, 1, 1);
        self.view.alpha = 0.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    webview.delegate = self;
    
    [self.view addSubview:webview];
    
    if (self.HTML == nil) {
        [webview loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }else{
        [webview loadHTMLString:self.HTML baseURL:self.URL];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading) return;
    
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    
    [render addPrintFormatter:webView.viewPrintFormatter startingAtPageAtIndex:0];
        
    CGRect printableRect = CGRectMake(self.pageMargins.left,
                                  self.pageMargins.top,
                                  self.pageSize.width - self.pageMargins.left - self.pageMargins.right,
                                  self.pageSize.height - self.pageMargins.top - self.pageMargins.bottom);
    
    CGRect paperRect = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height);
    
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];

    NSData *pdfData = [render printToPDF];
        
    [pdfData writeToFile: self.PDFpath  atomically: YES ];
    
    [self terminateWebTask];

    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFDidSucceed:)]) {
        [self.delegate HTMLtoPDFDidSucceed:self];
    }
        
    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView.isLoading) return;
    
    [self terminateWebTask];

    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFDidFail:)])
        [self.delegate HTMLtoPDFDidFail:self];

}

// clean up

- (void)terminateWebTask
{
    [self.webview stopLoading];
    self.webview.delegate = nil;
    [self.webview removeFromSuperview];
    [self.view removeFromSuperview];
    self.webview = nil;
}
/*
-(void)dealloc
{
    RELEASE_TO_NIL(webview);
	[super dealloc];
}*/

@end

@implementation UIPrintPageRenderer (PDF)

- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
        
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
        
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    
    UIGraphicsEndPDFContext();
        
    return pdfData;
}

@end
