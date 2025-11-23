//
//  ContentView.swift
//  AppThemeExample
//
//  Created by alex on 23/11/25.
//

import SwiftUI
import AppThemeUI

struct ContentView: View {
    
    @AppStorage("AppThemeStyle") private var appThemeStyle: AppThemeStyle = .systemDefault
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Spacer()
            changeThemeView
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    @ViewBuilder var changeThemeView: some View {
        Menu {
            Button {
                appThemeStyle = .systemDefault
            } label: {
                Text("System default")
            }
            
            Button {
                appThemeStyle = .light
            } label: {
                Text("Light mode")
            }
            
            Button {
                appThemeStyle = .dark
            } label: {
                Text("Dark mode")
            }

        } label: {
            currentThemeLabelView
        }
    }
    
    @ViewBuilder var currentThemeLabelView: some View {
        switch appThemeStyle {
        case .light:
            Text("Light Mode")
        case .dark:
            Text("Dark Mode")
        case .systemDefault:
            Text("System Default")
        }
    }
}

#Preview {
    ContentView()
}
