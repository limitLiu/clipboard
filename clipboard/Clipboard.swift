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
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {[weak self] t in
      if let this = self {
        if this.changeCount != this.pasteboard.changeCount {
          this.changeCount = this.pasteboard.changeCount
          NotificationCenter.default.post(name: .PasteboardDidChange, object: this.pasteboard)
        }
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
