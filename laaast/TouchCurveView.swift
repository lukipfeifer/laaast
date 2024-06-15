//
//  TouchCurveView.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import SwiftUI

struct TouchCurveView: View {
    var touchEvents: [TouchEvent]
    var maxWidth: CGFloat
    var maxHeight: CGFloat
    var yScaleFactor: CGFloat = 0.5  // Adjust this value to scale down the y-values
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Path { path in
                        // Ensure there is at least one touch event
                        guard let firstEvent = touchEvents.first else { return }
                        
                        // Start the path at the first touch event position
                        let startX = CGFloat(0)
                        let startY = mapToYPosition(event: firstEvent, in: geometry.size)
                        path.move(to: CGPoint(x: startX, y: startY))
                        
                        // Add lines to the path for each touch event
                        for (_, event) in touchEvents.enumerated() {
                            let xPosition = mapToXPosition(event: event, in: geometry.size, firstEvent: firstEvent)
                            let yPosition = mapToYPosition(event: event, in: geometry.size)
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)  // Draw the path with a blue stroke
                    
                    // Time labels
                    if let firstEvent = touchEvents.first, let lastEvent = touchEvents.last {
                        let totalDuration = lastEvent.timestamp.timeIntervalSince(firstEvent.timestamp)
                        let numberOfLabels = 5  // Change as needed
                        let interval = totalDuration / Double(numberOfLabels)
                        
                        ForEach(0...numberOfLabels, id: \.self) { i in
                            let time = firstEvent.timestamp.addingTimeInterval(interval * Double(i))
                            let xPosition = mapToXPosition(time: time, firstEvent: firstEvent, lastEvent: lastEvent, in: geometry.size)
                            Text(String(format: "%.f", interval * Double(i)))
                                .font(.caption)
                                .padding(.top, 20)
                                .position(x: xPosition, y: geometry.size.height - 10)
                        }
                    }
                }
            }
            .frame(height: maxHeight)
        }
    }
    
    private func mapToXPosition(event: TouchEvent, in size: CGSize, firstEvent: TouchEvent) -> CGFloat {
        // Map the time difference to the x position based on the total width
        let totalTime = touchEvents.last?.timestamp.timeIntervalSince(firstEvent.timestamp) ?? 1
        let eventTime = event.timestamp.timeIntervalSince(firstEvent.timestamp)
        return CGFloat(eventTime / totalTime) * size.width
    }
    
    private func mapToXPosition(time: Date, firstEvent: TouchEvent, lastEvent: TouchEvent, in size: CGSize) -> CGFloat {
        // Map the time to the x position based on the total width
        let totalTime = lastEvent.timestamp.timeIntervalSince(firstEvent.timestamp)
        let eventTime = time.timeIntervalSince(firstEvent.timestamp)
        return CGFloat(eventTime / totalTime) * size.width
    }
    
    private func mapToYPosition(event: TouchEvent, in size: CGSize) -> CGFloat {
        // Scale down the y position using the yScaleFactor
        let scaledY = event.position.y * yScaleFactor
        // Ensure the y position is within the bounds of the view height
        let normalizedY = min(max(scaledY, 0), maxHeight)
        return size.height - (normalizedY / maxHeight * size.height)
    }
}

struct TouchCurveView_Previews: PreviewProvider {
    static var previews: some View {
        TouchCurveView(touchEvents: [
            TouchEvent(timestamp: Date(), position: CGPoint(x: 0, y: 100)),
            TouchEvent(timestamp: Date().addingTimeInterval(1), position: CGPoint(x: 50, y: 200)),
            TouchEvent(timestamp: Date().addingTimeInterval(2), position: CGPoint(x: 100, y: 150)),
            TouchEvent(timestamp: Date().addingTimeInterval(3), position: CGPoint(x: 150, y: 250)),
            TouchEvent(timestamp: Date().addingTimeInterval(4), position: CGPoint(x: 200, y: 50))
        ], maxWidth: 300, maxHeight: 400)
    }
}

