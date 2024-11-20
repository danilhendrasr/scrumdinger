//
//  DetailView.swift
//  scrumdinger
//
//  Created by Danil Hendra Suryawan on 20/11/24.
//

import SwiftUI

struct DetailView : View {
    let dailyScrum: DailyScrum
    
    var body: some View {
        List {
            Section(header: Text("Meeting Info")) {
                NavigationLink(destination: MeetingView()) {
                    Label("Start meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(dailyScrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(dailyScrum.theme.name)
                        .padding(4)
                        .foregroundColor(dailyScrum.theme.accentColor)
                        .background(dailyScrum.theme.mainColor)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Attendees")) {
                ForEach(dailyScrum.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            }
        }
        .navigationTitle(dailyScrum.title)
    }
}

#Preview {
    NavigationStack {
        DetailView(dailyScrum: DailyScrum.sampleData[0])
    }
}
