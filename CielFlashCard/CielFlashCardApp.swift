//
//  CielFlashCardApp.swift
//  CielFlashCard
//
//  Created by Raphael on 24/10/24.
//

import SwiftUI
import SwiftData

@main
struct CielFlashCardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Deck.self)
        }
    }
}
