//
//  ShareSheet.swift
//  SwiftUISample
//
//  Created by akiho on 2021/02/13.
//

import SwiftUI
import LinkPresentation

struct ShareSheet: UIViewControllerRepresentable {
    let shareText: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let itemSource = ShareActivityItemSource(shareText: shareText)

        let activityItems: [Any] = [shareText, itemSource]

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)

        return controller
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}

private class ShareActivityItemSource: NSObject, UIActivityItemSource {
    var shareText: String
    var linkMetaData = LPLinkMetadata()

    init(shareText: String) {
        self.shareText = shareText
        linkMetaData.title = shareText
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "folder.fill") as Any
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
}
