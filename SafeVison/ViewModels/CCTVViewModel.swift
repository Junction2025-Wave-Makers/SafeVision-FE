//
//  CCTVViewModel.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//


import SwiftUI
import AVKit

class CCTVViewModel: ObservableObject {
    @Published var videos: [URL] = []
    
    
    private let videoFiles = ["cctv1.mp4", "cctv2.mp4", "cctv3.mp4", "cctv4.mp4"]
    
    func loadVideos() {
        var loadedURLs: [URL] = []
        
        for name in videoFiles {
            let components = name.split(separator: ".").map(String.init)
            guard components.count == 2,
                  let fileName = components.first,
                  let fileExtension = components.last else {
                print("Invalid video file name format: \(name)")
                continue
            }
            
           
            if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
                loadedURLs.append(url)
            } else {
                print("Video file not found in main bundle: \(name)")
            }
        }
        
        self.videos = loadedURLs
    }
}
