//
//  scrumdingerApp.swift
//  scrumdinger
//
//  Created by Danil Hendra Suryawan on 20/11/24.
//

import SwiftUI

@main
struct scrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: DailyScrum.sampleData)
        }
    }
}
