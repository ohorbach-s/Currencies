#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionListViewController.h"
@interface MainViewController () {
    unsigned int amountOfSelectedCurrencies;
    int dots;
    NSMutableArray *arrayOfSelectedCurrencies;
    DataBaseManager *dataBaseManager;
    CurrencyInfo *mainCurrencySaved;
}
@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *appLauchKey = @"HasLaunchedOnce";
    NSString *mainCurrencyKey = @"mainCurrency";
    NSString *backgroundImage = @"wood-wallpaper.png";
    NSString *notificationName = @"ReloadTableDataNotification";
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:appLauchKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:appLauchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [DataBaseManager startWorkWithCurrencyRateAplication];
        [CurrencyInfo  setTheMainCurrency:@"UAH" : @"Ukrainian Hryvnia":@"UAH.png" :self];
    }
    arrayOfSelectedCurrencies = [[NSMutableArray alloc] init];
    dataBaseManager = [DataBaseManager sharedManager];
    NSString* abbrevMain =
    [[NSUserDefaults standardUserDefaults] valueForKey:mainCurrencyKey];
    for (CurrencyInfo* temp in dataBaseManager.fetchedArrayOfCurrencyInfo){
        if ([temp.abbrev isEqualToString:abbrevMain]){
            [CurrencyInfo  setTheMainCurrency:temp.abbrev :temp.fullName
                                                :temp.icon :self];  }
    }
    self.view.backgroundColor = [UIColor
                                 colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    _myTableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes =
    @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    self.currencyAmount.text = @"1";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTheMainTableView)
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
                                                 name:notificationName
                                               object:nil];
}
- (void)reloadTable:(NSNotification *)notif {
    [self.myTableView reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_currencyAmount customButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [AnimationFile animateTableViewAppearance:self.myTableView];
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
    NSString *segueIdentifier = @"MainAdd";
    UINavigationController* navigationController = segue.destinationViewController;
    SelectionListViewController* controller =
    [[navigationController viewControllers] firstObject];
    controller.delegate = self;
    if ([segue.identifier isEqualToString:segueIdentifier]) {
        controller.selectedMainSegue = YES;
    } else {
        controller.selectedCurrency = self.mainName.text;
    }
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [arrayOfSelectedCurrencies count];
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString *cellIdentifier = @"SimpleIdentifier";
    CurrencyInfo* tempCurrency =
    [arrayOfSelectedCurrencies objectAtIndex:indexPath.row];
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
// change the currency to be converted into the target ones
- (void)setMainCurrency:(CurrencyInfo*)SelectedMain {
    if (_mainSaved) {
        _mainSaved2 = _mainSaved;
    } else {
        for (CurrencyInfo* temp in dataBaseManager.fetchedArrayOfCurrencyInfo) {
            if ([temp.abbrev isEqualToString:@"UAH"]){
                temp.checked = @1;
                _mainSaved2 = temp;
            }else {
                if ([temp.abbrev isEqualToString:_mainName.text]){
                    temp.checked = @1;
                }
            }
        }
    }
    CurrencyInfo* exemplair = SelectedMain;
    for (CurrencyInfo* temp in dataBaseManager.fetchedArrayOfCurrencyInfo) {
        if (temp.abbrev == _mainSaved2.abbrev) {
            if (temp.checked != [NSNumber numberWithInt:1]) {
                temp.checked = @1;
                [arrayOfSelectedCurrencies addObject:temp];
            }
        }
    }
    [CurrencyInfo setTheMainCurrency:exemplair.abbrev :exemplair.fullName
                                       :exemplair.icon :self];
    _mainSaved = exemplair;
    for (CurrencyInfo* temp in dataBaseManager.fetchedArrayOfCurrencyInfo) {
        if (temp.abbrev == _mainSaved.abbrev) {
            if (temp.abbrev == exemplair.abbrev) {
                temp.checked = nil;
                [arrayOfSelectedCurrencies removeObject:temp];
            }
        }
    }
    NSString *mainCurrencyKey = @"mainCurrency";
    [[NSUserDefaults standardUserDefaults] setValue:exemplair.abbrev
                                             forKey:mainCurrencyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view addSubview:self.mainImage];                                       //add animation for main currency
    [AnimationFile addFallAnimationForLayer:self.mainImage.layer];
    [self.view addSubview:self.mainFullName];
    [AnimationFile addFallAnimationForLayer:self.mainFullName.layer];
}
- (void)refreshTheMainTableView {
    [ManualRefresh refreshTableViewWithCompletionHandler:^(BOOL success) {
        if (success){
            [self.refreshControl endRefreshing];
        }
        [self.myTableView reloadData];
    }];
}
- (void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CurrencyInfo *exemplair = [arrayOfSelectedCurrencies objectAtIndex:indexPath.row];
        exemplair.checked = nil;
        [arrayOfSelectedCurrencies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }
}
@end
