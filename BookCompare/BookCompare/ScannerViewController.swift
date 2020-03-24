//
//  ScannerViewController.swift
//  BookCompare
//
//  Barcode Scanner VC by Paul Hudson, Hacking with Swift
//  https://www.hackingwithswift.com/example-code/media/how-to-scan-a-barcode
//

import AVFoundation

import UIKit

// Barcode capture functionality from Apple's AVCam example:
//https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var book: Book?
    var scanHistory = [Book]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func ButtonClick(_ sender: Any) {
        print("In button click")
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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

// Fetch book data and present appropriate detail
extension ScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! DetailViewController
            vc.book = self.book
        }
    }
    
    func found(code: String) {
        print(code)
        BookClient.getBook(isbn: code) {(book, error) in
            guard let book = book, error == nil else {
                if let parsingError = error as? ParsingError {
                    print(parsingError)
                    // Book unavailable popup
                } else {
                    // Network error popup
                }
                print(error!) //-1009 for no wifi connection
                return
            }
            self.book = book
            self.scanHistory.append(book)
            self.performSegue(withIdentifier: "detailSegue", sender: nil)
        }
    }

}
