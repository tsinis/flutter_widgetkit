//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by tsinis on 13.08.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), count: "1")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, count: "1")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let db = type(of: DatabaseService()).init()
        let count = db.getCount()

        let reloadDate = Calendar.current.date(byAdding: .minute, value: 3, to: currentDate)!
        let entry = SimpleEntry(date: currentDate, configuration: configuration, count: count)
        let timeline = Timeline(entries: [entry], policy: .after(reloadDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let count: String?
}

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Count:")
            Text(entry.count ?? "0").font(.title)
        }
    }
}

@main
struct CounterWidget: Widget {
    let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CounterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CounterWidget_Previews: PreviewProvider {
    static var previews: some View {
        CounterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), count: "3"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
