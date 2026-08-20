import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()

    let defaultWidth: CGFloat = 480
    let defaultHeight: CGFloat = 798

    self.contentViewController = flutterViewController

    // Set the initial window size.
    var windowFrame = self.frame
    windowFrame.size = NSSize(
      width: defaultWidth,
      height: defaultHeight
    )

    self.setFrame(
      windowFrame,
      display: true,
      animate: false
    )

    // Prevent macOS from restoring an old window frame.
    self.isRestorable = false

    RegisterGeneratedPlugins(
      registry: flutterViewController
    )

    super.awakeFromNib()
  }
}