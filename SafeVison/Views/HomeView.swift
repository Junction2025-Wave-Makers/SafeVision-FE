//
//  HomeView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        
        VStack(spacing: 0) {
            
            header
            
            
            
            alertSection
                
            
            Spacer()
        }
        .background(Color.mainBackground.ignoresSafeArea())
        
    }
    
    
    private var logo: some View {
        Text("Safe Vision")
            .font(.system(size: 22, weight: .medium))
    }
    
    private var companyLogo: some View {
        Text("HYUNDAI E&C")
            .font(.system(size: 20, weight: .semibold))
    }
    
    private var constructionLocation: some View {
        Text("Pohang-si Dongbin Cultural Platform\nNew Building Construction")
            .font(.system(size: 38, weight: .bold))
    }
    
    private var address: some View {
        HStack(spacing: 6) {
            Image("BiCurrentLocation")
                .resizable()
                .frame(width: 24, height: 24)
            
            Text("78, Seonchak-ro, Buk-gu, Pohang-si, Gyeongsangbuk-do, Republic of Korea")
            
        }
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            
            logo
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 25)
            
            companyLogo
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 4)
            
            constructionLocation
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 25)
            
            address
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(width: .infinity)
        .appPadding()
        .padding(.top, 43)
        .padding(.bottom, 49)
        .background(Color.white)
    }
    
    
    
    private var alertSectionHeader: some View {
        HStack(spacing: 0) {
            
            Text("Alerts")
                .font(.system(size: 26, weight: .semibold))
            
            
            Button(
                action: {},
                label: {
                    Text("Unconfirmed")
                }
            )
            .buttonStyle(AlertsButtonStyle())
            
            Button(
                action: {},
                label: {
                    Text("In Progress")
                }
            )
            .buttonStyle(AlertsButtonStyle())
            
            Button(
                action: {},
                label: {
                    Text("Resolved")
                }
            )
            .buttonStyle(AlertsButtonStyle())
            
            
        }
    }
    
    
    
    
    
    private var alertSection: some View {
        VStack(spacing: 0) {
            alertSectionHeader
        }
    }
    
}





struct AlertsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18))
            .foregroundColor(Color.textGray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.white)
            .cornerRadius(32)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}



#Preview("Landscape Preview", traits: .landscapeLeft) {
    HomeView()
}
