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
