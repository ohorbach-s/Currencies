//
//  RTViewController.m
//  MultyChoice
//
//  Created by Andriy on 9/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RTViewController.h"


@interface RTViewController ()
{
    unsigned int rtAmount;
    Starter *createDB;
}

@end


@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
    _myTableView.backgroundColor = [UIColor clearColor];
    self.converter = [ParcingYahoo new];
    self.howMuch.text = @"1";                 //the initial amount of currency-to-convert
    
    createDB = [[Starter alloc]initStarter];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){           //if the app has been already launched
        
        NSLog(@"DB isn't empty!");
        
        RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error;
        NSFetchRequest *req = [NSFetchRequest new];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo"
                                                      inManagedObjectContext:context];
        [req setEntity:entityDesc];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(checked == %@)", @1];           //set the predicate to get only those items which are selected with checkmarks
        [req setPredicate:pred];                                                                 //implementing the above mentioned request

        
        NSArray *fetched = [context executeFetchRequest:req error:&error];
        rtAmount = [fetched count];                                                                //count the number of mached elements (selected)
   } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];              // OTHERWISE - if the app is launched for the first time
        [[NSUserDefaults standardUserDefaults] synchronize];
        [createDB firstLoad];
       
        NSLog(@"DB is filled");
         }
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    SelectionListViewController *controller = [[navigationController viewControllers] firstObject];
    controller.delegate = self;
   
    if ([segue.identifier isEqualToString:@"MainAdd"]){                                        // if the main currency is to be changed  (otherwise - the "+" button is pressed)
        
        controller.selectedMainSegue = YES;
	}
  }


#pragma mark - UITableViewDataSource:

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger) section {
    
    return rtAmount;                                                    //number of selected elements in the second table
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *req = [NSFetchRequest new];    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(checked == %@)", @1];          //get only those elements wich are selected
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo" inManagedObjectContext:context];
    
    [req setEntity:entityDesc];
    [req setPredicate:pred];
    
    NSArray *fetched = [context executeFetchRequest:req error:&error];
    CurrencyInfo *exemplair = fetched [indexPath.row];
    RTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleIdentifier];        //fill the tableView with data of selected currencies

    cell.nameLabel.text = exemplair.abbrev;
    cell.fullNameLabel.text = exemplair.fullName;
    cell.flagImageView.image = [UIImage imageNamed:exemplair.icon];
    
    NSFetchRequest *mainReq = [NSFetchRequest new];
    NSEntityDescription *mainRate = [NSEntityDescription entityForName:@"RateHistory"
                                                inManagedObjectContext:context];
    [mainReq setEntity:mainRate];
    
    NSArray *mainFetched = [context executeFetchRequest:mainReq error:&error];
    RateHistory *mainCurrency = [mainFetched lastObject];
    CurrencyCalculation * calculation = [CurrencyCalculation new];
    createDB = [[Starter alloc]initStarter];
    
    double resultRate = [ calculation convertNumber:self.howMuch.text
                                         OfCurrency:[mainCurrency
                                        valueForKey:[self.mainName.text lowercaseString]]
                                               into:[mainCurrency
                                                     valueForKey:[exemplair.abbrev lowercaseString]]];     //implement the calculation of enetered amount of the first currency into the target currencies
    
    cell.sumLabel.text = [NSString stringWithFormat: @"%.4f", resultRate];                                 //output the result of converter

        
       return cell;
}


#pragma mark - AddCurrencyDelegate:

- (void) setMainCurrency:(unsigned int) indexTableRow                                                      //change the currency to be converted into the target ones
{
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *req = [NSFetchRequest new];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CurrencyInfo" inManagedObjectContext:context];
    
    [req setEntity:entityDesc];
    
    NSArray *fetched = [context executeFetchRequest:req error:&error];
    
    unsigned index = indexTableRow;                                                                         //detecting the row of selected item to become the main currency
    
    CurrencyInfo *exemplair = fetched[index];
    
    self.mainName.text = exemplair.abbrev;                                                                  //output the changed data
    self.mainFullName.text = exemplair.fullName;
    self.mainImage.image = [UIImage imageNamed:exemplair.icon];
    
    [context save:&error];
 }


- (void) setSelectedCurrency: (unsigned int)amount                                                           //pass the number of selected items from the second view
{
    rtAmount = amount;
}


- (IBAction)endEditing:(id)sender                                                                            // hiding the keyboard
{
   [sender resignFirstResponder];
   [self.myTableView reloadData];
}


- (IBAction)refreshTableView:(id)sender                                                                 //downloading fresh data on exchange rate from yahoo and loading it to DB
{
   
    ParcingYahoo * megaParser = [ParcingYahoo new];
    [megaParser refreshData];
     NSLog(@"End parSing!!!");
}



@end
