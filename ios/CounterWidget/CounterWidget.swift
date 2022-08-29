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
        // Same as the default placeholder but also contains the required count.
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), count: "1")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // Same as the default getSnapshot but also contains the required count.
        let entry = SimpleEntry(date: Date(), configuration: configuration, count: "1")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // We won't use entries here, since our list of entries will only contain one entry, also
        // no hour offset will be used here since we are mainly expecting data to be updated
        // from the Dart side.

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()

        // Database service which could have some data for the home screen widget to show.
        let db = type(of: DatabaseService()).init()

        // Nullable method, which should return stored value or return nil(null) if it's empty.
        let count = db.getCount()

        // Try to reload the home-screen widget every 15 minutes, but we rely on the update from
        // the Dart side. Because iOS widgets have a limited number of updates and if you were
        // to try to update every few minutes, you'll quickly run out of updates.
        let reloadDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        // Same entry as the default one but with the current date and count value from the database.
        let entry = SimpleEntry(date: currentDate, configuration: configuration, count: count)
        // Same timeline as the default one but with a single entry and new policy. Set policy
        // to .never if the widget should be updated only from the Flutter app.
        let timeline = Timeline(entries: [entry], policy: .after(reloadDate))
        completion(timeline)
    }
}

// Same class as the default one but have a field for showing database value.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let count: String?
}

// Same UI as the default one, but have text in two rows.
struct CounterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack { // Flutter's Column(children: [
            Text("Count:")
            Text(entry.count ?? "0").font(.title)
        }
    }
}

// Same class as the default one.
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

// This is not very important, it's a default XCode's preview provider to create a preview directly inside Xcode.
struct CounterWidget_Previews: PreviewProvider {
    static var previews: some View {
        CounterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), count: "1"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
