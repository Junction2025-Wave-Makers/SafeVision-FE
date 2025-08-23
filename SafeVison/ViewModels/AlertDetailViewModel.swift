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
    
    func loadVideo(byFileName name: String) {
       // 파일 이름과 확장자 분리
        let components = name.split(separator: ".").map(String.init)
        guard components.count == 2,
              let fileName = components.first,
              let fileExtension = components.last else {
            print("잘못된 파일 이름 형식입니다: \(name)")
            return
        }
        
        // 메인 번들에서 비디오 파일의 URL을 찾기
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("메인 번들에서 비디오 파일을 찾을 수 없습니다: \(name)")
            return
        }
        
        // 찾은 URL로 AVPlayer를 생성합니다.
        detectPlayer = AVPlayer(url: url)
    }
    
    
//    func loadVideo(from url: URL) {
//        detectPlayer = AVPlayer(url: url)
//    }
    
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
