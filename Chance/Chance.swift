//
//  Chance.swift
//  Chance
//
//  Created by Cade Crandall on 4/6/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), track: SpotifyWrapper.random())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // this is what shows up in the widget gallery
        let entry = SimpleEntry(date: Date(), configuration: configuration, track: SpotifyWrapper.random())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, track: SpotifyWrapper.random())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let track: CCCTrack
}

struct ChanceEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        TrackView(track: entry.track)
    }
}

@main
struct Chance: Widget {
    let kind: String = "Chance"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChanceEntryView(entry: entry)
        }
        .configurationDisplayName("Chance Extension")
        .description("Display current Spotify status in the Notification Center, native to macOS.")
    }
}
//
//struct Chance_Previews: PreviewProvider {
//    static var previews: some View {
//        ChanceEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), track: SpotifyWrapper.random()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

