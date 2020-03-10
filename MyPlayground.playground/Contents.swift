import UIKit

let numberFormatter = NumberFormatter()
numberFormatter.minimumIntegerDigits = 2

let seconds = 123456.78
let totalMinutes = Int(seconds / 60)
let hours = totalMinutes / 60
let m = totalMinutes % 60

print(numberFormatter.string(from: NSNumber(value: m)))
