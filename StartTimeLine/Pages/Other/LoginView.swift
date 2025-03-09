//
//  LoginView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/1.
//

import SwiftUI

struct LoginView: View {
    @State var appear = [false, false, false]
    @State var text = ""
    @State var password = ""
    @State var circleInitialY = CGFloat.zero
    @State var circleY = CGFloat.zero
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    var dismissModal: () -> Void
    @AppStorage("isLogged") var isLogged = false
    
    // 登录注册页面
    var body: some View {
        ZStack(){
            VStack(spacing: 0, content: {
                String.BundleImageName("app_login_top")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
                Spacer()
            })
            RoundedRectangle(cornerRadius: 15)
                .frame(width: .infinity, height: .infinity)
                .edgesIgnoringSafeArea(.bottom)
                .offset(y: 225 - STHelper.SafeArea.top)
                .foregroundColor(.white)
            
            VStack(){
                form
            }
            .padding(.all)
            .offset(y: -80)
        }
    }
    
    var form: some View {
        Group {
            TextField("", text: $text)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .placeholder(when: text.isEmpty) {
                    Text("请输入手机号")
                        .foregroundColor(Color.hex("BFBFBF"))
                }
                .customField(icon: "envelope.open.fill")
                .focused($isEmailFocused)
                .onChange(of: isEmailFocused) { isEmailFocused in
                    if isEmailFocused {
                        withAnimation {
                            circleY = circleInitialY
                        }
                    }
                }
            
            SecureField("", text: $password)
                .textContentType(.password)
                .placeholder(when: password.isEmpty) {
                    Text("请输入密码")
                        .foregroundColor(Color.hex("BFBFBF"))
                }
                .customField(icon: "key.fill")
                .focused($isPasswordFocused)
                .onChange(of: isPasswordFocused) { isPasswordFocused in
                    if isPasswordFocused {
                        withAnimation {
                            circleY = circleInitialY + 70
                        }
                    }
                }
            
            Button {
                dismissModal()
                isLogged = true
            } label: {
//                AngularButton(title: "Create Account")
            }
        }
    }
}

#Preview {
    LoginView(dismissModal: {})
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
