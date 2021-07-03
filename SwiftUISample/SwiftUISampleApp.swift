//
//  SwiftUISampleApp.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/01.
//

import Firebase
import PartialSheet
import SwiftUI

@main
struct SwiftUISampleApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            Root()
                .environmentObject(GlobalStore())
                .environmentObject(PartialSheetManager())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
