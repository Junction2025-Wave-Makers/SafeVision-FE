//
//  CCTVView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI
import AVKit

struct CCTVView: View {
    var body: some View {
        
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<3, id: \.self) { row in
                GridRow{
                    ForEach(0..<3, id: \.self) { col in
                        let index = row * 3 + col
                        
                        // TODO: 준비한 영상 삽입
//                        if videos.indices.contains(index) {
//                            let player = AVPlayer(url: videos[index])
//                            
//                            VideoPlayer(player: player)
//                                .onAppear {
//                                    player.isMuted = true
//                                    player.play()
//                                }
//                        }
                        
                    }
                }
            }
        }
        .ignoresSafeArea() // 화면 전체를 사용하도록 Safe Area를 무시합니다.
        .background(.black) // 영상 사이의 간격을 검은색으로 채웁니다.
        
    }
    
}


#Preview {
    CCTVView()
}
