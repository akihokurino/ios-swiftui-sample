//
//  StorageUtil.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/12.
//

import FirebaseStorage
import Foundation

struct StorageUtil {
    static func upload(path: String, data: Data, completion: @escaping (URL) -> Void) {
        let targetRef = Storage.storage().reference().child(path)
        targetRef.putData(data, metadata: nil) { _, _ in
            targetRef.downloadURL { url, _ in
                guard let downloadURL = url else {
                    return
                }

                completion(downloadURL)
            }
        }
    }
}
