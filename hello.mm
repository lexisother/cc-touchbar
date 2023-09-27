#include <Cocoa/Cocoa.h>
#include <node.h>

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

namespace cctouchbar {

using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::Object;
using v8::String;
using v8::Value;

CCTouchBarDelegate *g_TouchBarDelegate = NULL;
void SetTouchbar(const FunctionCallbackInfo<Value> &args) {
  if (!g_TouchBarDelegate) {
    g_TouchBarDelegate = [[CCTouchBarDelegate alloc] init];
    [NSApplication sharedApplication]
        .automaticCustomizeTouchBarMenuItemEnabled = YES;
  }

  // Get our touch bar instance
  NSTouchBar *touchBar = [g_TouchBarDelegate makeTouchBar];

  // Get the windows associated with this process, which should only be one at
  // the time of running
  NSArray<NSWindow *> *windows = [NSApplication sharedApplication].windows;
  for (int i = 0; i < windows.count; ++i) {
    NSWindow *wnd = windows[i];

    NSLog(@"before loop title %d log", i);
    NSLog(@"loop title %d: %@", i, wnd.title);
    NSLog(@"after loop title %d log", i);

    [wnd setTouchBar:touchBar];
  }
}

void Method(const FunctionCallbackInfo<Value> &args) {
  Isolate *isolate = args.GetIsolate();

  NSLog(@"fucking fuck");

  args.GetReturnValue().Set(
      String::NewFromUtf8(isolate, "world").ToLocalChecked());
}

void Initialize(Local<Object> exports) {
  NODE_SET_METHOD(exports, "hello", Method);
  NODE_SET_METHOD(exports, "setTouchbar", SetTouchbar);
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)

} // namespace cctouchbar