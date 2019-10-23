// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Cocoa
import FlutterMacOS


class NotesUpdaterPlugin : NSObject, FlutterPlugin {
  static var currentNotes: String = ""
  private let channel: FlutterMethodChannel
  static func register(with registrar: FlutterPluginRegistrar) {
    
    let channel = FlutterMethodChannel(name: "FlutterSlides:NotesUpdater",
                                       binaryMessenger: registrar.messenger)
    let instance = NotesUpdaterPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }
  
  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "update") {
      if let notes = call.arguments as? String {
        NotesUpdaterPlugin.currentNotes = notes
        for window in NSApplication.shared.windows {
          if let notesWindow = window as? NotesWindow {
            notesWindow.notes = NotesUpdaterPlugin.currentNotes
          }
        }
        print(NotesUpdaterPlugin.currentNotes)
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
