//
//  DetectorViewController.swift
/**
 * Webkul Software.
 *
 * @Mobikul
 * @PrestashopMobikulAndMarketplace
 * @author Webkul
 * @copyright Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html
 */

import UIKit
import AVFoundation
import Firebase

protocol SuggestionDataHandlerDelegate: class {
    func suggestedData(data: String)
}

class DetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIPopoverPresentationControllerDelegate, DetectedItem {
    
    @IBOutlet var captureView: UIImageView!
    @IBOutlet weak var flashLightBtn: UIButton!
    @IBOutlet weak var tableLocation_btn: UIButton!
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    let imageDetector = Vision.vision().onDeviceImageLabeler()
    var textDetector: VisionTextRecognizer!
    weak var delegate: SuggestionDataHandlerDelegate!
    var totalTextString  = [String]()
    var flag = Bool()
    var shouldTakePhoto = false
    var frameCount = 0
    static let labelConfidenceThreshold: Float = 0.75
    var tableViewController: UITableViewController!
    let detectViewModel = DetectViewModel()
    var isPresented = false
    var detectorType: DetectorType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = true
        
        switch detectorType {
        case .image?:
            break
            //let options = VisionFaceDetectorOptions(confidenceThreshold: DetectorViewController.labelConfidenceThreshold)
        // = vision.labelDetector(options: options)
        case .text?:
            textDetector =  Vision.vision().onDeviceTextRecognizer()
        default:
            break
        }
        prepareCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.toggleTorch(on: false)
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { (_) in
            self.detectViewModel.delegate = self
            self.tableViewController = UITableViewController()
            self.tableViewController.tableView.delegate = self.detectViewModel
            self.tableViewController.tableView.dataSource = self.detectViewModel
            self.tableViewController.preferredContentSize = CGSize(width: SCREEN_WIDTH/2, height: (SCREEN_HEIGHT/2 < SCREEN_WIDTH/2 ? SCREEN_WIDTH/2:SCREEN_HEIGHT/2))
            self.showPopup(self.tableViewController, sourceView: self.tableLocation_btn)
            self.isPresented = true
        })
        totalTextString = []
        switch detectorType {
        case .image?:
            break
            //let options = VisionFaceDetectorOptions(confidenceThreshold: DetectorViewController.labelConfidenceThreshold)
        //imageDetector = vision.labelDetector(options: options)
        case .text?:
            textDetector =  Vision.vision().onDeviceTextRecognizer()
        default:
            break
        }
        //self.isPresented = false
        return true
    }
    
    func DetectedValue(value: String) {
        self.tableViewController.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        delegate.suggestedData(data: value)
    }
    
    @IBAction func crossAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clickButton() {
        print("button click")
        self.navigationController?.popViewController(animated: true)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
        captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.first
        beginSession()
    }
    
    @IBAction func stopCapturing(_ sender: Any) {
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
            presentCameraSettings()
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        previewLayer.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.view.bringSubviewToFront(self.flashLightBtn)
        captureSession.startRunning()
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [
            ((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        let queue = DispatchQueue(label: "captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    func presentCameraSettings() {
        var appName = ""
        appName = "appName".localized
        let alertController = UIAlertController(title: appName, message: "cameraAccessDenied".localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "cancel".localized, style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(UIAlertAction(title: "settings".localized, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    self.prepareCamera()
                })
            }
        })
        self.present(alertController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // Process frames only at a specific duration. This skips redundant frames and
    // avoids memory issues.
    func proccess(every: Int, callback: () -> Void) {
        frameCount += 1
        // Process every nth frame
        if frameCount % every == 0 {
            callback()
        }
    }
    
    // Combine all VisionText into one String
    private func flattenVisionImage(visionImageLabel: [VisionImageLabel]?) -> String {
        var text = ""
        
        for label in visionImageLabel ?? [] {
            text += " " + label.text
        }
        if let vision = visionImageLabel {
            for i in 0..<vision.count {
                if totalTextString.contains(vision[i].text) == false {//&& totalTextString.count<=9{
                    print(totalTextString)
                    totalTextString.append(vision[i].text.trimmingCharacters(in: .whitespacesAndNewlines))
                    self.detectViewModel.getValue(data: totalTextString) { (check) in
                        if check {
                            if !self.isPresented {
                                self.detectViewModel.delegate = self
                                self.tableViewController = UITableViewController()
                                self.tableViewController.tableView.delegate = detectViewModel
                                self.tableViewController.tableView.dataSource = detectViewModel
                                self.tableViewController.preferredContentSize = CGSize(width: SCREEN_WIDTH/2, height: (SCREEN_HEIGHT/2 < SCREEN_WIDTH/2 ? SCREEN_WIDTH/2:SCREEN_HEIGHT/2))
                                self.showPopup(self.tableViewController, sourceView: self.tableLocation_btn)
                                self.isPresented = true
                            }
                            self.tableViewController.tableView.alpha = 1
                            self.tableViewController.tableView.reloadData()
                        }
                    }
                }
            }
        }
        return text
    }
    
    private func flattenVisionText(visionText: VisionText?) -> String {
        var text = ""
        print(visionText?.blocks as Any)
        visionText?.blocks.forEach() { vText in
            text += " " + vText.text
        }
        if let vision = visionText?.blocks {
            for i in 0..<vision.count {
                if totalTextString.contains(vision[i].text) == false {//&& totalTextString.count<=9{
                    print(totalTextString)
                    totalTextString.append(vision[i].text.trimmingCharacters(in: .whitespacesAndNewlines))
                    self.detectViewModel.getValue(data: totalTextString) { (check) in
                        if check {
                            if !self.isPresented {
                                self.detectViewModel.delegate = self
                                self.tableViewController = UITableViewController()
                                self.tableViewController.tableView.delegate = detectViewModel
                                self.tableViewController.tableView.dataSource = detectViewModel
                                self.tableViewController.preferredContentSize = CGSize(width: SCREEN_WIDTH/2, height: (SCREEN_HEIGHT/2 < SCREEN_WIDTH/2 ? SCREEN_WIDTH/2:SCREEN_HEIGHT/2))
                                self.showPopup(self.tableViewController, sourceView: self.tableLocation_btn)
                                self.isPresented = true
                            }
                            self.tableViewController.tableView.alpha = 1
                            self.tableViewController.tableView.reloadData()
                        }
                    }
                }
            }
        }
        return text
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller, delegate: self)
        AlwaysPresentAsPopover.delegate = self
        presentationController?.sourceView = sourceView
        presentationController?.sourceRect = sourceView.bounds
        presentationController?.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
        self.tableViewController.tableView.reloadData()
    }
    
    // Detect text in a CMSampleBuffer by converting to a UIImage to determine orientation
    func detectText(in buffer: CMSampleBuffer, completion: @escaping (_ text: String, _ image: UIImage) -> Void) {
        if let image = buffer.toUIImage() {
            let viImage = image.toVisionImage()
            switch detectorType {
            case .image?:
                imageDetector.process(viImage) { labels, error in
                    guard error == nil, let labels = labels else { return }
                    completion(self.flattenVisionImage(visionImageLabel: labels), image)
                }
            case .text?:
                textDetector.process(viImage) { visionText, error in
                    guard error == nil, let visionText = visionText else { return }
                    completion(self.flattenVisionText(visionText: visionText), image)
                }
            default:
                break
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Detect text every 10 frames
        proccess(every: 10) {
            self.detectText(in: sampleBuffer) { text, image in
                print("sss", text)
            }
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    @IBAction func flashLightAction(_ sender: Any) {
        flag = !flag
        self.flashLightBtn.isSelected = !self.flashLightBtn.isSelected
        self.toggleTorch(on: flag)
    }
    
}

extension CMSampleBuffer {
    // Converts a CMSampleBuffer to a UIImage
    //
    // Return: UIImage from CMSampleBuffer
    func toUIImage() -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(self) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
}
