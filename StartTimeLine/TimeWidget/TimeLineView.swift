import SDWebImageSwiftUI
import SwiftUI
import WidgetKit

// MARK: - Small Widget

struct OneDaySmallView: View {
    let dateInfo = Date().jp.info
    var model = OneDayModel.placeholder()

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        // 图片是 110 150
        ZStack {
            Image(colorScheme == .dark ? "app_widget_dark_back" : "app_widget_back")
                .resizable() // 使图片可调整大小
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(
                    Color.black.opacity(0.15)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(dateInfo.year).\(dateInfo.month).\(dateInfo.day) \(dateInfo.weekday) ")
                        .font(.custom("PingFangSC", size: 12))
                        .foregroundColor(Color("TimeBack"))

                    Spacer()

                    Text(model.type)
                        .font(.custom("PingFangSC", size: 12))
                        .foregroundColor(Color("TopTextColor"))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)

                        .background(LinearGradient(gradient: Gradient(colors: [Color("TopStartColor"), Color("TopEndColor")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                }

                Text("此时此刻")
                    .font(.custom("PingFangSC", size: 12))
                    .foregroundColor(Color("TimeBack"))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .border(Color("BorderColor"), width: 0.5)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.startWidgetLinear().opacity(0.05), Color.endWidgetLinear().opacity(0.05)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(2)
                    .padding(.bottom, 24)

                Text(model.text)
                    .lineLimit(2)
                    .font(.custom("PingFangSC", size: 14))
                    .foregroundColor(Color("TextBack"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
//            .baseShadow()
            .padding(.horizontal, 14)
            .padding(.top, 13)
            .padding(.bottom, 18)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(
                Color.black.opacity(0.01)
            )
        }
    }
}

// MARK: - Medium Widget

struct OneDayMediumView: View {
    let dateInfo = Date().jp.info
    var model = OneDayModel.placeholder()

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(content: {
            Image(colorScheme == .dark ? "app_widget_dark_back" : "app_widget_back")
                .resizable() // 使图片可调整大小
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(
                    Color.black.opacity(0.15)
                )

            // 明星的图片
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 110, height: 150)
                .clipped()
                .position(x: 67.0, y: 86.0)
                .cornerRadius(8)
                .foregroundColor(.red)

            //  使用网络图片

            HStack {
                Spacer()
                    .frame(width: 110)

                VStack(alignment: .leading) {
                    HStack(content: {
                        Spacer()
                        Text(model.type)
                            .font(.custom("PingFangSC", size: 12))
                            .foregroundColor(Color("TopTextColor"))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)

                            .background(LinearGradient(gradient: Gradient(colors: [Color("TopStartColor"), Color("TopEndColor")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                    })

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(dateInfo.year).\(dateInfo.month).\(dateInfo.day) \(dateInfo.weekday) ")
                            .font(.custom("PingFangSC", size: 12))
                            .foregroundColor(Color("TimeBack"))

                        Text("此时此刻")
                            .font(.custom("PingFangSC", size: 12))
                            .foregroundColor(Color("TimeBack"))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .border(Color("BorderColor"), width: 0.5)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.startWidgetLinear().opacity(0.05), Color.endWidgetLinear().opacity(0.05)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(2)
                    }

                    Spacer()

                    Text(model.text)
                        .lineLimit(2)
                        .font(.custom("PingFangSC", size: 14))
                        .foregroundColor(Color("TextBack"))
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
//                .baseShadow()
                .padding(.horizontal, 12)
                .padding(.leading, 12)
                .padding(.top, 15)
                .padding(.bottom, 20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(
                    Color.black.opacity(0.01)
                )
            }
        })
    }
}

// MARK: - Large Widget 暂时用不到 可能后端增加时候需要

struct OneDayLargeView: View {
    static let bottomContentHeight: CGFloat = 100

    let dateInfo = Date().jp.info
    var model = OneDayModel.placeholder()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text(dateInfo.day)
                        .font(.custom("DINAlternate-Bold", size: 36))
                        .foregroundColor(.white)
                        + Text(" / \(dateInfo.month)")
                        .font(.custom("DINAlternate-Bold", size: 18))
                        .foregroundColor(.white)
                    Text("\(dateInfo.year), \(dateInfo.weekday)")
                        .font(.custom("PingFangSC", size: 11))
                        .foregroundColor(.white.opacity(0.9))
                }
                .baseShadow()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 10)
                .padding(.horizontal, 24)

                HStack(alignment: .center, spacing: 10) {
                    Text(model.showText)
                        .font(.custom("PingFangSC", size: 15))
                        .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.9) : Color(red: 0.25, green: 0.25, blue: 0.27))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text("今日\n语录")
                        .font(.custom("PingFangSC", size: 21))
                        .foregroundColor(colorScheme == .dark ? Color(red: 0.8, green: 0.8, blue: 0.8) : Color(red: 0.56, green: 0.56, blue: 0.56))
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .frame(height: OneDayLargeView.bottomContentHeight)
                .background(colorScheme == .dark ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color.white)
    }
}

struct OneDayView_Previews: PreviewProvider {
    static let smallSize = WidgetFamily.systemSmall.jp.widgetSize
    static let mediumSize = WidgetFamily.systemMedium.jp.widgetSize
    static let largeSize = WidgetFamily.systemLarge.jp.widgetSize

    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                Group {
                    OneDaySmallView()
                        .frame(width: smallSize.width, height: smallSize.height)
                    OneDayMediumView()
                        .frame(width: mediumSize.width, height: mediumSize.height)
//                    OneDayLargeView()
//                        .frame(width: largeSize.width, height: largeSize.height)
                }
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .baseShadow()
                .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
