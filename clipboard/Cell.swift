//
//  Cell.swift
//  BilibiliLiveChat
//
//  Created by limit on 2022/5/11.
//

import Cocoa
import SnapKit

class Cell: NSTableCellView {
  public var model: ItemInfo? {
    didSet {
      let date = model?.date.stringValue ?? ""
      let pasted = model?.pasted ?? ""
      label?.stringValue = "\(date) \(pasted)"
    }
  }
  
  private var label: NSTextField?
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    
    label = NSTextField(frame: .zero)
    addSubview(label!)
    label?.isEditable = false
    label?.lineBreakMode = .byTruncatingTail
    label?.font = NSFont.font(ofSize: 20)
    label?.isBordered = false
    label?.backgroundColor = .clear
    label?.snp.makeConstraints({ [weak self] make in
      make.width.equalTo(self!.frame.width)
      make.height.equalTo(self!)
    })
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
