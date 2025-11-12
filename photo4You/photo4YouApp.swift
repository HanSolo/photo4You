//
//  photo4YouApp.swift
//  photo4You
//
//  Created by Gerrit Grunwald on 12.11.25.
//

import SwiftUI

@main
struct photo4YouApp: App {
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
