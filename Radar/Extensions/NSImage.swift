import AppKit

public extension NSImage {
  public func rotatedBy(degrees: CGFloat) -> NSImage {
    var imageBounds = NSZeroRect
    imageBounds.size = size

    let pathBounds = NSBezierPath(rect: imageBounds)
    var transform = NSAffineTransform()

    transform.rotate(byDegrees: degrees)
    pathBounds.transform(using: transform as AffineTransform)

    let rotatedBounds:NSRect = NSMakeRect(NSZeroPoint.x, NSZeroPoint.y , size.width, size.height )
    let rotatedImage = NSImage(size: rotatedBounds.size)
    rotatedImage.isTemplate = true

    //Center the image within the rotated bounds
    imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2)
    imageBounds.origin.y  = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2)

    // Start a new transform
    transform = NSAffineTransform()
    // Move coordinate system to the center (since we want to rotate around the center)
    transform.translateX(by: +(NSWidth(rotatedBounds) / 2 ), yBy: +(NSHeight(rotatedBounds) / 2))
    transform.rotate(byDegrees: degrees)
    // Move the coordinate system back to normal
    transform.translateX(by: -(NSWidth(rotatedBounds) / 2 ), yBy: -(NSHeight(rotatedBounds) / 2))
    // Draw the original image, rotated, into the new image
    rotatedImage.lockFocus()
    transform.concat()
    draw(in: imageBounds, from: NSZeroRect, operation: .copy, fraction: 1.0)
    rotatedImage.unlockFocus()

    return rotatedImage
  }
}

// MARK: - NSImage.init(status: String)
extension NSImage {
  convenience init(status: String, transientStatus: String) {
    self.init(size: NSMakeSize(16, 16), flipped: false, drawingHandler: { bounds in
      guard let context = NSGraphicsContext.current?.cgContext else { return false }

      let rect = bounds.insetBy(dx: 3, dy: 3)
      context.setFillColor(NSColor(status).cgColor)
      context.setStrokeColor(NSColor(transientStatus, highlight: 20).cgColor)
      context.setLineWidth(3)

      context.fillEllipse(in: rect)
      context.strokeEllipse(in: rect)

      return true
    })
  }
}
