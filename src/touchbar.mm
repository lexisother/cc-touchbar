#include <Cocoa/Cocoa.h>

static NSString *touchBarCustomizationId = @"dev.alyxia.cctouchbarcus";
static NSString *touchBarItemId = @"dev.alyxia.cctouchbar";

@interface CCTouchBarDelegate : NSObject <NSTouchBarDelegate>
- (NSTouchBar *)makeTouchBar;
- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier;
- (void)cclButtonAction:(id)sender;
@end

@implementation CCTouchBarDelegate
- (NSTouchBar *)makeTouchBar {
  // Create TouchBar object
  NSTouchBar *touchBar = [[NSTouchBar alloc] init];
  touchBar.delegate = self;
  touchBar.customizationIdentifier = touchBarCustomizationId;

  // Set the default ordering of items.
  touchBar.defaultItemIdentifiers =
      @[ touchBarItemId, NSTouchBarItemIdentifierOtherItemsProxy ];
  touchBar.customizationAllowedItemIdentifiers = @[ touchBarItemId ];
  touchBar.principalItemIdentifier = touchBarItemId;

  return touchBar;
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
  if ([identifier isEqualToString:touchBarItemId]) {
    NSButton *button =
        [NSButton buttonWithTitle:NSLocalizedString(@"CCLoader3 rules!", @"")
                           target:self
                           action:@selector(cclButtonAction:)];

    NSCustomTouchBarItem *g_TouchBarItem =
        [[NSCustomTouchBarItem alloc] initWithIdentifier:touchBarItemId];
    g_TouchBarItem.view = button;
    g_TouchBarItem.customizationLabel = NSLocalizedString(@"Huh", @"");

    return g_TouchBarItem;
  }

  return nil;
}

- (void)cclButtonAction:(id)sender {
  NSLog(@"It sure does.");
}
@end
