/**
 * Module developed by Napp
 * Author Mads Møller
 * www.napp.dk
 */

#import "TiModule.h"
#import "NappHTMLtoPDF.h"

@interface DkNappPdfCreatorModule : TiModule <NappHTMLtoPDFDelegate>
{
}

@property (nonatomic, strong) NappHTMLtoPDF *PDFCreator;

- (void)generatePDFWithURL:(id)args;
- (void)HTMLtoPDFDidSucceed:(NappHTMLtoPDF*)htmlToPDF;
- (void)HTMLtoPDFDidFail:(NappHTMLtoPDF*)htmlToPDF;



@end
