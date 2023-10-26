//
//  ViewController.swift
//  clipboard
//
//  Created by limit on 2022/9/27.
//

import Cocoa
import SwiftUI

class DataModel: ObservableObject {
    @Published var data: [ItemInfo]?
}

class ViewController: NSViewController {
    private var hostingController: NSHostingController<ContentView>?

    private var dataSource: [ItemInfo] = []
    
    var dataModel = DataModel()
    
    override func loadView() {
        hostingController = NSHostingController(rootView: ContentView(model: dataModel))
        if let host = hostingController {
            view = host.view
        }
    }
    
    override var representedObject: Any? {
        didSet {}
    }
    
    static func viewController() -> ViewController {
        let sb = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let ident = NSStoryboard.SceneIdentifier("PopMenu")
        guard let vc = sb.instantiateController(withIdentifier: ident) as? ViewController else {
            fatalError("Failed to instantiateController with ident")
        }
        return vc
    }
    
    @objc func onPasteboardChange(_ notification: Notification) {
        if let pasteboard = notification.object as? NSPasteboard, let items = pasteboard.pasteboardItems, let item = items.first?.string(forType: .string) {
            dataSource.append(.init(date: .now, pasted: item))
            if dataSource.count > 10 {
                dataSource = Array(dataSource.prefix(through: 10))
            }
            dataModel.data = dataSource
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
