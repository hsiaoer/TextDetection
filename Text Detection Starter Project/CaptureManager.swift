import UIKit
import AVFoundation

// Done - move this logic into ViewController
//extension ViewController: CaptureManagerDelegate {
//    func processCapturedImage(image: UIImage) {
//        self.imageView.image = image
//    }
//}

//protocol CaptureManagerDelegate: class {
//     func processCapturedImage(image: UIImage)
// }


class CaptureManager: NSObject {
    internal static let shared = CaptureManager()
    //weak var delegate: CaptureManagerDelegate?
    //var session: AVCaptureSession?
    
    override init() {
        super.init()
//        session = AVCaptureSession()
//
//        //setup input
//        let device =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
//        let input = try! AVCaptureDeviceInput(device: device!)
//        session?.addInput(input)
//
//        //setup output
//        let output = AVCaptureVideoDataOutput()
//        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_32BGRA]
//        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
//        session?.addOutput(output)
    }
    
//    func statSession() {
//        session?.startRunning()
//    }
//
//    func stopSession() {
//        session?.stopRunning()
//    }
    
    func getCGImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->CGImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return cgImage
    }
    
    func getUIImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
        guard let cgImage = getCGImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        return image
    }
    
    func getCIImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->CIImage? {
        guard let cgImage = getCGImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return nil
        }
        
        let image = CIImage(cgImage: cgImage).oriented(CGImagePropertyOrientation.right)
        return image
    }
}

/// Done - moved this logic go ViewController
//extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
//            return
//        }
//        delegate?.processCapturedImage(image: outputImage)
//    }
//}

