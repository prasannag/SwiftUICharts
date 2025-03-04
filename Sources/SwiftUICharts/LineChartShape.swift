//
//  SwiftUIView.swift
//  
//
//  Created by Majid Jabrayilov on 24.09.20.
//
import SwiftUI

struct LineChartShape: Shape {
    let dataPoints: [DataPoint]
    var closePath: Bool = true

    func path(in rect: CGRect) -> Path {
        Path { path in
            let start = CGFloat(dataPoints.first?.endValue ?? 0) / CGFloat(dataPoints.max()?.endValue ?? 1)
            path.move(to: CGPoint(x: 0, y: rect.height - rect.height * start))
            let stepX = rect.width / CGFloat(dataPoints.count)
            var currentX: CGFloat = 0
            var prevPoint = CGPoint(x: 0, y: 0)
            dataPoints.forEach {
                currentX += stepX
                let y = CGFloat($0.endValue / (dataPoints.max()?.endValue ?? 1)) * rect.height
                let point = CGPoint(x: currentX, y: rect.height - y)
                let curvature: CGFloat = 8
                let increasingControlPoint = CGPoint(x: currentX - curvature, y: point.y - curvature)
                let decreasingCotrolPoint = CGPoint(x: currentX + curvature, y: point.y + curvature)
                
                if prevPoint.y > point.y {
                    path.addQuadCurve(to: point, control: increasingControlPoint)
                } else if prevPoint.y < point.y {
                    path.addQuadCurve(to: point, control: decreasingCotrolPoint)
                } else {
                    path.addLine(to: point)
                }
                prevPoint = point
            }

            if closePath {
                path.addLine(to: CGPoint(x: currentX, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.closeSubpath()
            }
        }
    }
}

#if DEBUG
struct LineChartShape_Previews: PreviewProvider {
    static var previews: some View {
        LineChartShape(dataPoints: DataPoint.mock, closePath: true)
    }
}
#endif
