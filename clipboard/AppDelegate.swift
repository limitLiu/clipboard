//
//  AppDelegate.swift
//  clipboard
//
//  Created by limit on 2022/9/27.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let popMenu = NSPopover()
  private var monitor: Any?
  private let clipboard = Clipboard.shared
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
      button.action = #selector(toggle(_:))
    }
    constructMenu()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  private func constructMenu() {
    clipboard.start()
    let vc = ViewController.viewController()
    popMenu.contentViewController = vc
    NotificationCenter.default.addObserver(vc, selector: #selector(vc.onPasteboardChange), name: .PasteboardDidChange, object: nil)
  }
  
  @objc func toggle(_ sender: NSStatusBarButton) {
    if popMenu.isShown {
      popMenu.performClose(sender)
      if let monitor = monitor {
        NSEvent.removeMonitor(monitor)
      }
      monitor = nil
    } else {
      monitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown], handler: { [weak self] event in
        if let this = self, this.popMenu.isShown {
          this.popMenu.performClose(event)
        }
      })
      if let btn = statusItem.button {
        popMenu.show(relativeTo: btn.bounds, of: btn, preferredEdge: .minY)
      }
    }
  }
  
}

