//
//  MTEiPadDayAgendaTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadDayAgendaTableViewController.h"
#import "MTEcitaCompleta.h"
#import "MTEiPadCrearCitaViewController.h"
#import "MTEiPadDayTableViewCell.h"

@interface MTEiPadDayAgendaTableViewController ()

@end

@implementation MTEiPadDayAgendaTableViewController

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
}

- (void)cargarHoras
{
    self.hours = [[NSMutableArray alloc] init];
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
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addCita:(MTEcita *)cita
{
//    [self.iamvc.citas addObject:cita];
//    self.citas = self.iamvc.citas;
//    [self.tableView reloadData];
}

-(void)updateCita:(MTEcita *)cita
{
//    for (int i = 0;i < self.citas.count; i ++)
//    {
//        MTEcita *cit = [self.citas objectAtIndex:i];
//        if ([cit.idCita isEqualToString:cita.idCita])
//        {
//            [self.citas replaceObjectAtIndex:i withObject:cita];
//        }
//    }
//    self.iamvc.citas = self.citas;
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dia";
    MTEiPadDayTableViewCell *cell = (MTEiPadDayTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTEiPadDayTableViewCell"
                                                                 owner:self
                                                               options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MTEiPadDayTableViewCell *) currentObject;
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
    UILabel *tel = (UILabel *)[cell viewWithTag:400];
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
            tel.text = cit.paci.telefono;
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
                tel.text = cit.paci.telefono;
                break;
            }
        }
    }
    NSString *hourMinute = [formatter stringFromDate:date];
    hour.text = hourMinute;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UILabel  *sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.textAlignment = NSTextAlignmentCenter;
    sectionHeader.font = [UIFont boldSystemFontOfSize:28];
    sectionHeader.textColor = [UIColor blackColor];
    sectionHeader.text = [NSString stringWithFormat:@"%d/%d/%d",self.day.day,self.day.month,self.day.year];
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 69.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEiPadCrearCitaViewController *ccvc = [storyboard instantiateViewControllerWithIdentifier:@"iPadCrearCita"];
    ccvc.day = [[self.hours objectAtIndex:indexPath.row] date];
    ccvc.memberID = self.memberID;
    ccvc.consul = self.avc.consul;
    ccvc.adtvc = self;
    ccvc.cita = [[self.hours objectAtIndex:indexPath.row] cita];
    [self.avc.navigationController pushViewController:ccvc
                                         animated:YES];
}

@end
