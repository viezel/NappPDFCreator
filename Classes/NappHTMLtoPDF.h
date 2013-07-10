/**
 * Module developed by Napp
 * Author Mads Møller
 * www.napp.dk
 */

#import <UIKit/UIKit.h>

#define kPaperSizeA4 CGSizeMake(595,842)
#define kPaperSizeLetter CGSizeMake(612,792)

@class NappHTMLtoPDF;

@protocol NappHTMLtoPDFDelegate <NSObject>

@optional
- (void)HTMLtoPDFDidSucceed:(NappHTMLtoPDF*)htmlToPDF;
- (void)HTMLtoPDFDidFail:(NappHTMLtoPDF*)htmlToPDF;

@end


@interface NappHTMLtoPDF : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) id <NappHTMLtoPDFDelegate> delegate;

@property (nonatomic, readonly) NSString *PDFpath;

+ (id)createPDFWithURL:(NSURL*)URL pathForPDF:(NSString*)PDFpath delegate:(id <NappHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id <NappHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;
+ (id)createPDFWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL pathForPDF:(NSString*)PDFpath delegate:(id <NappHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;

@end
