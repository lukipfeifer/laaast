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
        GeometryReader { geometry in
            Path { path in
                // Ensure there is at least one touch event
                guard let firstEvent = touchEvents.first else { return }
                
                // Start the path at the first touch event position
                let startX = CGFloat(0)
                let startY = mapToYPosition(event: firstEvent, in: geometry.size)
                path.move(to: CGPoint(x: startX, y: startY))
                
                // Add lines to the path for each touch event
                for (index, event) in touchEvents.enumerated() {
                    let xPosition = mapToXPosition(index: index, in: geometry.size)
                    let yPosition = mapToYPosition(event: event, in: geometry.size)
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(Color.blue, lineWidth: 2)  // Draw the path with a blue stroke
        }
        .frame(height: maxHeight)
    }
    
    private func mapToXPosition(index: Int, in size: CGSize) -> CGFloat {
        // Map the index to the x position based on the total width
        let stepX = size.width / CGFloat(touchEvents.count - 1)
        return CGFloat(index) * stepX
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
        TouchCurveView(touchEvents: [TouchEvent(timestamp: Date(), position: CGPoint(x: 100, y: 200))], maxWidth: 300, maxHeight: 400)
    }
}
