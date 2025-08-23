//
//  HomeView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI
import UIKit

private struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        let next = nextValue()
        if next != .zero { value = next }
    }
}

private extension View {
    func readFrame(in space: CoordinateSpace = .global, onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: RectPreferenceKey.self, value: geo.frame(in: space))
            }
        )
        .onPreferenceChange(RectPreferenceKey.self, perform: onChange)
    }
}

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var showDetectSheet: Bool = false
    @State private var alertSectionFrame: CGRect = .zero
    @State private var containerSize: CGSize = .zero
    @StateObject private var detectVM = DetectConditionViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    
                    header
                        .padding(.bottom, 42)
                    
                    HStack(alignment: .top, spacing: 40) {
                        alertsSection
                        alertSettingSection
                            .readFrame(in: .global) { rect in
                                alertSectionFrame = rect
                            }
                    }
                    .appPadding()
                    
                    Spacer()
                }
                .background(Color.mainBackground.ignoresSafeArea())
                .onAppear {
                    vm.fetchMockAlerts()
                    containerSize = size
                }
                .onChange(of: size) { _, new in
                    containerSize = new
                }
                
                // Overlay modal (custom, not system sheet)
                if showDetectSheet {
                    // Dimmed scrim that does not move layout
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation(.easeOut(duration: 0.2)) { showDetectSheet = false } }
                    
                    // Constrained modal sized to ~3/5 of the page height, width aligned to alert settings section
                    let modalWidth = alertSectionFrame.width
                    let modalHeight = UIScreen.main.bounds.height * 0.7
                    
                    DetectConditionSheet(vm: detectVM, onClose: { withAnimation(.easeOut(duration: 0.2)) { showDetectSheet = false } })
                        .frame(width: modalWidth, height: modalHeight, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(radius: 12)
                        )
                        // Position to match the alert settings section's origin
                        .offset(x: alertSectionFrame.minX, y: alertSectionFrame.minY - modalHeight/2)
                        .transition(.scale(scale: 0.98).combined(with: .opacity))
                }
            }
            .coordinateSpace(name: "container")
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    
    private var logo: some View {
        Image("logo-image")
    }
    
    private var companyLogo: some View {
        Text("HYUNDAI E&C")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
    }
    
    private var constructionLocation: some View {
        Text("Pohang-si Dongbin Cultural Platform\nNew Building Construction")
            .font(.system(size: 38, weight: .bold))
            .foregroundStyle(.white)
    }
    
    private var address: some View {
        HStack(spacing: 6) {
            Image("BiCurrentLocation")
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(hex: "#9D9D9D"))
            
            Text("78, Seonchak-ro, Buk-gu, Pohang-si, Gyeongsangbuk-do, Republic of Korea")
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "#9D9D9D"))
            
            
        }
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            // 이 VStack에 패딩을 적용하여, 그라데이션이 패딩 영역까지 덮도록 합니다.
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
        .background {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#0E0E0E"), location: 0.0),
                        .init(color: Color(hex: "#252468"), location: 0.85),
                        .init(color: Color(hex: "#252468"), location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                EllipticalGradient(
                    stops: [
                        .init(color: Color(hex: "#252468"), location: 0.0),
                        .init(color: Color(hex: "#252468").opacity(0), location: 1.0)
                    ],
                    center: .bottomTrailing
                )
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
    
    
    
    private var alertsSectionHeader: some View {
        HStack(spacing: 8) {
            
            Button(
                action: {},
                label: {
                    Text("All Alerts")
                }
            )
            .buttonStyle(AlertsButtonStyle())
            
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
        var text: String
        
        switch danger {
        case "critical":
            numberOfBars = 4
            barColor = Color(hex: "#F94C4C")
            text = "Critical"
        case "high":
            numberOfBars = 3
            barColor = Color(hex: "#FF9945")
            text = "High"
        case "medium":
            numberOfBars = 2
            barColor = Color(hex: "#FFD651")
            text = "Medium"
        case "low":
            numberOfBars = 1
            barColor = Color(hex: "#5AEE7F")
            text = "Low"
        default:
            numberOfBars = 0
            barColor = .clear
            text = ""
        }
        
        return VStack(spacing: 4) {
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { bar in
                    Rectangle()
                        .fill(bar < numberOfBars ? barColor : Color(hex: "#D9D9D9"))
                        .frame(width: 12, height: 36)
                        .cornerRadius(3)
                }
            }
            
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(barColor)
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
                    .foregroundStyle(alert.status == "Unconfirmed" ? .white : .black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(alert.status == "Unconfirmed" ? .black : Color(hex: "#F2F2F2"))
                    .cornerRadius(32)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(
                                alert.status == "Unconfirmed" ? .clear : .black, // 상태에 따라 테두리 색상 결정
                                lineWidth: 1
                            )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            
            dangerStatusBar(danger: alert.dangerLevel)
            
            
        }
        .frame(minWidth: 640)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            ScrollView(showsIndicators: false) {
                ForEach( vm.alerts ) { alert in
                    makeAlertCard(alert: alert)
                        .padding(.bottom, 16)
                        .onTapGesture {
                            navigationManager.push(.detail(alert: alert))
                        }
                }
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
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) { showDetectSheet = true }
                }) {
                    Image("arrow")
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.bottom, 20)
            
            rulePreview
                .padding(.bottom, 20)
            
            Button(
                action: {
                    navigationManager.push(.cctv)
                },
                label: {
                    
                    HStack(spacing: 8) {
                        
                        Image("cam")
                            .frame(width: 20, height: 20)
                        
                        Text("View CCTV")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 43)
            .background {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(hex: "#0E0E0E"), location: 0.0),
                            .init(color: Color(hex: "#0E0E0E"), location: 0.97),
                            .init(color: Color(hex: "#252468"), location: 1.0)
                        ]),
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                    
                    EllipticalGradient(
                        stops: [
                            .init(color: Color(hex: "#252468"), location: 0.0),
                            .init(color: Color(hex: "#252468").opacity(0), location: 1.0)
                        ],
                        center: .bottomLeading
                    )
                }
            }
            .cornerRadius(8)
            
        }
    }
    
    
}





struct AlertsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18))
            .foregroundColor(configuration.isPressed ? Color.white : Color.textGray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(configuration.isPressed ? Color.primary : Color.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}



#Preview("Landscape Preview", traits: .landscapeLeft) {
    HomeView(vm: HomeViewModel())
        .environmentObject(NavigationManager())
}
