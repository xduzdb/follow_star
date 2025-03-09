//
//  HistoryYearItemView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/30.
//

import SwiftUI

struct HistoryYearItemView: View {
    
    let data: EventTimeLineModel
    var body: some View {
        VStack {
            HStack {
                Text("\(data.year ?? 0)")
                    .bold()
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.colorEF5F49())
                    .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight])) // 添加右侧圆角
                    
                Spacer()
                
                
                Text("共\(data.count ?? 0)个")
                    .font(.system(size: 14))
                    .padding(.trailing, 12)
                    .foregroundColor(Color.colorC9CDD4())
                
            }
            
            // 一个循环的列表
            LazyVStack {
                ForEach(data.list ?? [], id: \.id) { item in
                    HistoryYearItemDetailsView(details: item)
                        .padding(.top, 12)
                }
            }
        }
    }
    
}

struct HistoryYearItemDetailsView: View {
    let details: EventTimeLineDetailsModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0) {
                // 7.24 由 XXX 添加
                HStack(spacing: 0) {
                    
                    Text("\((details.createdAt ?? "").formatTimeLineDateString()) 由 ")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.colorC9CDD4()) // 或其他颜色
                    
                    + Text(details.author ?? "")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.color4E5969()) // 或其他颜色
                    
                    + Text("添加")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.colorC9CDD4()) // 或其他颜色
                }
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            .padding(.horizontal, 12)
            .padding(.bottom, 0)
            
            HStack {
                Text(details.text ?? "")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(Color.black)
                    .padding(.all, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
//        .frame(width: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 12)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                               byRoundingCorners: corners,
                               cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
//    HistoryYearItemView()
}
