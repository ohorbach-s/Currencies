#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionListViewController.h"

NSString * const backgroundImage = @"wood-wallpaper.png";
NSString * const cellIdentifier = @"SimpleIdentifier";

static NSString *appLauchKey = @"HasLaunchedOnce";
static NSString *mainCurrencyKey = @"mainCurrency";
static NSString *mainSegueIdentifier = @"MainAdd";
static NSString *addSegueIdentifier = @"Add";


@interface MainViewController () {
    unsigned int amountOfSelectedCurrencies;
    int dots;
    NSMutableArray *arrayOfSelectedCurrencies;
    DataBaseManager *dataBaseManager;
    CurrencyInfo *mainCurrencySaved;
    NSMutableArray * outputCurrencies;
}
@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (![DataBaseManager checkApplicationLaunch:appLauchKey]) {
        [DataBaseManager rememberAboutApplicationLaunchWithKey:appLauchKey];
        [DataBaseManager startWorkWithCurrencyRateAplication];
        dataBaseManager = [DataBaseManager sharedManager];
        CurrencyInfo *temp = [dataBaseManager.fetchedArrayOfCurrencyInfo firstObject];
        [self  setTheMainCurrency:temp.abbrev :temp.fullName :temp.icon];
        [dataBaseManager rememberAboutMainCurrency:temp.abbrev withKey:mainCurrencyKey];
    }
    dataBaseManager = [DataBaseManager sharedManager];
    arrayOfSelectedCurrencies = [[NSMutableArray alloc] init];
    outputCurrencies = [[NSMutableArray alloc] init];
    NSString* abbrevMain = [dataBaseManager recallAboutMainCurrencyUsingKey:mainCurrencyKey];
    
    for (CurrencyInfo* temp in dataBaseManager.fetchedArrayOfCurrencyInfo){
        if ([temp.abbrev isEqualToString:abbrevMain]){
            [self  setTheMainCurrency:temp.abbrev :temp.fullName :temp.icon];  }
    }
    self.view.backgroundColor = [UIColor
                                 colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    self.myTableView.backgroundColor = [UIColor clearColor];
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
    self.currencyAmount.clearsOnBeginEditing = YES;
    self.currencyAmount.dots = 0;
    self.shownIndexes = [NSMutableSet set];
    self.currencyAmount.reloadDelegate = self;
    
}
- (void)reloadTable {
    [self.myTableView reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.currencyAmount customButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [AnimationFile animateTableViewAppearance:self.myTableView];
    [arrayOfSelectedCurrencies removeAllObjects];
    for (CurrencyInfo* inf in dataBaseManager.fetchedArrayOfCurrencyInfo) {
        if (inf.checked) {
            [arrayOfSelectedCurrencies addObject:inf];
        }
    }
    [outputCurrencies removeAllObjects];
    for (CurrencyInfo* inf in arrayOfSelectedCurrencies) {
        if (![inf.abbrev isEqualToString:self.mainName.text]) {
            [outputCurrencies addObject:inf];
        }
    }
    [self.myTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    UINavigationController* navigationController = segue.destinationViewController;
    SelectionListViewController* controller =
    [[navigationController viewControllers] firstObject];
    controller.delegate = self;
    if ([segue.identifier isEqualToString:mainSegueIdentifier]) {
        controller.selectedMainSegue = YES;
    } else if([segue.identifier isEqualToString:addSegueIdentifier]){
        controller.selectedCurrency = self.mainName.text;
    }
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [outputCurrencies count];
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
        CurrencyInfo* tempCurrency =
    [outputCurrencies objectAtIndex:indexPath.row];
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.nameLabel.text = tempCurrency.abbrev;
    cell.fullNameLabel.text = tempCurrency.fullName;
    cell.flagImageView.image = [UIImage imageNamed:tempCurrency.icon];
    RateHistory* tempCurrencyRate =
    [dataBaseManager.fetchedRateHistory firstObject];
    CurrencyCalculation* calculation = [CurrencyCalculation new];
    double resultRate = [calculation
                         convertNumber:[self.currencyAmount.text doubleValue]
                         OfCurrency:[tempCurrencyRate
                                     valueForKey:[self.mainName.text lowercaseString]]
                         into:[tempCurrencyRate
                               valueForKey:[tempCurrency.abbrev
                                            lowercaseString]]];
    cell.sumLabel.text = [NSString stringWithFormat:@"%.2f", resultRate];
    return cell;
}

// change the currency to be converted into the target ones
- (void)setMainCurrency:(CurrencyInfo*)selectedMain {
    [self setTheMainCurrency:selectedMain.abbrev :selectedMain.fullName :selectedMain.icon];
    [dataBaseManager rememberAboutMainCurrency:selectedMain.abbrev withKey:mainCurrencyKey];
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
        CurrencyInfo *exemplair = [outputCurrencies objectAtIndex:indexPath.row];
        exemplair.checked = nil;
        for (CurrencyInfo *inf in dataBaseManager.fetchedArrayOfCurrencyInfo){
            if ([inf.abbrev isEqualToString:exemplair.abbrev]) {
                [arrayOfSelectedCurrencies removeObject:inf];
            }
        }
        [outputCurrencies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void) setTheMainCurrency:(NSString*)mainName :(NSString*)fullName
                          :(NSString*)image {
    self.mainName.text = mainName;
    self.mainFullName.text = fullName;
    self.mainImage.image = [UIImage imageNamed:image];
}
@end
