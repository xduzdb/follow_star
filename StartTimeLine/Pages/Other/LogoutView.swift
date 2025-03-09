//
//  LogoutView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/19.
//

import SwiftUI

struct LogoutView: View {
    @State private var shouldNavigate = false
    
    var body: some View {
        NavTopView {
            VStack(alignment: .leading, content: {
                HStack(spacing: 0, content: {
                    Image(systemName: "info.circle")
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color.colorFF7D00())
                        .padding(.zero)
                        .padding(.trailing, 6)
                        .padding(.leading, 16)

                    Text("您正在注销账号，请注意以下事项")
                        .font(.system(size: 14))
                        .foregroundColor(Color.colorFF7D00())

                        .padding(.vertical, 8)

                    Spacer()
                })
                .background(Color.colorFFF7E8())
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.top, 12)
                .padding(.horizontal)

                // 中间的信息
                VStack(content: {
                    HStack {
                        VStack {
                            Text("尊敬的用户：\n\n 如果您决定注销您的账号，以下是相关的重要信息和步骤：\n")
                                .font(.system(size: 14))

                            Text("一、注销账号是不可逆转的操作，一旦注销，您的所有个人信息、历史记录、数据等都将被永久删除，且无法恢复。\n\n例如：您发布的帖子、评论、上传的文件等都将不复存在。\n\n二、请确保您已经处理完与该账号相关的所有重要事务，如未完成的交易、待处理的订单等。\n\n比如您在我们平台上购买的尚未使用的服务或商品，需要在注销前完成使用或退款操作。\n\n三、在提交注销申请后，我们将在[3]个工作日内完成审核和处理。在此期间，您可以随时撤销注销申请。")
                                .font(.system(size: 14))
                                .bold()
                        }
                        .padding()
                        Spacer()
                    }
                    Spacer()
                })
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.horizontal)

                NavigationLink(destination: LogoutEndView()) { Button(action: {
                    print("Button tapped!")
                    // 跳转到下一个页面
                    shouldNavigate = true
                }) {
                    Text("我已知晓并确认注销")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .padding(.bottom, 50)
                .buttonStyle(GradientCornerRadiusButtonStyle()) }
                
                NavigationLink(destination: LogoutEndView(), isActive: $shouldNavigate) {
                    EmptyView()
                }

                Spacer()
            })
            .background(Color.hex("F7F6FB"))
        }
        .title("注销账号")
        .ignoringTopArea(false)
        
    }
}

#Preview {
    LogoutView()
}
