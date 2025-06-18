//
//  CameraViewController.swift
//  Acnesight
//
//  Created by Ahmed Nizhan Haikal on 18/06/25.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var session: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var onPhotoCaptured: ((UIImage) -> Void)?
    
    private var overlayView: UIView?
    private var currentCameraPosition: AVCaptureDevice.Position = .front
    private var bottomBar: UIView?
    // Confirmation overlay properties
    private var capturedImageView: UIImageView?
    private var confirmationOverlay: UIView?
    private var shutterButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        photoOutput = AVCapturePhotoOutput()
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0))
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }

        addOverlay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bottomBar == nil {
            setupBottomBar()
        }
        if let overlay = overlayView {
            view.bringSubviewToFront(overlay)
        }
        previewLayer.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0))
    }
    
    @objc private func dismissCamera() {
        dismiss(animated: true, completion: nil)
    }

    private func addOverlay() {
        let overlayView = UIView()
        overlayView.isUserInteractionEnabled = false
        overlayView.backgroundColor = .clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let label = UILabel()
        label.text = "Point out the camera to your acne"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.alpha = 1.0

        let icon = UIImageView(image: UIImage(systemName: "camera.viewfinder"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: overlayView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor)
        ])
        blurView.contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor, constant: -50),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: blurView.contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(greaterThanOrEqualTo: blurView.contentView.trailingAnchor, constant: -16),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1.0, animations: {
                stack.alpha = 0.0
                blurView.alpha = 0.0
            }) { _ in
                stack.removeFromSuperview()
                blurView.removeFromSuperview()

                let secondLabel = UILabel()
                secondLabel.text = "Make sure to point out your acne and don’t wear any accessories or makeup"
                secondLabel.textColor = .white
                secondLabel.font = UIFont.systemFont(ofSize: 16)
                secondLabel.numberOfLines = 2
                secondLabel.textAlignment = .center
                secondLabel.translatesAutoresizingMaskIntoConstraints = false
                overlayView.addSubview(secondLabel)

                NSLayoutConstraint.activate([
                    secondLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                    secondLabel.topAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.bottomAnchor, constant: -165),
                    secondLabel.leadingAnchor.constraint(greaterThanOrEqualTo: overlayView.leadingAnchor, constant: 16),
                    secondLabel.trailingAnchor.constraint(lessThanOrEqualTo: overlayView.trailingAnchor, constant: -16),
                ])
            }
        }

        self.overlayView = overlayView
    }

    @objc private func capturePhoto() {
        shutterButton?.isEnabled = false
        shutterButton?.backgroundColor = .gray
        overlayView?.isHidden = true // 🔥 overlay disappears exactly when shutter pressed

        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            showConfirmationOverlay(with: image)
            self.bottomBar?.subviews.forEach { view in
                if let button = view as? UIButton {
                    button.isEnabled = false
                }
            }
        }
    }

    private func showConfirmationOverlay(with image: UIImage) {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .black
        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: overlay.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -100),
            imageView.leadingAnchor.constraint(equalTo: overlay.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: overlay.trailingAnchor)
        ])

        let retakeButton = UIButton(type: .system)
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.setTitleColor(.white, for: .normal)
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakePhoto), for: .touchUpInside)

        let chooseButton = UIButton(type: .system)
        chooseButton.setTitle("Choose Picture", for: .normal)
        chooseButton.setTitleColor(.white, for: .normal)
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.addTarget(self, action: #selector(confirmPhoto), for: .touchUpInside)

        overlay.addSubview(retakeButton)
        overlay.addSubview(chooseButton)

        NSLayoutConstraint.activate([
            retakeButton.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20),
            retakeButton.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -50),

            chooseButton.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20),
            chooseButton.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -50)
        ])

        self.capturedImageView = imageView
        self.confirmationOverlay = overlay
    }

    @objc private func retakePhoto() {
        confirmationOverlay?.removeFromSuperview()
        confirmationOverlay = nil
        capturedImageView = nil
        overlayView?.isHidden = false
        bottomBar?.subviews.forEach { view in
            if let button = view as? UIButton {
                button.isEnabled = true
            }
        }
        shutterButton?.backgroundColor = .white
    }

    @objc private func confirmPhoto() {
        guard let image = capturedImageView?.image else { return }
        onPhotoCaptured?(image)
    }

    private func setupBottomBar() {
        let bar = UIView()
        self.bottomBar = bar
        bar.backgroundColor = .black
        bar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bar)

        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bar.heightAnchor.constraint(equalToConstant: 150)
        ])

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(dismissCamera), for: .touchUpInside)

        self.shutterButton = UIButton(type: .custom)
        let shutterButton = self.shutterButton!
        shutterButton.backgroundColor = .white
        shutterButton.layer.cornerRadius = 35
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        shutterButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)

        let switchButton = UIButton(type: .system)
        switchButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        switchButton.tintColor = .white
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)

        bar.addSubview(cancelButton)
        bar.addSubview(shutterButton)
        bar.addSubview(switchButton)

        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: bar.centerXAnchor),
            shutterButton.centerYAnchor.constraint(equalTo: bar.safeAreaLayoutGuide.centerYAnchor),
            shutterButton.widthAnchor.constraint(equalToConstant: 70),
            shutterButton.heightAnchor.constraint(equalToConstant: 70),

            cancelButton.centerYAnchor.constraint(equalTo: bar.safeAreaLayoutGuide.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 20),

            switchButton.centerYAnchor.constraint(equalTo: bar.safeAreaLayoutGuide.centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -20)
        ])
    }

    @objc private func switchCamera() {
        guard let session = session else { return }

        session.beginConfiguration()

        // Remove existing input
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)

            // Determine new position
            let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
            currentCameraPosition = newPosition

            // Add new input
            if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
               let newInput = try? AVCaptureDeviceInput(device: newDevice),
               session.canAddInput(newInput) {
                session.addInput(newInput)
            }
        }

        session.commitConfiguration()
    }
}
