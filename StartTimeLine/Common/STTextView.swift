//
//  STLimitedTextEditor.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2024/12/30.
//

import SwiftUI

struct STTextView: View {
    @Binding var text: String
    let placeholder: String
    let maxLength: Int
    var height: CGFloat = 100
    var isHorCener: Bool = true
    var backgroundColor: Color = .init(.systemGray6)
    var placeholderColor: Color = .init(.placeholderText)
    var cornerRadius: CGFloat = 8
    var fontSize: CGFloat = 16
    var onSubmit: ((String) -> Void)?
    
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        maxLength: Int = 200,
        height: CGFloat = 100,
        isHorCener: Bool = true,
        backgroundColor: Color = Color(.systemGray6),
        placeholderColor: Color = Color(.placeholderText),
        cornerRadius: CGFloat = 8,
        fontSize: CGFloat = 16,
        onSubmit: ((String) -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isHorCener = isHorCener
        self.maxLength = maxLength
        self.height = height
        self.backgroundColor = backgroundColor
        self.placeholderColor = placeholderColor
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            textInputView
                .frame(height: height)
                .padding(.horizontal)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
    
    @ViewBuilder
    private var textInputView: some View {
        if #available(iOS 16.0, *) {
            TextField(placeholder, text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(5)
                .font(.system(size: fontSize))
                .focused($isFocused)
                .onChange(of: text, perform: handleTextChange)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isHorCener ? .center : .top) // 添加这一行
                .padding(.vertical, 8) // 添加垂直内边距
        } else {
            TextEditor(text: $text)
                .font(.system(size: fontSize))
                .focused($isFocused)
                .overlay(placeholderOverlay)
                .onChange(of: text, perform: handleTextChange)
                .padding(.vertical, 8) // 添加垂直内边距
                .padding(.horizontal, 8) // 添加水平内边距
        }

    }
    
    @ViewBuilder
    private var placeholderOverlay: some View {
        if text.isEmpty {
            Text(placeholder)
                .font(.system(size: fontSize))
                .foregroundColor(placeholderColor)
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .allowsHitTesting(false)
                .padding(.leading, 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    private func handleTextChange(_ newValue: String) {
        if newValue.count > maxLength {
            text = String(newValue.prefix(maxLength))
        }
    }
}

#Preview {
    @State var nickname = ""
    STTextView(
        text: $nickname,
        placeholder: "请输入内容...",
        maxLength: 200,
        height: 52,
        backgroundColor: .gray.opacity(0.1),
        placeholderColor: .gray,
        cornerRadius: 12,
        fontSize: 14
    ) { submittedText in
        print("提交的内容：\(submittedText)")
    }
}
