//
//  CGRect.swift
//  Collection
//
//  Created by Dave Coleman on 9/12/2024.
//

import SwiftUI

public extension CGRect {
  var path: Path {
    Path(self)
  }
  
  
  func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {
    
    let width: String = "\(self.width.toDecimal(decimalPlaces))"
    let height: String = "\(self.height.toDecimal(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(width) x \(height)"
        
      case .initials:
        return "W \(width)  H \(height)"
        
      case .full:
        return "Width \(width)  Height \(height)"
    }
  }
  
  // Corner points
  var topLeft: CGPoint {
    CGPoint(x: minX, y: minY)
  }
  
  var topRight: CGPoint {
    CGPoint(x: maxX, y: minY)
  }
  
  var bottomLeft: CGPoint {
    CGPoint(x: minX, y: maxY)
  }
  
  var bottomRight: CGPoint {
    CGPoint(x: maxX, y: maxY)
  }
  
  var center: CGPoint {
    CGPoint(x: midX, y: midY)
  }
  
  // Edges
  var leftEdge: CGFloat { minX }
  var rightEdge: CGFloat { maxX }
  var topEdge: CGFloat { minY }
  var bottomEdge: CGFloat { maxY }
  
  // Dimensions
  var horizontal: ClosedRange<CGFloat> { minX...maxX }
  var vertical: ClosedRange<CGFloat> { minY...maxY }
  
  // Initialization helpers
  static func between(point1: CGPoint, point2: CGPoint) -> CGRect {
    let minX = min(point1.x, point2.x)
    let minY = min(point1.y, point2.y)
    let maxX = max(point1.x, point2.x)
    let maxY = max(point1.y, point2.y)
    
    return CGRect(
      x: minX,
      y: minY,
      width: maxX - minX,
      height: maxY - minY
    )
  }
  
  // Useful for selection operations
  func expanded(toInclude rect: CGRect) -> CGRect {
    let newMinX = min(minX, rect.minX)
    let newMinY = min(minY, rect.minY)
    let newMaxX = max(maxX, rect.maxX)
    let newMaxY = max(maxY, rect.maxY)
    
    return CGRect(
      x: newMinX,
      y: newMinY,
      width: newMaxX - newMinX,
      height: newMaxY - newMinY
    )
  }
}
