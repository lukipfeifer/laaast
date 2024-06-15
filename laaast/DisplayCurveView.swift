//
//  DisplayCurveView.swift
//  laaast
//
//  Created by Matthias Meissen on 15.06.24.
//

import SwiftUI

struct DisplayCurveView: View {
    @State private var touchEvents: [TouchEvent] = []
    
    var body: some View {
        VStack {
            TouchCurveView(touchEvents: touchEvents, maxWidth: UIScreen.main.bounds.width, maxHeight: 200, yScaleFactor: 0.5)
                .padding()
                .onAppear {
                    loadTouchEvents()
                }
        }
    }
    
    private func loadTouchEvents() {
        // Implement loading functionality, e.g., from a file or user defaults
        // Example using UserDefaults:
        if let savedData = UserDefaults.standard.data(forKey: "savedTouchEvents"),
           let loadedEvents = try? JSONDecoder().decode([TouchEvent].self, from: savedData) {
            self.touchEvents = loadedEvents
        }
    }
}

struct DisplayCurveView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayCurveView()
    }
}

