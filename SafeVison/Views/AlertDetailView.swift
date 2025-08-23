//
//  AlertDetailView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI
import AVKit


struct AlertDetailView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    var alert: Alert
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            title
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
                    .padding(.horizontal, 36)
                    .padding(.top, 36)
            }
        }
    }
    
    
    private var backButton: some View {
        Button(
            action: {
                navigationManager.pop()
            },
            label: {
                Image(systemName: "arrow.left")
                    .background(
                        Circle()
                            .fill(Color(hex: "#EAECF4"))
                            .frame(width: 60, height: 60)
                    )
                    .foregroundColor(.black)
            }
        )
    }
    
    private var title: some View {
        Text(alert.title)
            .font(.system(size: 32, weight: .semibold))
            .foregroundStyle(.black)
    }
    
    
    private var detectVideoView: some View {
        
    }
    
}


#Preview (traits: .landscapeLeft){
    AlertDetailView(alert: Alert.mock)
        .environmentObject(NavigationManager())
}
