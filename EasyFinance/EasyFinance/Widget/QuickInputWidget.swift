import WidgetKit
import SwiftUI
import AppIntents

struct QuickInputEntry: TimelineEntry {
    let date: Date
}

struct QuickInputProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuickInputEntry {
        QuickInputEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (QuickInputEntry) -> ()) {
        let entry = QuickInputEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuickInputEntry>) -> ()) {
        let entry = QuickInputEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct QuickInputWidgetEntryView : View {
    var entry: QuickInputProvider.Entry

    // Hardcoded for MVP Widget (sharing data via App Groups is complex to setup in file-only mode)
    // We assume these match the default seeded categories.
    let categories: [(name: String, icon: String, color: String)] = [
        ("食費", "fork.knife", "orange"),
        ("日用品", "cart", "blue"),
        ("交通費", "tram", "green"),
        ("その他", "ellipsis.circle", "gray")
    ]

    var body: some View {
        VStack {
            Text("クイック入力 (0円で記録)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(categories, id: \.name) { cat in
                    Button(intent: SimpleAddTransactionIntent(categoryName: cat.name)) {
                        VStack {
                            Image(systemName: cat.icon)
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(Color(widgetColorName: cat.color).opacity(0.1))
                                .foregroundStyle(Color(widgetColorName: cat.color))
                                .clipShape(Circle())
                            
                            Text(cat.name)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
    }
}

@main
struct QuickInputWidget: Widget {
    let kind: String = "QuickInputWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickInputProvider()) { entry in
            QuickInputWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("クイック入力")
        .description("タップして支出を即座に入力します。")
        .supportedFamilies([.systemMedium])
    }
}

// Color helper
extension Color {
    init(widgetColorName name: String) {
        switch name {
        case "blue": self = .blue
        case "green": self = .green
        case "orange": self = .orange
        case "red": self = .red
        case "purple": self = .purple
        case "pink": self = .pink
        case "yellow": self = .yellow
        case "gray": self = .gray
        default: self = .gray
        }
    }
}
