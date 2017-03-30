//
//  MTEPreciosXEntidadCollectionViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/7/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEPreciosXEntidadCollectionViewController.h"
#import "MTEMedicalCenter.h"
#import "MTEPrecioXEntidadCollectionViewCell.h"

@interface MTEPreciosXEntidadCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *entidades;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEPreciosXEntidadCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTEPrecioXEntidadCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"precioEntCell"];
    if (!self.entidades)
    {
        self.entidades = [[NSMutableArray alloc] init];
    }
    NSMutableArray *enti = [MTEMedicalCenter sharedCenter].entidades;
    for (MTEEntidad *en in enti) {
        if (![en.idMedico isEqual:[NSNull null]]) {
            [self.entidades addObject:en];
        }
    }
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Grabar"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(grabar)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    [self.navigationItem setTitle:@"Procedimientos"];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.collectionView setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.precios = [[MTEMedicalCenter sharedCenter] preciosProcedimientos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = self.view.frame.size.width;
    int cellSize = ((width)/2)-8;
    return CGSizeMake(cellSize, 44);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ([self.entidades count] * 2);
}

- (MTEPrecioXEntidadCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTEPrecioXEntidadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"precioEntCell" forIndexPath:indexPath];
    
    if (indexPath.row%2 == 0)
    {
        if (indexPath.row <= self.entidades.count*2)
        {
            NSUInteger row = 0;
            row = indexPath.row/2;
            MTEEntidad *ent = [self.entidades objectAtIndex:row];
            cell.nameText.text = ent.nombre;
            [cell.nameText setEnabled:NO];
        }
        
    }
    else
    {
        for (MTEprecioProcedimiento *prec in self.precios) {
            if ([prec.idProc isEqualToString:self.proc.idProc])
            {
                MTEEntidad *en = [self.entidades objectAtIndex:(indexPath.row-1)/2];
                if ([en.idEnt isEqualToString:prec.idEnt]) {
                    cell.nameText.text=prec.precio;
                }
            }
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",indexPath.row);
}

#pragma mark Grabar

-(void)grabar
{
    NSMutableArray *entJson = [[NSMutableArray alloc] init];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    
    //Json
    for (int i=0;i < [self.entidades count];i++)
    {
        MTEEntidad *ent = [self.entidades objectAtIndex:i];
        NSIndexPath *ind = [NSIndexPath indexPathForItem:((i*2)+1) inSection:0];
        MTEPrecioXEntidadCollectionViewCell *cell = (MTEPrecioXEntidadCollectionViewCell *)[self.collectionView
                                   cellForItemAtIndexPath:ind];
        NSArray *views = [cell.contentView subviews];
        UITextField *priText = [views objectAtIndex:0];
        NSString *price = [priText text];
        NSDictionary *entDic = [NSDictionary dictionaryWithObject:price forKey:ent.idEnt];
        [entJson addObject:entDic];
    }
    
    NSError *error = [[NSError alloc] init];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:entJson
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2
                                                 encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *post = [NSString stringWithFormat:@"&id=%@&id_proc=%@&entJson=%@",self.memberID,self.proc.idProc,jsonString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSString *save = [NSString stringWithFormat:@"%@precioXEntidad.php",[[MTEMedicalCenter sharedCenter] servicesAddres]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", save]]];
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
        [[MTEMedicalCenter sharedCenter] loadPreciosProcedimientosSolo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
