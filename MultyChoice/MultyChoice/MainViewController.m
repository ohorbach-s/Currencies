//
//  RTViewController.m
//  MultyChoice
//
//  Created by Andriy on 9/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionListViewController.h"
@interface MainViewController () {
    unsigned int amountOfSelectedCurrencies;
    //double quantity;
    int dots;
    NSMutableArray* arrayOfSelectedCurrencies;
    DataBaseManager* dataBaseManager;
    
    
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults]
         setBool:YES
         forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [DataBaseManager startWorkWithCurrencyRateAplication];
        [CurrencyInfo  initTheMainCurrency:@"UAH" : @"Ukrainian Hryvnia":@"UAH.png"];
    }
    arrayOfSelectedCurrencies = [[NSMutableArray alloc] init];
    dataBaseManager = [DataBaseManager sharedManager];
    NSInteger indexMain =
    [[NSUserDefaults standardUserDefaults] integerForKey:@"mainCurrency"];
    CurrencyInfo* mainCurrencySaved = [dataBaseManager.fetchedArrayOfCurrencyInfo
                                       objectAtIndex:indexMain];                   // getting saved main currency from array
    [CurrencyInfo  initTheMainCurrency:mainCurrencySaved.abbrev : mainCurrencySaved.fullName:mainCurrencySaved.icon];
    self.view.backgroundColor = [UIColor
                                 colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
    _myTableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes =
    @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    self.currencyAmount.text = @"1";                         // the initial amount of currency-to-convert
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTheMainTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];               // Initialize the refresh control.
    self.currencyAmount.delegate = self;
    [self.currencyAmount addTarget:self.currencyAmount
                            action:@selector(checkTyping)
                  forControlEvents:UIControlEventEditingChanged];
    _currencyAmount.clearsOnBeginEditing = YES;
    _currencyAmount.dots = 0;
    _shownIndexes = [NSMutableSet set];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable:)
                                                 name:@"ReloadTableDataNotification"
                                               object:nil];
}

- (void)reloadTable:(NSNotification *)notif {
    [self.myTableView reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_currencyAmount customButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [arrayOfSelectedCurrencies removeAllObjects];
    for (CurrencyInfo* inf in dataBaseManager.fetchedArrayOfCurrencyInfo) {
        if (inf.checked) {
            [arrayOfSelectedCurrencies addObject:inf];
        }
    }
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    UINavigationController* navigationController = segue.destinationViewController;
    SelectionListViewController* controller =
    [[navigationController viewControllers] firstObject];
    controller.delegate = self;
    if ([segue.identifier isEqualToString:@"MainAdd"]) {
        controller.selectedMainSegue = YES;
    } else {
        controller.selectedCurrency = self.mainName.text;
    }
}

#pragma mark - UITableViewDataSource:

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    // number of selected elements in the second table
    return [arrayOfSelectedCurrencies count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString* SimpleIdentifier = @"SimpleIdentifier";
    CurrencyInfo* tempCurrency =
    [arrayOfSelectedCurrencies objectAtIndex:indexPath.row];
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    cell.nameLabel.text = tempCurrency.abbrev;
    cell.fullNameLabel.text = tempCurrency.fullName;
    cell.flagImageView.image = [UIImage imageNamed:tempCurrency.icon];
    RateHistory* tempCurrencyRate =
    [dataBaseManager.fetchedRateHistory firstObject];
    CurrencyCalculation* calculation = [CurrencyCalculation new];
    
    double resultRate = [calculation
                         convertNumber:[_currencyAmount.text doubleValue]
                         OfCurrency:[tempCurrencyRate
                                     valueForKey:[self.mainName.text lowercaseString]]
                         into:[tempCurrencyRate
                               valueForKey:[tempCurrency.abbrev
                                            lowercaseString]]];
    cell.sumLabel.text = [NSString stringWithFormat:@"%.2f", resultRate];
    return cell;
}

#pragma mark - AddCurrencyDelegate:
// change the currency to be converted into the target ones
- (void)setMainCurrency:(unsigned int)indexTableRow {
    if (_mainSaved) {
        _mainSaved2 = _mainSaved;
    }
    
    CurrencyInfo* exemplair =
    [dataBaseManager.fetchedArrayOfCurrencyInfo objectAtIndex:indexTableRow];
    for (CurrencyInfo* temp in dataBaseManager.fetchedArrayOfCurrencyInfo) {
        if (temp.abbrev == _mainSaved2.abbrev) {
            if (temp.checked != [NSNumber numberWithInt:1]) {
                temp.checked = @1;
                [arrayOfSelectedCurrencies addObject:temp];
            }
        }
        if (temp.abbrev == exemplair.abbrev) {
            temp.checked = nil;
        }
    }
    [CurrencyInfo initTheMainCurrency:exemplair.abbrev :exemplair.fullName :exemplair.icon];
    _mainSaved = exemplair;
    UILabel* label = self.mainName;
    [AnimationFile shakeAnimation:label];
    [[NSUserDefaults standardUserDefaults] setInteger:indexTableRow
                                               forKey:@"mainCurrency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refreshTheMainTableView {
    [ManualRefresh refreshTableViewWithCompletionHandler:^(BOOL success) {
        if (success)
            [self.refreshControl endRefreshing];
        [self.myTableView reloadData];
    }];
    [UIView transitionWithView: self.myTableView
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void) {
         [self.myTableView reloadData];
     }
                    completion: ^(BOOL isFinished){
     }];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell
                 :(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
        cell.layer.transform = self.initialTransformation;
        [AnimationFile cellAnimation:cell];
    }
}

- (void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CurrencyInfo *exemplair =
        [arrayOfSelectedCurrencies objectAtIndex:indexPath.row];
        exemplair.checked = nil;
        [arrayOfSelectedCurrencies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }
}


@end
