// 空班即查

#import "ViewController.h"
#import "AFNetworking.h"




@interface NSData (EasyUTF8)

// Safely decode the bytes into a UTF8 string
- (NSMutableData *)asUTF8String;

@end


@implementation NSData (EasyUTF8)

- (NSData *)asUTF8String {                          // https://stackoverflow.com/questions/17581447/objective-c-read-file-wrong-encoding

    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseTrad);     //下載csv修正為繁中
    
    NSString *encodeingOrigin = [[NSString alloc] initWithData:self encoding:encoding];

    NSData *data = [encodeingOrigin dataUsingEncoding:NSUTF8StringEncoding];
    
    return data ;
}

@end



@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableDictionary *dict;
    NSMutableArray *currentRow;
    NSString * input;
}
@synthesize txtMarks,txtName,txtRno;



- (NSString *)fixEncodingOfString:(NSString *)input {
    CFStringEncoding cfEncoding = kCFStringEncodingMacRoman;
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
    NSData *data = [input dataUsingEncoding:encoding];
    if (!data) {
        // the string wasn't actually in MacRoman
        return nil;
    }
    NSString *output =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]   ;
    return output;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //--- 以下是從公開資料網下載資料opendata
//    NSString *stringURL = @"https://quality.data.gov.tw/dq_download_csv.php?nid=26194&md5_url=30fcb35146703761e5d385a300157cd7";
//    NSURL  *url = [NSURL URLWithString:stringURL];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    if ( urlData )
//    {
//        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString  *documentsDirectory = [paths objectAtIndex:0];
//        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"downloadFight.csv"];
//
//        NSLog( documentsDirectory);
//        [[urlData asUTF8String ] writeToFile:filePath atomically:YES ];
////        [urlData writeToFile:filePath atomically:YES    ];
//    }
//    //---
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) parserDidBeginDocument:(CHCSVParser *)parser
{
    currentRow = [[NSMutableArray alloc] init];
}

-(void) parserDidEndDocument:(CHCSVParser *)parser
{
    for(int i=0;i<[currentRow count];i++)
    {
        NSLog(@"%@          %@          %@",[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"1"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"2"]]);
    }
}

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
}

-(void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    dict=[[NSMutableDictionary alloc]init];
}

-(void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    [dict setObject:field forKey:[NSString stringWithFormat:@"%ld",(long)fieldIndex]];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
    [currentRow addObject:dict];
    dict=nil;
}


- (IBAction)btnWrite:(id)sender
{
    
    
    
    
    //--- 以下是從公開資料網下載資料opendata
    NSString *stringURL = @"http://www.taoyuan-airport.com/uploads/flightx/a_flight_v4.csv";
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"downloadFight.csv"];
        
        NSLog( documentsDirectory);
       
 
        [  [ urlData asUTF8String ] writeToFile:filePath atomically:YES];
    }
    //---
    
//    CHCSVParser *parser=[[CHCSVParser alloc] initWithContentsOfCSVFile:[NSHomeDirectory() stringByAppendingPathComponent:@"demo.csv"] delimiter:','];
//    parser.delegate=self;
//    [parser parse];
//
//    CHCSVWriter *csvWriter=[[CHCSVWriter alloc]initForWritingToCSVFile:[NSHomeDirectory() stringByAppendingPathComponent:@"demo.csv"]];
//    NSLog(@"%lu",(unsigned long)[currentRow count]);
//
//    [csvWriter writeField:@"Roll Number"];
//    [csvWriter writeField:@"Name"];
//    [csvWriter writeField:@"Marks"];
//    [csvWriter finishLine];
//
//    for(int i=1;i<[currentRow count];i++)
//    {
//        [csvWriter writeField:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]]];
//        [csvWriter writeField:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"1"]]];
//        [csvWriter writeField:[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"2"]]];
//        [csvWriter finishLine];
//    }
//    [csvWriter writeField:[txtRno text]];
//    [csvWriter writeField:[txtName text]];
//    [csvWriter writeField:[txtMarks text]];
//
//
//
//    [csvWriter closeStream];
//
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Your data has been successfully saved." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alert show];
//
//    txtRno.text=@"";
//    txtName.text=@"";
//    txtMarks.text=@"";
}

- (IBAction)btnDismissKeyboardClicked:(id)sender
{
    [txtRno resignFirstResponder];
    [txtName resignFirstResponder];
    [txtMarks resignFirstResponder];
}
@end
