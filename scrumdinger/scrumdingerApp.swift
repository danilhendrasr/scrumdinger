//
//  scrumdingerApp.swift
//  scrumdinger
//
//  Created by Danil Hendra Suryawan on 20/11/24.
//

import SwiftUI

@main
struct scrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $scrums)
        }
    }
}
