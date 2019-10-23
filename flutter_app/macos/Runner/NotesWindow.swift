//
//  NotesWindow.swift
//  Runner
//
//  Created by Kevin Gray on 10/22/19.
//  Copyright © 2019 Google LLC. All rights reserved.
//

import Foundation
import Cocoa

class NotesWindow: NSWindow, NSWindowDelegate {
  override func awakeFromNib() {
    super.awakeFromNib()
    self.delegate = self
    contentView?.layer?.backgroundColor = NSColor.white.cgColor
    contentView?.addSubview(notesView)
  }
  
  func windowDidResize(_ notification: Notification) {
    layoutNotestView()
  }
  
  private func layoutNotestView() {
    let w = contentView!.frame.width - 40.0
    let h = notesView.stringValue.height(withConstrainedWidth: w, font: notesView.font!)
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
    textField.stringValue = NotesUpdaterPlugin.currentNotes
    textField.alignment = NSTextAlignment.center
    textField.maximumNumberOfLines = 0
    return textField
  }()
  
  internal var notes: String = "" {
    didSet {
      notesView.stringValue = notes
      layoutNotestView()
    }
  }
}

extension String {
  func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
    
    return ceil(boundingBox.height)
    }
}
