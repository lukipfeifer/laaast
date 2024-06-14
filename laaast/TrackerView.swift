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
            TouchCurveView(touchEvents: touchEvents, maxWidth: UIScreen.main.bounds.width, maxHeight: 200, yScaleFactor: 0.5)  // Adjust yScaleFactor as needed
                .padding()
            
            GeometryReader { geometry in
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
            }
            .edgesIgnoringSafeArea(.all)
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
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
    }
}

