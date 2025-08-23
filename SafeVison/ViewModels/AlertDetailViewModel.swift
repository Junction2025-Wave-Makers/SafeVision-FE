//
//  AlertDetailViewModel.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI
import AVKit

class AlertDetailViewModel: ObservableObject {
    @Published var detectPlayer: AVPlayer? = nil
    @Published var streamPlayer: AVPlayer? = nil
    
    func loadVideo(from url: URL) {
        detectPlayer = AVPlayer(url: url)
    }
    
//    func loadVideo(from data: Data) {
//        let tempDir = FileManager.default.temporaryDirectory
//        let fileURL = tempDir.appendingPathComponent("tempVideo.mp4")
//        do {
//            try data.write(to: fileURL)
//            player = AVPlayer(url: fileURL)
//        } catch {
//            print("Error saving temp video:", error)
//        }
//    }
    
    func play() {
        detectPlayer?.play()
    }
    
    func pause() {
        detectPlayer?.pause()
    }
}
