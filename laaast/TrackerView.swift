//
//  TrackerView.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import SwiftUI

struct TrackerView: View {
    @State private var touchEvents: [TouchEvent] = []
    @State private var currentTouchPosition: CGPoint?
    @State private var touchTimer: Timer?
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    self.currentTouchPosition = value.location
                                    if self.touchTimer == nil {
                                        self.startLogging()
                                    }
                                }
                                .onEnded { _ in
                                    self.stopLogging()
                                }
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    Text("Tap anywhere to start recording")
                        .foregroundColor(.gray)
                        .opacity(touchEvents.isEmpty ? 1 : 0) // Hide the text once recording starts
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            Button("Stop and Save Recording") {
                            saveRecording()
                        }
                        .padding()
                        .background(touchEvents.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .disabled(touchEvents.isEmpty)
        }
    }
    
    private func startLogging() {
        touchTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            if let position = self.currentTouchPosition {
                let event = TouchEvent(timestamp: Date(), position: position)
                self.touchEvents.append(event)
            }
        }
    }
    
    private func stopLogging() {
        touchTimer?.invalidate()
        touchTimer = nil
        currentTouchPosition = nil
    }
    
    private func saveRecording() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let recordingID = dateFormatter.string(from: Date())
        
        if let encodedData = try? JSONEncoder().encode(touchEvents) {
            var recordings = UserDefaults.standard.dictionary(forKey: "savedRecordings") as? [String: Data] ?? [:]
            recordings[recordingID] = encodedData
            UserDefaults.standard.set(recordings, forKey: "savedRecordings")
        }
        touchEvents = []  // Clear current events after saving
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
    }
}

