//
//  Widgets.swift
//  Widgets
//
//  Created by Danil Hendra Suryawan on 26/11/24.
//

import SwiftUI
import WidgetKit
import os

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), scrumCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        guard case .success(let data) = fetchScrumData() else {
            return
        }
        
        let entry = SimpleEntry(date: Date(), scrumCount: data.count)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        guard case .success(let data) = fetchScrumData() else {
            return
        }
        
        // Fetch again after 15 minutes
        let nextFetch = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let entry = SimpleEntry(date: Date(), scrumCount: data.count)
        let timeline = Timeline(entries: [entry], policy: .after(nextFetch))
        completion(timeline)
    }

    private func fetchScrumData() -> Result<[DailyScrum], String> {
        guard
            let appGroupURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.com.danilhendrasr.Scrumdinger")
        else {
            return .failure("No data")
        }

        let fileURL = appGroupURL.appendingPathComponent("scrums.data")

        let logger = Logger(subsystem: "com.danilhendrasr.Scrumdinger", category: "Widget")
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonString = String(data: data, encoding: .utf8) {
                logger.log("Saved JSON Data: \(jsonString)")
            }
            let decodedData: [DailyScrum] = try JSONDecoder().decode([DailyScrum].self, from: data)
            return .success(decodedData)
        } catch {
            logger.log("Widget file URL: \(fileURL.absoluteString)")
            logger.error("Failed to fetch data: \(error.localizedDescription)")

            return .failure("Decoding failed \(error)")
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let scrumCount: Int
}

struct WidgetsEntryView: View {
    var entry: Provider.Entry
    
    func getAppIcon() -> UIImage {
        guard let icon = UIImage(named: "AppIcon") else {
            return UIImage(systemName: "app.fill")! // Fallback if icon not found
        }
        return icon
    }

    var body: some View {
        Image("WidgetAppIcon")
            .resizable()
            .frame(width: 50, height: 50)
        VStack(alignment: .leading) {
            Text("\(entry.scrumCount) scrums to do")
                .font(.title3)
                .multilineTextAlignment(.center)
        }
    }
}

struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            WidgetsEntryView(entry: entry)
                .containerBackground(.white, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

extension String: @retroactive Error {
    
}

#Preview(as: .systemSmall) {
    Widgets()
} timeline: {
    SimpleEntry(date: .now, scrumCount: 10)
    SimpleEntry(date: .now, scrumCount: 0)
}
