//
//  DisplayTableViewController.m
//  SampleProject
//
//  Created by TheAppGuruz-New-6 on 07/05/14.
//  Copyright (c) 2014 TheAppGuruz-New-6. All rights reserved.
//

#import "DisplayTableViewController.h"

@interface DisplayTableViewController ()

@end

@implementation DisplayTableViewController
{
    NSMutableDictionary *dict;
    NSMutableArray *currentRow;
     NSMutableArray *currentRowSepc;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

 

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"----");
    NSLog(@"%@", NSHomeDirectory());
    
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"downloadFight.csv" ]  ;
    
    NSString *path = filePath;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"flight" ofType:@"csv"];
    
    CHCSVParser *parser=[[CHCSVParser alloc] initWithContentsOfCSVFile:path delimiter:','];

    
    parser.delegate=self;
    [parser parse];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) parserDidBeginDocument:(CHCSVParser *)parser
{
    currentRow = [[NSMutableArray alloc] init];
    currentRowSepc = [NSMutableArray arrayWithObjects:dict,nil];
}

-(void) parserDidEndDocument:(CHCSVParser *)parser
{
    
    for(int i=0;i<[currentRow count];i++)
    {   NSString *companyCode =[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"2"]];
        NSString *arriedCity =[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"12"]];
        NSString *compartCompany = [[NSUserDefaults standardUserDefaults] objectForKey:@"Company"];
         NSString *compartArried= [[NSUserDefaults standardUserDefaults] objectForKey:@"Arried"];
        
        if ([companyCode  isEqual: compartCompany]   &&  [arriedCity  isEqual:  compartArried]   )
        {
            NSLog(@"--- %@ ---- ", [currentRow objectAtIndex:i]);
            id myArrayElement = [currentRow objectAtIndex:i];
 
            [currentRowSepc addObject:myArrayElement];
        NSLog(@"%@          %@          %@",[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"0"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"1"]],[[currentRow objectAtIndex:i] valueForKey:[NSString stringWithFormat:@"2"]]);
        }
    }
    NSLog(@"123");
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
    [dict setObject:field forKey:[NSString stringWithFormat:@"%d",fieldIndex]];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
    [currentRow addObject:dict];
    dict=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSLog(@"counttt %d",[currentRowSepc count]);
    return [currentRowSepc count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.lblRno setText:[[currentRowSepc objectAtIndex:indexPath.row] valueForKey:[NSString stringWithFormat:@"3"]]];
    [cell.lblName setText:[[currentRowSepc objectAtIndex:indexPath.row] valueForKey:[NSString stringWithFormat:@"5"]]];
    [cell.lblMarks setText:[[currentRowSepc objectAtIndex:indexPath.row] valueForKey:[NSString stringWithFormat:@"12"]]];
    [cell.M2 setText:[[currentRowSepc objectAtIndex:indexPath.row] valueForKey:[NSString stringWithFormat:@"6"]]];
    [cell.Arrired setText:[[currentRowSepc objectAtIndex:indexPath.row] valueForKey:[NSString stringWithFormat:@"13"]]];

    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
