//
//  MTEAgendaDayTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/4/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEAgendaDayTableViewController.h"
#import "MTECrearCitaViewController.h"
#import "MTEdayTableViewCell.h"
#import "MTEcitaCompleta.h"

@interface MTEAgendaDayTableViewController ()

@end

@implementation MTEAgendaDayTableViewController

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
    if (!self.hours) {
        self.hours = [[NSMutableArray alloc] init];
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(28,0,0,0);
    
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d/%d",self.day.day,self.day.month,self.day.year];
    for (int i = 6; i < 21; i++)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components: NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
        [components setHour:i];
        [components setMinute:0];
        [components setYear:self.day.year];
        [components setMonth:self.day.month];
        [components setDay:self.day.day];
        NSDate *date0 = [calendar dateFromComponents:components];
        [components setHour:i];
        [components setMinute:30];
        [components setMonth:self.day.month];
        [components setYear:self.day.year];
        NSDate *date30 = [calendar dateFromComponents:components];
        [components setHour:i+1];
        [components setMinute:00];
        [components setMonth:self.day.month];
        [components setYear:self.day.year];
        NSDate *nextHour = [calendar dateFromComponents:components];
        MTEcitaCompleta *cita1 = [[MTEcitaCompleta alloc] init];
        MTEcitaCompleta *cita2 = [[MTEcitaCompleta alloc] init];
        cita1.date = date0;
        cita1.dateFin=date30;
        cita2.date = date30;
        cita2.dateFin = nextHour;
        [self.hours addObject:cita1];
        [self.hours addObject:cita2];
    }
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addCita:(MTEcita *)cita
{
    [self.iamvc.citas addObject:cita];
    self.citas = self.iamvc.citas;
    [self.tableView reloadData];
}

-(void)updateCita:(MTEcita *)cita
{
    for (int i = 0;i < self.citas.count; i ++)
    {
        MTEcita *cit = [self.citas objectAtIndex:i];
        if ([cit.idCita isEqualToString:cita.idCita])
        {
            [self.citas replaceObjectAtIndex:i withObject:cita];
        }
    }
    self.iamvc.citas = self.citas;
    [self.tableView reloadData];
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
    return [self.hours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dia";
    MTEdayTableViewCell *cell = (MTEdayTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTEdayTableViewCell"
                                                                 owner:self
                                                               options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MTEdayTableViewCell *) currentObject;
                break;
            }
        }
    }
    UILabel *hour = (UILabel *)[cell viewWithTag:100];
    MTEcitaCompleta *cCompl =[self.hours objectAtIndex:indexPath.row];
    NSDate *date = cCompl.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    UILabel *event = (UILabel *)[cell viewWithTag:200];
    UILabel *pac = (UILabel *)[cell viewWithTag:300];
    [hour setFont:[UIFont systemFontOfSize:20]];
    for (MTEcita *cit in self.citas)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateCita = [dateFormat dateFromString:cit.fechaInicio];
        NSDate *dateCitaFin = [dateFormat dateFromString:cit.fechaFin];
        if ([date isEqualToDate:dateCita])
        {
            
            event.text = cit.desc;
            pac.text = [NSString stringWithFormat:@"%@ %@",cit.paci.nombre,cit.paci.apellido];
            cCompl.cita = cit;
            break;
        }
        NSDate *temp1 = [date earlierDate:dateCita];
        if ([temp1 isEqualToDate:dateCita])
        {
            NSDate *temp2 = [date laterDate:dateCitaFin];
            if ([temp2 isEqualToDate:dateCitaFin]&&![date isEqualToDate:dateCitaFin])
            {
                event.text = cit.desc;
                pac.text = [NSString stringWithFormat:@"%@ %@",cit.paci.nombre,cit.paci.apellido];
                cCompl.cita = cit;
                break;
            }
        }
    }
    NSString *hourMinute = [formatter stringFromDate:date];
    hour.text = hourMinute;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTECrearCitaViewController *ccvc = [storyboard instantiateViewControllerWithIdentifier:@"crearCita"];
    ccvc.day = [[self.hours objectAtIndex:indexPath.row] date];
    ccvc.memberID = self.memberID;
    ccvc.consul = self.consul;
    ccvc.adtvc = self;
    ccvc.cita = [[self.hours objectAtIndex:indexPath.row] cita];
    [self.navigationController pushViewController:ccvc
                                         animated:YES];
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
