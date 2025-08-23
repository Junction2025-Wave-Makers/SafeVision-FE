//
//  AlertDetailView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI
import AVKit


struct AlertDetailView: View {
    var alert: Alert
    
    var body: some View {
        VStack(spacing: 0) {
            
            title
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                backButton
            }
        }
    }
    
    
    private var backButton: some View {
        Button(
            action: {},
            label: {
                Image(systemName: "arrow.left")
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .background(
                        Circle()
                            .frame(width: 60, height: 60)
                            .background(Color(hex: "#EAECF4"))
                    )
            }
        )
    }
    
    private var title: some View {
        Text(alert.title)
            .font(.system(size: 32, weight: .semibold))
            .foregroundStyle(.black)
    }
    
}


#Preview (traits: .landscapeLeft){
    AlertDetailView(alert: Alert.mock)
}
