//
//  HistoryFixEventView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2025/1/2.
//

import SwiftUI

struct HistoryFixEventView: View {
    @State private var markText: String = ""
    var markTextCallback: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("纠错")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.color333333())
                .padding(.top, 24)

            // 输入框
            STTextView(
                text: $markText,
                placeholder: "请输入错误描述",
                maxLength: 500,
                height: 140,
                isHorCener: false,
                backgroundColor: .gray.opacity(0.1),
                placeholderColor: .gray,
                cornerRadius: 12,
                fontSize: 14
            ) { submittedText in
                markText = submittedText
            }

            HStack {
                Spacer()
                
                Text("500字以内")
                    .font(.system(size: 13))
                    .foregroundColor(.colorC9CDD4())
            }

            // 一个取消和修改
            HStack {
                // 取消按钮
                Button(action: {
                    // 取消操作
                    markTextCallback("")
                }) {
                    Text("取消")
                        .padding()
                        .font(.system(size: 20))
                        .foregroundColor(Color.color1D2129())
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                }

                // 确认修改按钮
                Button(action: {
                    // 确认修改操作
                    markTextCallback(markText)
                }) {
                    Text("确认修改")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 0)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .background(Color.white)
        .padding(.zero)
    }
}

#Preview {
    HistoryFixEventView { _ in
        
    }
}
