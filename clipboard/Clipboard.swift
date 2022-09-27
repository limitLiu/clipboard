//
//  Clipboard.swift
//  clipboard
//
//  Created by limit on 2022/9/27.
//

import AppKit

class Clipboard {
  static let shared = Clipboard()
  public let pasteboard = NSPasteboard.general
  private var timer: Timer?
  private var changeCount = 0
  private init() {}
  
  public func start() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { t in
      if self.changeCount != self.pasteboard.changeCount {
        self.changeCount = self.pasteboard.changeCount
        NotificationCenter.default.post(name: .PasteboardDidChange, object: self.pasteboard)
      }
    }
  }
  
  deinit {
    timer?.invalidate()
  }
}

extension NSNotification.Name {
  static let PasteboardDidChange: NSNotification.Name = .init("pasteboardDidChangeNotification")
}
