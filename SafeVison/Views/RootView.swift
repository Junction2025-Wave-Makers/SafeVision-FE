//
//  RootView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView(vm: homeViewModel)
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .home:
                        HomeView(vm: homeViewModel)
                    case .detail(let alert):
                        AlertDetailView(alert: alert)
                        //                    case .profile(let userID):
                        //                        ProfileView(userID: userID)
                        //                    case .settings:
                        //                        SettingsView()
                        //                    }
                    }
                }
        }
        .environmentObject(navigationManager)
    }
}
