//
//  MTEiPadEntidadesTableViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEiPadEntidadesTableViewController.h"
#import "MTEiPadEntidadTableViewCell.h"
#import "MTEEntidad.h"
#import "MTEMedicalCenter.h"

@interface MTEiPadEntidadesTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEiPadEntidadesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entidades = [[MTEMedicalCenter sharedCenter] entidades];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(29,0,0,0);
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                         target:self
                                                                         action:@selector(grabar)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [self.navigationItem setTitle:@"Entidades"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entidades count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"entidadCell";
    MTEiPadEntidadTableViewCell *cell = (MTEiPadEntidadTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTEiPadEntidadTableViewCell"
                                                                 owner:self
                                                               options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (MTEiPadEntidadTableViewCell *) currentObject;
                break;
            }
        }
    }
    MTEEntidad *ent = [self.entidades objectAtIndex:indexPath.row];
    UIButton *check = (UIButton *)[cell viewWithTag:100];
    UILabel *name = (UILabel *)[cell viewWithTag:200];
    if (ent.check) {
        [check setImage:[UIImage imageNamed:@"CheckBox_Ok.png"] forState:UIControlStateNormal];
    }else{
        [check setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    name.text = ent.nombre;
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTEEntidad *ent = (MTEEntidad *)[self.entidades objectAtIndex:indexPath.row];
    [[self.entidades objectAtIndex:indexPath.row]setCheck:!ent.check];
    [self.tableView reloadData];
    
}

#pragma mark - Send data

- (void)grabar
{
    NSMutableArray *entJson = [[NSMutableArray alloc] init];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    
    //Json
    for (int i=0;i < [self.entidades count];i++)
    {
        MTEEntidad *ent = [self.entidades objectAtIndex:i];
        NSDictionary *entDic = [NSDictionary dictionaryWithObject:ent.idEnt forKey:@"idEnt"];
        if (ent.check)
        {
            [entJson addObject:entDic];
        }
        
    }
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:entJson
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2
                                                 encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&entJson=%@",self.memberID,jsonString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    //NSString *someString = [[NSString alloc] initWithData:postData encoding:NSASCIIStringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/medicos_test/services/ws_version/entidadMedico.php"]]];
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
    NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
    if ([dat isEqualToString:@"OK"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.navigationItem.leftBarButtonItem.enabled = YES;
}
@end
