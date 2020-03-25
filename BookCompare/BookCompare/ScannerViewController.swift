//
//  ScannerViewController.swift
//  BookCompare
//
//  Based on barcode Scanner VC by Paul Hudson, Hacking with Swift
//  https://www.hackingwithswift.com/example-code/media/how-to-scan-a-barcode
//

import AVFoundation

import UIKit

// Capture session, bar code recognition, and IBOutlets to subviews
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var book: Book?
    var scanHistory = [Book]()
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        errorMessage.isHidden = true
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        self.view.bringSubviewToFront(loadingIndicator)
        self.view.bringSubviewToFront(errorMessage)

    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

// Fetch book data from OpenLibrary and present appropriate detail
extension ScannerViewController {
    func found(code: String) {
        print(code)
        guard Int(code) != nil && (code.count == 13 || code.count == 10) else {
            self.errorMessage.text = " Enter an ISBN (10 or 13-digit ID number) 🕵️‍♂️ "
            self.errorMessage.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.errorMessage.isHidden = true
            }
            return
        }
        loadingIndicator.isHidden = false
        BookClient.getBook(isbn: code) {(book, error) in
            self.loadingIndicator.isHidden = true
            guard let book = book, error == nil else {
                self.captureSession.startRunning()
                if error is ParsingError {
                    self.errorMessage.text = " We don't know about this book. 🤔 "
                    self.errorMessage.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.errorMessage.isHidden = true
                    }
                } else {
                    self.errorMessage.text = " Network error. Check connection? 🤖 "
                    self.errorMessage.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.errorMessage.isHidden = true
                    }
                }
                print(error!)
                return
            }
            self.book = book
            self.scanHistory.append(book)
            guard let parent = self.parent as? ViewController else {
                print("Error: scanner unable to access parent view controller to perform segue")
                return
            }
            parent.performSegue(withIdentifier: "detailSegue", sender: self)
        }
    }

}
