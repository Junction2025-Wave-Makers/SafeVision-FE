//
//  CCTVView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI
import AVKit

struct CCTVView: View {
    
    @StateObject var vm: CCTVViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
    
            ForEach(0..<2, id: \.self) { row in
                GridRow {
                    ForEach(0..<2, id: \.self) { col in
                        
                        let index = row * 2 + col
                        
                        if vm.videos.indices.contains(index) {
                            let player = AVPlayer(url: vm.videos[index])
                            
                            VideoPlayer(player: player)
                                .onAppear {
                                    player.isMuted = true
                                    player.play()
                                }
                        } else {
                           
                            Rectangle()
                                .fill(Color.gray)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .background(.black)
        .onAppear {
            
            vm.loadVideos()
        }
    }
}


#Preview {
    CCTVView(vm: CCTVViewModel())
        .environmentObject(NavigationManager())
}
