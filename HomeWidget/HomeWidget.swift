//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by lushitong on 2024/9/1.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), model: OneDayStore.fetchModel())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        // 获取当前的挂件通知

        OneDayStore.fetchData(context.family) {
            let model = OneDayStore.fetchModel()

            /// policy提供下次更新的时间，可填：
            /// .never：永不更新(可通过WidgetCenter更新)
            /// .after(Date)：指定多久之后更新
            /// .atEnd：指定Widget通过你提供的entries的Date更新。
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!

            /// entries提供下次更新的数据
            let entry = SimpleEntry(date: refreshDate, model: model)

            /// 刷新数据和控制下一步刷新时间
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let model: OneDayModel
}

struct HomeWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                OneDayMediumView(model: entry.model)
            default:
                OneDaySmallView(model: entry.model)
            }
        }
    }
}

struct HomeWidget: Widget {
    let kind: String = "StartTimeLine"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetEntryView(entry: entry)
               
        }
        .configurationDisplayName("")
        .description("最新动态")
        .supportedFamilies([.systemSmall, .systemMedium])
        .disableWidgetContentMargins()
    }
}


struct DesktopWidget_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()

        let smallFamily = WidgetFamily.systemSmall
        let smallEntry = SimpleEntry(date: date, model: OneDayModel.placeholder())
        HomeWidgetEntryView(entry: smallEntry)
            .previewContext(WidgetPreviewContext(family: smallFamily))

        let mediumFamily = WidgetFamily.systemMedium
        let mediumEntry = SimpleEntry(date: date, model: OneDayModel.placeholder())
        HomeWidgetEntryView(entry: mediumEntry)
            .previewContext(WidgetPreviewContext(family: mediumFamily))
    }
}
