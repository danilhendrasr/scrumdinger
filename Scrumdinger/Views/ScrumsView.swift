//
//  ScrumsView.swift
//  ScrumDinger
//
//  Created by Danil Hendra Suryawan on 20/11/24.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false

    let saveAction: () -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach($scrums) { $scrum in
                    NavigationLink(destination: DetailView(dailyScrum: $scrum)) {
                        HStack {
                            CardView(scrum: scrum)
                        }
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .onDelete { scrums.remove(atOffsets: $0) }
            }
            .navigationTitle("Daily Scrums")
            .toolbar {
                Button(action: {
                    isPresentingNewScrumView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Scrum")
            }
            .sheet(isPresented: $isPresentingNewScrumView) {
                NewScrumSheet(
                    scrums: $scrums,
                    isPresentingNewScrumView: $isPresentingNewScrumView)
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive {
                    saveAction()
                }
            }
        }
    }
}

#Preview {
    ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
}
