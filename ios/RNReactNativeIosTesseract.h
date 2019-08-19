
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <TesseractOCR/TesseractOCR.h>

@interface RNReactNativeIosTesseract : NSObject <RCTBridgeModule, G8TesseractDelegate>

@end
  
