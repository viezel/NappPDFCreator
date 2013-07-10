/**
 * Module developed by Napp
 * Author Mads Møller
 * www.napp.dk
 */

@interface DkNappPdfCreatorModuleAssets : NSObject
{
}
- (NSData*) moduleAsset;
- (NSData*) resolveModuleAsset:(NSString*)path;

@end
