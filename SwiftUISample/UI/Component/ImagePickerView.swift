//
//  ImagePickerView.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/29.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var data: Data?

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image, data: $data)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isCoordinatorShown: Bool
        @Binding var imageInCoordinator: Image?
        @Binding var dataInCoordinator: Data?

        init(isShown: Binding<Bool>, image: Binding<Image?>, data: Binding<Data?>) {
            _isCoordinatorShown = isShown
            _imageInCoordinator = image
            _dataInCoordinator = data
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
        {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            imageInCoordinator = Image(uiImage: unwrapImage)
            dataInCoordinator = unwrapImage.jpegData(compressionQuality: 0.7)
            isCoordinatorShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isCoordinatorShown = false
        }
    }
}

extension ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {}
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView(isShown: .constant(false), image: .constant(nil), data: .constant(nil))
    }
}
