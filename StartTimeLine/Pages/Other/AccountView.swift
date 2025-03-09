//
//  AccountView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/4.
//

import SwiftUI

struct AccountView: View {
    
    @State var isDeleted = false
    @State var isPin = false
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            List {
                menu
            }
            .listStyle(.insetGrouped)
//            .navigationTitle("Account")
            .navigationBarItems(trailing: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done").bold()
            })
        }  .statusBar(hidden:true)
    }
    
    var menu : some View {
        Section {
            NavigationLink(destination: AboutUsView()) {
                HStack {
                    Text("")
                    Spacer()
                    Text("123")
                }
            }
            
            NavigationLink {
                Text("联系客服")
            } label: {
                Label("联系客服",systemImage: "creditcard")
            }
            
            NavigationLink(destination: AboutUsView()) {
                Label("关于我们", systemImage: "gear")
            }
            
            
        }
        .accentColor(.primary)
        .listRowSeparatorTint(.blue)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    AccountView()
}
