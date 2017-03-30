//
//  MTEiPadAgendaMonthViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/5/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadAgendaMonthViewController.h"
#import "MTEiPadAgendaHeader.h"
#import "MTEMedicalCenter.h"

@interface MTEiPadAgendaMonthViewController ()
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic) int selectedIndex;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEiPadAgendaMonthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.days)
    {
        self.days = [[NSMutableArray alloc] init];
    }
    if (!self.citas)
    {
        self.citas = [[NSMutableArray alloc] init];
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
    //Get the info of the current date
    self.currentDay = [components day];
    self.currentMonth= [components month];
    self.currentYear = [components year];
    self.monthShowing = self.currentMonth;
    self.yearShowing = self.currentYear;
    self.currentDate = [[MTEday alloc] init];
    self.currentDate.day = self.currentDay;
    self.currentDate.month = self.currentMonth;
    self.currentDate.year = self.currentYear;
    self.currentDate.weekDay = [components weekday];
    [self fillDaysArray];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.days count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTEday *day =[self.days objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ipadDayCell" forIndexPath:indexPath];
    UIButton *name = (UIButton *)[cell viewWithTag:100];
    int w = name.frame.size.width;
    int h = name.frame.size.height;
    [name setFrame:CGRectMake(0, 0, w, h)];
    [name addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];;
    if (day.weekDay == 1 || day.weekDay == 7) {
        [name setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else {
        [name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [name setTitle:[NSString stringWithFormat:@"%d",day.day]
          forState:UIControlStateNormal];
    return cell;
}

- (IBAction)myClickEvent:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint: currentTouchPosition];
    int i = (int)indexPath.row;
    MTEday *d = [self.days objectAtIndex:i];
    [self.avc selectedDateChanged:d];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = self.collectionView.frame.size.width;
    int cellSize = ((width - 48)/7)-8;
    return CGSizeMake(cellSize, cellSize);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillDaysArray
{
    if (!((self.currentMonth == self.monthShowing) && (self.currentYear==self.yearShowing)))
    {
        MTEday *d = [[MTEday alloc] init];
        d.day = 1;
        d.month = self.monthShowing;
        d.year = self.yearShowing;
        [self.avc selectedDateChanged:d];
    }
    self.days = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //Get the day of the week of the first day of the month.
    NSString *dateStr = [NSString stringWithFormat:@"%d/%d/1",self.yearShowing,self.monthShowing];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *dateFirstDay = [dateFormat dateFromString:dateStr];
    NSDateComponents *components1 = [calendar components:(NSWeekdayCalendarUnit) fromDate:dateFirstDay];
    int weekDayFirst = (int)[components1 weekday];
    int weekDay = weekDayFirst;
    //Get the number of days of the current month
    NSRange monthDays = [calendar rangeOfUnit:NSDayCalendarUnit
                                       inUnit:NSMonthCalendarUnit
                                      forDate:dateFirstDay];
    int numberDays = (int)monthDays.length;
    //If the first day of the month is not sunday fill the previous days with the last days of the previous month
    if (weekDayFirst > 1) {
        int previousMonth = self.monthShowing - 1;
        int year = self.yearShowing;
        if (previousMonth == 0) {
            previousMonth = 12;
            year = year - 1;
        }
        NSString *dateStr1 = [NSString stringWithFormat:@"%d/%d/1",year,previousMonth];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"yyyy/MM/dd"];
        NSDate *prevMonthDate = [dateFormat1 dateFromString:dateStr1];
        NSRange monthDaysPrev = [calendar rangeOfUnit:NSDayCalendarUnit
                                               inUnit:NSMonthCalendarUnit
                                              forDate:prevMonthDate];
        int numberDaysPrevMon =(int) monthDaysPrev.length;
        for (int i = 1; i < weekDayFirst; i++) {
            MTEday *lasMonthDay = [[MTEday alloc] init];
            int numberDaysPrevMon1 = numberDaysPrevMon -weekDayFirst + i + 1;
            lasMonthDay.day = numberDaysPrevMon1;
            lasMonthDay.month = previousMonth;
            lasMonthDay.year = year;
            lasMonthDay.weekDay = weekDayFirst - weekDay + i;
            [self.days addObject:lasMonthDay];
            
        }
    }
    //Fill the days array with the info of the selected month
    for (int i = 1; i <= numberDays; i++) {
        MTEday *day = [[MTEday alloc] init];
        day.day = i;
        day.month = self.monthShowing;
        day.year = self.yearShowing;
        if (weekDay > 7) {
            weekDay = 1;
        }
        day.weekDay = weekDay;
        weekDay++;
        [self.days addObject:day];
    }
    
    if (([self.days count] % 7 != 0)) {
        int numRows = (int)([self.days count]/7) + 1;
        int j = (7 * numRows)-(int)[self.days count];
        int wd = [[self.days lastObject] weekDay];
        for (int i = 1; i <= j; i ++) {
            wd ++;
            MTEday *d = [[MTEday alloc] init];
            d.day = i;
            int k = self.monthShowing + 1;
            int y = self.yearShowing;
            if (k > 12) {
                k = 1;
                y ++;
            }
            d.month = k;
            d.year = y;
            d.weekDay = wd;
            [self.days addObject:d];
        }
    }
    [self.collectionView reloadData];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        MTEiPadAgendaHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"agendaHeader" forIndexPath:indexPath];
        if (self.monthShowing == 1) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Enero %d",self.yearShowing];
        }else if (self.monthShowing == 2) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Febrero %d",self.yearShowing];
        }else if (self.monthShowing == 3) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Marzo %d",self.yearShowing];
        }else if (self.monthShowing == 4) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Abril %d",self.yearShowing];
        }else if (self.monthShowing == 5) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Mayo %d",self.yearShowing];
        }else if (self.monthShowing == 6) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Junio %d",self.yearShowing];
        }else if (self.monthShowing == 7) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Julio %d",self.yearShowing];
        }else if (self.monthShowing == 8) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Agosto %d",self.yearShowing];
        }else if (self.monthShowing == 9) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Septiembre %d",self.yearShowing];
        }else if (self.monthShowing == 10) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Octubre %d",self.yearShowing];
        }else if (self.monthShowing == 11) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Noviembre %d",self.yearShowing];
        }else if (self.monthShowing == 12) {
            headerView.monthLabel.text = [NSString stringWithFormat:@"Diciembre %d",self.yearShowing];
        }
        headerView.amvc = self;
        reusableview = headerView;
    }
    return  reusableview;
    
}
-(void)cargarCitas
{
    [self.avc disableInteraction];
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    //Get the day of the week of the first day of the month.
    int month = self.monthShowing-1;
    int year = self.yearShowing;
    if (month < 1) {
        year --;
        month = 12;
    }
    if (!self.dataRecieved)
    {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *dateIni;
    if (month < 10)
    {
        dateIni = [NSString stringWithFormat:@"%d0%d23",year,month];
    }
    else
    {
        dateIni = [NSString stringWithFormat:@"%d%d23",year,month];
    }
    
    int monthFin = self.monthShowing+1;
    int yearFin = self.yearShowing;
    if (monthFin > 12) {
        monthFin = 1;
        yearFin++;
    }
    NSString *dateFin;
    if (monthFin < 10)
    {
        dateFin = [NSString stringWithFormat:@"%d0%d06",yearFin,monthFin];
    }
    else{
        dateFin = [NSString stringWithFormat:@"%d%d06",yearFin,monthFin];
    }
    
    NSString *post = [NSString stringWithFormat:@"&idLocacion=%@&dateIni=%@&dateFin=%@",self.consul.idLoc,dateIni,dateFin];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/citas.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.dataRecieved setLength:0];//Set your data to 0 to clear your buffer
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataRecieved appendData:data];//Append the download data..
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Use your downloaded data here
    self.citas = [[NSMutableArray alloc]init];
    NSDictionary *data= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                        options:0
                                                          error:nil];
    for (NSDictionary *cita in [data objectForKey:@"Citas"])
    {
        MTEcita *cit = [[MTEcita alloc] init];
        cit.idCita = cita[@"id"];
        for (MTEpaciente *pac in [[MTEMedicalCenter sharedCenter] pacientes]) {
            if ([cita[@"idPaciente"] isEqualToString:pac.cedula])
            {
                cit.paci = pac;
                break;
            }
        }
        for (MTEEntidad *ent in [[MTEMedicalCenter sharedCenter] entidades])
        {
            if ([cita[@"idEntidad"] isEqualToString:ent.idEnt])
            {
                cit.enti = ent;
                break;
            }
        }
        cit.fechaInicio = cita[@"datetime"];
        cit.fechaFin = cita[@"datetimefin"];
        for (MTEconsultorio *con in [[MTEMedicalCenter sharedCenter] consultorios])
        {
            if ([cita[@"idLocacionXMedico"] isEqualToString:con.idLoc])
            {
                cit.consul = con;
                break;
            }
        }
        for (MTEprocedimiento *proc in [[MTEMedicalCenter sharedCenter] procedimientos])
        {
            if ([cita[@"idTipoProcedimiento"] isEqualToString:proc.idProc])
            {
                cit.proc = proc;
                break;
            }
        }
        cit.desc = cita[@"Motivo"];
        [self.citas addObject:cit];
    }
    [self.avc enableInteraction];
    [self.avc citasChanged];
}
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
