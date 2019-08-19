
#import "RNTextDetector.h"

#import <React/RCTBridge.h>
#import <CoreML/CoreML.h>
#import <Vision/Vision.h>
#import <TesseractOCR/TesseractOCR.h>

@implementation RNTextDetector


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

static NSString *const detectionNoResultsMessage = @"Something went wrong";

RCT_REMAP_METHOD(recognize, recognize:(NSString *)imagePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if (!imagePath) {
        resolve(@NO);
        return;
    }

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
    UIImage *image = [UIImage imageWithData:imageData];

    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];

    // Optionaly: You could specify engine to recognize with.
    // G8OCREngineModeTesseractOnly by default. It provides more features and faster
    // than Cube engine. See G8Constants.h for more information.
    //tesseract.engineMode = G8OCREngineModeTesseractOnly;

    // Set up the delegate to receive Tesseract's callbacks.
    // self should respond to TesseractDelegate and implement a
    // "- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract"
    // method to receive a callback to decide whether or not to interrupt
    // Tesseract before it finishes a recognition.
    tesseract.delegate = self;

    // This is wrapper for common Tesseract variable kG8ParamTesseditCharWhitelist:
    // [tesseract setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharBlacklist];
    // See G8TesseractParameters.h for a complete list of Tesseract variables

    // Optional: Limit the character set Tesseract should not try to recognize from
    //tesseract.charBlacklist = @"OoZzBbSs";

    // Specify the image Tesseract should recognize on
    tesseract.image = image;

    // Start the recognition
    [tesseract recognize];

    // Retrieve the recognized text
    NSLog(@"%@", [tesseract recognizedText]);

    NSString *recognizedText = [tesseract recognizedText];

    // You could retrieve more information about recognized text with that methods:

    NSArray *wordBoxes = [tesseract recognizedBlocksByIteratorLevel: G8PageIteratorLevelWord];

    NSMutableArray *output = [NSMutableArray array];

    CGRect boundingBox;
    CGSize size;
    CGPoint origin;

    for(G8RecognizedBlock *observation in wordBoxes){
        if(observation){
            NSMutableDictionary *block = [NSMutableDictionary dictionary];
            NSMutableDictionary *bounding = [NSMutableDictionary dictionary];

            boundingBox = observation.boundingBox;
            size = CGSizeMake(boundingBox.size.width * image.size.width, boundingBox.size.height * image.size.height);
            origin = CGPointMake(boundingBox.origin.x * image.size.width, (1-boundingBox.origin.y)*image.size.height - size.height);

            bounding[@"top"] = @(origin.y);
            bounding[@"left"] = @(origin.x);
            bounding[@"width"] = @(size.width);
            bounding[@"height"] = @(size.height);
            block[@"text"] = observation.text;
            block[@"bounding"] = bounding;
            [output addObject:block];
        }
    }

    resolve(output);
}

@end
