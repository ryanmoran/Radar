import AppKit

extension NSColor {
  convenience init(_ status: String, highlight: CGFloat = 0) {
    var (red, green, blue): (CGFloat, CGFloat, CGFloat)

    switch status {
    case "paused":
      (red, green, blue) = (43, 132, 211)
    case "started":
      (red, green, blue) = (237, 185, 17)
    case "failed":
      (red, green, blue) = (223, 53, 46)
    case "pending":
      (red, green, blue) = (175, 182, 187)
    case "errored":
      (red, green, blue) = (222, 105, 28)
    case "aborted":
      (red, green, blue) = (122, 57, 35)
    case "succeeded":
      (red, green, blue) = (43, 197, 35)
    case "unknown":
      (red, green, blue) = (74, 89, 106)
    default:
      (red, green, blue) = (0, 0, 0)
    }

    (red, green, blue) = (CGFloat.minimum(red+highlight, 255), CGFloat.minimum(green+highlight, 255), CGFloat.minimum(blue+highlight, 255))

    self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
}
