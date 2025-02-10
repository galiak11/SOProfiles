//
//  VisionService.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/10/25.
//

import Vision
import UIKit

typealias ImageCountTuple = (image: UIImage, faceCount: Int)

class VisionService {
  static let shared = VisionService()

  func drawFaceRects(for image: UIImage) -> ImageCountTuple? {
    guard let rects = faceRects(for: image) else { return nil }
    var rectImage = image
    var countRects = rects.count
    for rect in rects {
      UIGraphicsBeginImageContext(image.size)
      rectImage.draw(at: .zero)
      if let context = UIGraphicsGetCurrentContext() {
        context.setStrokeColor(UIColor.systemGreen .cgColor)
        context.setLineWidth(4.0)
        context.stroke(rect.normalizeWith(image.size))

        if let imageFromContext = UIGraphicsGetImageFromCurrentImageContext() {
          rectImage = imageFromContext
        }
        UIGraphicsEndPDFContext()
      } else {
        print ("Error: Cannot draw rect \(rect) in context")
        countRects -= 1
      }
    }
    return countRects >= 0 ? (rectImage, countRects) : nil
  }

  private func detectFaces(for image: UIImage) -> [VNFaceObservation]? {
    guard let cgImage = image.cgImage else {
      print("Error in face detection: Failed to convert UIImage to CGImage")
      return nil
    }

    let request = VNDetectFaceRectanglesRequest()

#if targetEnvironment(simulator)
    request.enableSimulator()
#endif

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    do {
      try handler.perform([request])
    } catch {
      print ("Unable to perform FaceRectangle request. Error: \(error)")
      return nil
    }
    return request.results
  }

  private func faceRects(for image: UIImage) -> [CGRect]? {
    guard let observations = detectFaces(for: image) else { return nil }
    return observations.map {
      let scaledBox = $0.boundingBox.scaleTo(image.size)
      return VNNormalizedRectForImageRect(scaledBox, Int(image.size.width), Int(image.size.height))
    }
  }
}

private extension CGRect {
  func scaleTo(_ destination: CGSize) -> CGRect {
    return CGRect(x: origin.x * destination.width,
                  y: (1 - origin.y - size.height) * destination.height,
                  width: size.width * destination.width,
                  height: size.height * destination.height)
  }

  func normalizeWith(_ destination: CGSize) -> CGRect {
    return CGRect(
      x: origin.x * destination.width,
      y: origin.y * destination.height,
      width: size.width * destination.width,
      height: size.height * destination.height)
  }
}

// Using CPU only enables running Vision tasks on the iOS simulator (during development).
#if targetEnvironment(simulator)
private extension VNDetectFaceRectanglesRequest {
  func enableSimulator() {
    if #available(iOS 17.0, *) {
      // Iterate over all compute devices to find the CPU device
      let allDevices = MLComputeDevice.allComputeDevices
      for device in allDevices {
        if case .cpu = device {
          setComputeDevice(device, for: .main)
          break
        }
      }
    } else {
      // For earlier iOS versions, fallback to using usesCPUOnly
      usesCPUOnly = true
    }
  }
}
#endif
