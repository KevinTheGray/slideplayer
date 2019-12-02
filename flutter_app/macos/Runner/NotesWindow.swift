//
//  NotesWindow.swift
//  Runner
//
//  Created by Kevin Gray on 10/22/19.
//  Copyright © 2019 Google LLC. All rights reserved.
//

import Foundation
import Cocoa
import MarkdownKit

class NotesWindow: NSWindow, NSWindowDelegate {
  override func awakeFromNib() {
    super.awakeFromNib()
    minSize.width = 800.0
    minSize.height = 400.0
    self.delegate = self
    contentView?.layer?.backgroundColor = NSColor.white.cgColor
    contentView?.addSubview(notesView)
    layoutNotestView()
  }
  
  func windowDidResize(_ notification: Notification) {
    layoutNotestView()
  }
  
  private func layoutNotestView() {
    let w = contentView!.frame.width - 40.0
    let h = notesView.attributedStringValue.height(withConstrainedWidth: w, font: notesView.font!)
    notesView.frame = NSRect(x: 20.0, y: contentView!.frame.midY - h/2, width: w - 20.0, height: h)
  }
  
  private lazy var notesView: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.drawsBackground = true
    textField.isBezeled = false
    textField.isSelectable = false
    textField.textColor = NSColor.black
    textField.font = NSFont.systemFont(ofSize: 32.0)
    textField.alignment = NSTextAlignment.center
    textField.maximumNumberOfLines = 0
    textField.stringValue = NotesUpdaterPlugin.currentNotes
    return textField
  }()
  
  internal var notes: String = NotesUpdaterPlugin.currentNotes {
    didSet {
      let markdownParser = MarkdownParser(font: NSFont.systemFont(ofSize: 32.0))
      let mutableAttString = NSMutableAttributedString(attributedString: markdownParser.parse(notes))
      let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = NSTextAlignment.center
      mutableAttString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttString.length))
      notesView.attributedStringValue = mutableAttString;
      layoutNotestView()
    }
  }
}

extension NSAttributedString {
  func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
    return ceil(boundingBox.height)
  }
}
