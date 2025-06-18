//
//  ImagePicker.swift
//  Acnesight
//
//  Created by Ahmed Nizhan Haikal on 11/06/25.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    var onPhotoCaptured: (UIImage) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.onPhotoCaptured = onPhotoCaptured
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

#Preview {
    ImagePicker(onPhotoCaptured: {_ in })
}
