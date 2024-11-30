//
//  Wisdom_WellApp.swift
//  Wisdom Well
//
//  Created by Shubham Jena on 27/11/24.
//

import SwiftUI
import Firebase

@main
struct Wisdom_WellApp: App {
    init(){
            FirebaseApp.configure()
            if let app = FirebaseApp.app() {
                print("Firebase successfully initialized: \(app.name)")
            } else {
                print("Firebase initialization failed.")
            }
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
