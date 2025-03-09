//
//  STWebView.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/18.
//

import SwiftUI

struct STCustomWebView: UIViewControllerRepresentable {
    let url: URL

    // Create the view controller
    func makeUIViewController(context: Context) -> CustomWebViewController {
        return CustomWebViewController(url: url)
    }

    // Update the view controller if needed
    func updateUIViewController(_ uiViewController: CustomWebViewController, context: Context) {
        // No updates needed for now
    }
}

// New SwiftUI view to use CustomWebView
struct STWebView: View {
    let url: URL

    var body: some View {
        STCustomWebView(url: url)
            .navigationBarHidden(true)
    }
}
