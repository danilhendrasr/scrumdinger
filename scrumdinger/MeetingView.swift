//
//  ContentView.swift
//  scrumdinger
//
//  Created by Danil Hendra Suryawan on 20/11/24.
//

import SwiftUI

struct MeetingView: View {
    var body: some View {
        VStack {
            ProgressView(value: 5, total: 15)
            HStack {
                VStack(alignment: .leading) {
                    Text("Seconds elapsed")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.tophalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Seconds remaining")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.bottomhalf.fill")
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Time remaining")
            .accessibilityValue("10 minutes")
            Circle().strokeBorder(lineWidth: 24)
            HStack {
                    Text("Speaker 1 of 3")
            }
            Button(action: {}) {
                Image(systemName: "forward.fill")
            }
            .accessibilityLabel("Next speaker")
        }
        .padding()
    }
}

#Preview {
    MeetingView()
}
