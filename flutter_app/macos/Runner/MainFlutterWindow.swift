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
import FirebaseDatabase
import FirebaseCore

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    minSize.width = 400.0
    minSize.height = 400.0

    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    FLTFirebaseDatabasePlugin.register(with: flutterViewController.registrar(forPlugin: "FirebaseDatabasePlugin"))
    super.awakeFromNib()
  }
}
