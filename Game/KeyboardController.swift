//
//  KeyboardController.swift
//  MalaysionKicker_v1.1
//
//  Created by Илья Моторов on 30/11/2568 BE.
//

import SpriteKit

/// Класс отвечает за обработку клавиш:
/// - хранит состояние нажатых кнопок
/// - сообщает GameScene, куда хочет идти игрок
/// - не содержит логики движения!
class KeyboardController {

    // флаги направления (true когда клавиша зажата)
    var left = false
    var right = false
    var up = false
    var down = false

    // бег (Shift)
    var shift = false

    /// Обработка нажатия клавиши
    func keyDown(_ code: UInt16, flags: NSEvent.ModifierFlags) {

        // проверяем зажат ли Shift
        shift = flags.contains(.shift)

        switch code {
        case 123: left = true    // ←
        case 124: right = true   // →
        case 125: down = true    // ↓
        case 126: up = true      // ↑
        default: break
        }
    }

    /// Обработка отпускания клавиши
    func keyUp(_ code: UInt16) {
        switch code {
        case 123: left = false
        case 124: right = false
        case 125: down = false
        case 126: up = false
        default: break
        }

        // если отпущена любая стрелка — сбрасываем shift
        shift = false
    }
}
