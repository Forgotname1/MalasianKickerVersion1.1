import SpriteKit

/// Управляет фоновыми изображениями:
/// - загружает фоны
/// - хранит индекс текущего
/// - переключает на следующий/предыдущий
/// - прячет/показывает правильный фон
class BackgroundManager {

    private(set) var backgrounds: [SKSpriteNode] = []
    private(set) var currentIndex: Int = 0

    /// Загружаем фоны по именам и добавляем на сцену
    func loadBackgrounds(names: [String], into scene: SKScene) {
        backgrounds.removeAll()
        currentIndex = 0

        for (i, name) in names.enumerated() {
            let bg = SKSpriteNode(imageNamed: name)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.position = CGPoint(x: 0, y: 0)
            bg.zPosition = -10

            // сохранить размер
            if let tex = bg.texture {
                bg.size = tex.size()
            }

            // показываем только первый фон
            bg.isHidden = (i != 0)

            scene.addChild(bg)
            backgrounds.append(bg)
        }
    }

    /// Переключить на следующий фон
    func nextBackground() {
        guard currentIndex < backgrounds.count - 1 else { return }

        backgrounds[currentIndex].isHidden = true
        currentIndex += 1
        backgrounds[currentIndex].isHidden = false
    }

    /// Переключить на предыдущий фон
    func previousBackground() {
        guard currentIndex > 0 else { return }

        backgrounds[currentIndex].isHidden = true
        currentIndex -= 1
        backgrounds[currentIndex].isHidden = false
    }
}
