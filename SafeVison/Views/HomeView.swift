//
//  HomeView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                header
                    .padding(.bottom, 42)
               
                HStack(alignment: .top, spacing: 40) {
                    alertsSection
                    
                    
                    
                    alertSettingSection
                }
                .appPadding()
                
                
                Spacer()
            }
            .background(Color.mainBackground.ignoresSafeArea())
        }
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
        .frame(maxWidth: .infinity)
        .appPadding()
        .padding(.top, 43)
        .padding(.bottom, 49)
        .background(Color.white)
    }
    
    
    
    private var alertsSectionHeader: some View {
        HStack(spacing: 8) {
            
            Text("Alerts")
                .font(.system(size: 26, weight: .semibold))
           
            Spacer()
            
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
    
    
    
    private func dangerStatusBar(danger: String) -> some View {
        var numberOfBars: Int
        var barColor: Color
        
        switch danger {
        case "critical":
            numberOfBars = 4
            barColor = .red
        case "high":
            numberOfBars = 3
            barColor = .orange
        case "medium":
            numberOfBars = 2
            barColor = .yellow
        case "low":
            numberOfBars = 1
            barColor = .green
        default:
            numberOfBars = 0
            barColor = .clear
        }
        
        return HStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { bar in
                Rectangle()
                    .frame(width: 12, height: 36)
                    .background(bar < numberOfBars ? barColor : Color(hex: "#D9D9D9"))
                    .cornerRadius(3)
            }
        }
    }
    
    private func makeAlertCard(alert: Alert) -> some View {
            
            HStack(spacing: 0){
                VStack(spacing: 0) {
                    
                    Text(alert.title)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                    
                    Text(alert.date)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 28)
                    
                    Text(alert.status)
                        .font(.system(size: 18))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(hex: "#F2F2F2"))
                        .cornerRadius(32)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                    
                
                dangerStatusBar(danger: alert.dangerLevel)
                
            
        }
        .padding(.leading, 24)
        .padding(.trailing, 40)
        .padding(.top, 20)
        .padding(.bottom, 24)
        .background(.white)
        .cornerRadius(8)
        
    }
    
    
    
    
    private var alertsSection: some View {
        VStack(spacing: 0) {
            alertsSectionHeader
                .padding(.bottom, 16)
            
            ForEach( vm.alerts ) { alert in
                makeAlertCard(alert: alert)
                    .padding(.bottom, 16)
            }
        }
    }
    
    
    
    private var rulePreview: some View {
        VStack(spacing: 0) {
            Text("test")
            Text("test")
            Text("test")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 28)
        .background(.white)
        .cornerRadius(8)
    }
    
    
    private var alertSettingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 0) {
                Text("Alerts Settings")
                    .font(.system(size: 26, weight: .semibold))
                
                Spacer()
                
                Button(
                    action: {},
                    label: {
                        Image("arrow")
                            .frame(width: 20, height: 20)
                    }
                )
            }
            .padding(.bottom, 20)
            
            rulePreview
                .padding(.bottom, 20)
            
            Button(
                action: {},
                label: {
                    Text("View CCTV")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
            )
            .padding(.horizontal, 143)
            .padding(.vertical, 43)
            .background(Color.primary)
            .cornerRadius(8)
            
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
    HomeView(vm: HomeViewModel())
}
