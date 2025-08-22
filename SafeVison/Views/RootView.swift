//
//  RootView.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .home:
                        HomeView()
                        //                    case .profile(let userID):
                        //                        ProfileView(userID: userID)
                        //                    case .settings:
                        //                        SettingsView()
                        //                    }
                    }
                }
                .environmentObject(navigationManager)
        }
    }
}
