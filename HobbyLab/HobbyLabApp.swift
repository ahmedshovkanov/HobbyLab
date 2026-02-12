//
//  ArctiLabApp.swift
//  ArctiLab
//
//  Created by John Sorren on 03.02.2026.
//

import SwiftUI

@main
struct ArctiLabApp: App {
    @StateObject private var viewModel = HobbyViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
                    .environmentObject(viewModel)
            }
        }
    }
}
