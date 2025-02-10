//
//  VisionService.swift
//  SOProfiles
//
//  Created by Galia Kaufman on 2/10/25.
//

import Vision
import UIKit

class VisionService {
  static let shared = VisionService()

  func detectFaces(for image: UIImage) -> [VNFaceObservation]? {
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
