import Cocoa

class KeyboardController {

    // MARK: - Key states
    var left = false
    var right = false
    var up = false
    var down = false
    var shift = false
    var ePressed = false      // ← ДОБАВИЛИ ЭТО!


    // MARK: - Key codes
    enum KeyCode {
        static let left: UInt16  = 123
        static let right: UInt16 = 124
        static let down: UInt16  = 125
        static let up: UInt16    = 126
        static let shift: UInt16 = 56
        static let e: UInt16     = 14   // ← ДОБАВИЛИ ЭТО!
    }


    // MARK: - Key Down
    func keyDown(_ code: UInt16, flags: NSEvent.ModifierFlags) {

        if code == KeyCode.left  { left  = true }
        if code == KeyCode.right { right = true }
        if code == KeyCode.up    { up    = true }
        if code == KeyCode.down  { down  = true }
        if code == KeyCode.e     { ePressed = true }    // ← ДОБАВЛЕНО

        shift = flags.contains(.shift)
    }


    // MARK: - Key Up
    func keyUp(_ code: UInt16) {

        if code == KeyCode.left  { left  = false }
        if code == KeyCode.right { right = false }
        if code == KeyCode.up    { up    = false }
        if code == KeyCode.down  { down  = false }
        if code == KeyCode.e     { ePressed = false }   // ← ДОБАВЛЕНО
    }
}
