//
//  ViewController.swift
//  clipboard
//
//  Created by limit on 2022/9/27.
//

import Cocoa
import SnapKit

fileprivate let kColumnIdentifier = "kColumnIdentifier"

class ViewController: NSViewController {
  private lazy var column: NSTableColumn = {
    return NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: kColumnIdentifier))
  }()
  
  private lazy var tableView: NSTableView = { [weak self] in
    let willSetup = NSTableView(frame: .zero)
    willSetup.dataSource = self
    willSetup.delegate = self
    willSetup.backgroundColor = .white
    willSetup.alphaValue = 0.8
    willSetup.headerView = nil
    willSetup.rowSizeStyle = .custom
    willSetup.addTableColumn(column)
    willSetup.autoresizesSubviews = true
    return willSetup
  }()
  
  private lazy var scrollView: NSScrollView = { [weak self] in
    let willSetup = NSScrollView(frame: .zero)
    willSetup.hasVerticalScroller = true
    willSetup.scrollerStyle = .overlay
    willSetup.verticalScrollElasticity = .none
    willSetup.backgroundColor = .clear
    willSetup.contentView.documentView = tableView
    return willSetup
  }()
  
  private var dataSource: [ItemInfo] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
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
      tableView.reloadData()
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension ViewController {
  private func setupView() {
    view.frame.size.width = 290
    view.wantsLayer = true
    view.layer?.cornerRadius = 10.0
    view.alphaValue = 0.8
    view.layer?.backgroundColor = .white
  }
  
  private func setupTableView() {
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { [weak self] make in
      make.width.equalTo(self!.view)
      make.top.equalTo(self!.view)
      make.bottom.equalTo(self!.view)
    }
  }
}

extension ViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let identifier = tableColumn?.identifier
    let v: Cell = tableView.makeView(withIdentifier: identifier!, owner: column) as? Cell ?? Cell(frame: CGRect(x: 0, y: 0, width: column.width, height: CGFloat.greatestFiniteMagnitude))
    v.model = dataSource[row]
    return v
  }
  
  func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
    return Row()
  }
}

extension ViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
    if let row = proposedSelectionIndexes.first {
      let pasteboard = Clipboard.shared.pasteboard
      let removed = dataSource.remove(at: row)
      pasteboard.declareTypes([.string], owner: nil)
      pasteboard.setString(removed.pasted, forType: .string)
    }
    return proposedSelectionIndexes
  }
}
