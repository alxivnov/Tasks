//
//  TaskPageController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 17.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ABHelper.h"
#import "ABPersonViewController+Convenience.h"
#import "Constants.h"
#import "DelegateController.h"
#import "DelegateAccessController.h"
#import "NSHelper.h"
#import "CalendarController.h"
#import "Localization.h"
#import "Palette.h"
#import "PostponeController.h"
#import "ScheduleController.h"
#import "UIHelper.h"
#import "UIPageViewController+Convenience.h"
#import "UIScrollView+Scroll.h"
#import "UIView+Hierarchy.h"
#import "UIViewController+Hierarchy.h"

@interface CalendarController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL repeat;
@property (strong, nonatomic) NSString *sound;
@property (assign, nonatomic) NSTimeInterval alert;
@property (assign, nonatomic) NSInteger person;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) PostponeController *postponeVC;
@property (strong, nonatomic) ScheduleController *scheduleVC;
@property (strong, nonatomic, readonly) DelegateController *delegateVC;
@property (strong, nonatomic, readonly) ABPersonViewController *personVC;
@property (strong, nonatomic, readonly) DelegateAccessController *accessVC;

@property (strong, nonatomic) UIBarButtonItem *doneItem;
@property (strong, nonatomic) UIBarButtonItem *editItem;
@end

@implementation CalendarController

@synthesize popoverDelegate = _popoverDelegate;

- (UIBarButtonItem *)doneItem {
	if (!_doneItem)
		_doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTap:)];
	
	return _doneItem;
}

- (UIBarButtonItem *)editItem {
	if (!_editItem)
		_editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTap:)];
	
	return _editItem;
}

- (PostponeController *)postponeVC {
	if (!_postponeVC) {
		_postponeVC = [[UIHelper mainStoryboard] instantiateViewControllerWithIdentifier:GUI_POSTPONE];
		
		__weak CalendarController *__self = self;
		_postponeVC.completion = ^(PostponeController *sender, BOOL success) {
			[__self dismiss:success ? sender : Nil];
		};
	}
	
	return _postponeVC;
}

- (ScheduleController *)scheduleVC {
	if (!_scheduleVC) {
		_scheduleVC = [[UIHelper mainStoryboard] instantiateViewControllerWithIdentifier:GUI_SCHEDULE];
		
		__weak CalendarController *__self = self;
		_scheduleVC.completion = ^(ScheduleController *sender, BOOL success) {
			[__self dismiss:success ? sender : Nil];
		};
		
		[ScheduleController setDate:self.date repeat:self.repeat sound:self.sound alert:self.alert forViewController:_scheduleVC];
	}
	
	return _scheduleVC;
}

- (UIViewController *)delegateVC {
	DelegateController *delegate = [[DelegateController alloc] init];
	
	__weak CalendarController *__self = self;
	delegate.completion = ^(DelegateController *sender, BOOL success) {
		[__self dismiss:success ? sender : Nil];
	};
	
	return delegate;
}

- (ABPersonViewController *)personVC {
	ABPersonViewController *person = [[ABPersonViewController alloc] initWithPersonName:self.name orPersonID:self.person];
	person.allowsEditing = NO;
	
	UIScrollView *scrollView = (UIScrollView *)[person.view subview:^BOOL(UIView *subview) {
		return [subview isKindOfClass:[UIScrollView class]];
	}];
	[scrollView setContentInsetTop:scrollView.contentInset.top + self.navigationController.navigationBar.frame.size.height + [UIHelper statusBarHeight]];
	
	return person;
}

- (DelegateAccessController *)accessVC {
	DelegateAccessController *access = [[UIHelper mainStoryboard] instantiateViewControllerWithIdentifier:GUI_ACCESS];
	
	__weak CalendarController *__self = self;
	access.completion = ^(DelegateAccessController *sender, BOOL success) {
		[__self setViewController:__self.delegateVC direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:Nil];
	};
	
	return access;
}

- (UIViewController *)vc:(NSUInteger)index {
	return index == 0 ? self.postponeVC : index == 1 ? self.scheduleVC : index == 2 ? [ABHelper isAuthorized] ? self.person || self.name.length ? self.personVC : self.delegateVC : self.accessVC : Nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.dataSource = self;
	self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.segmentControl.selectedSegmentIndex = self.index;
	[self segmentValueChanged:self.segmentControl];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
	
	self.postponeVC = Nil;
	self.scheduleVC = Nil;
//	self.delegateVC = Nil;
//	self.personVC = Nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	return [self vc:self.segmentControl.selectedSegmentIndex + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	return [self vc:self.segmentControl.selectedSegmentIndex - 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
	if (!finished || !completed)
		return;
	
	id vc = pageViewController.viewControllers.firstObject;
	if ([vc isKindOfClass:[PostponeController class]]) {
		self.navigationController.navigationBar.tintColor = [Palette yellow];
		self.view.tintColor = [Palette yellow];
		
		self.navigationItem.rightBarButtonItem = Nil;
		self.segmentControl.selectedSegmentIndex = 0;
	} else if ([vc isKindOfClass:[ScheduleController class]]) {
		self.navigationController.navigationBar.tintColor = [Palette red];
		self.view.tintColor = [Palette red];
		
		self.navigationItem.rightBarButtonItem = self.doneItem;
		self.segmentControl.selectedSegmentIndex = 1;
	} else {
		self.navigationController.navigationBar.tintColor = [Palette blue];
		self.view.tintColor = [Palette blue];
		
		self.navigationItem.rightBarButtonItem = [vc isKindOfClass:[ABPersonViewController class]] ? self.editItem : Nil;
		self.segmentControl.selectedSegmentIndex = 2;
	}
	
	self.index = self.segmentControl.selectedSegmentIndex;
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
	UIViewController *vc = [self vc:sender.selectedSegmentIndex];
	
	UIPageViewControllerNavigationDirection direction = ([vc isKindOfClass:[DelegateController class]] || [vc isKindOfClass:[ABPersonViewController class]] || [vc isKindOfClass:[DelegateAccessController class]]) || ([vc isKindOfClass:[ScheduleController class]] && [self.viewControllers.firstObject isKindOfClass:[PostponeController class]]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
	
	[self setViewController:vc direction:direction animated:YES completion:Nil];
	
	[self pageViewController:self didFinishAnimating:YES previousViewControllers:self.viewControllers transitionCompleted:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dismiss:(UIViewController *)controller {
	if ([self.popoverDelegate respondsToSelector:@selector(shouldDismissPopover:)])
		[self.popoverDelegate shouldDismissPopover:controller];
	else
		[self performSegueWithIdentifier:controller ? GUI_SELECT : GUI_CANCEL sender:self];
}

- (IBAction)doneButtonTap:(UIBarButtonItem *)sender {
	[self dismiss:[self vc:self.segmentControl.selectedSegmentIndex]];
}

- (IBAction)cancelButtonTap:(UIBarButtonItem *)sender {
	[self dismiss:Nil];
}

- (IBAction)editButtonTap:(UIBarButtonItem *)sender {
	[self setViewController:self.delegateVC direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:Nil];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self dismiss:Nil];
}

+ (void)setDate:(NSDate *)date repeat:(BOOL)repeat sound:(NSString *)sound alert:(NSTimeInterval)alert person:(NSInteger)person name:(NSString *)name index:(NSUInteger)index forViewController:(UIViewController *)controller {
	CalendarController *vc = [self viewController:controller];
	
	vc.index = index;
	vc.date = date;
	vc.repeat = repeat;
	vc.sound = sound;
	vc.alert = alert;
	vc.person = person;
	vc.name = name;
}

@end
