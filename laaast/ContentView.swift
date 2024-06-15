//
//  ContentView.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WelcomeView()
                .tabItem {Label("Home", systemImage: "house")}
            TrackerView()
                .tabItem({Label("Tracker", systemImage: "figure.strengthtraining.functional")})
            DisplayCurveView()
                .tabItem({Label("Recordings", systemImage: "record.circle")})
            WelcomeView()
                .tabItem {Label("Settings", systemImage: "gearshape")}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
