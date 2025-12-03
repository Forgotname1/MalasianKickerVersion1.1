//
//  Player.swift
//  MalaysionKicker_v1.1
//
//  Created by Илья Моторов on 30/11/2568 BE.
//
import SpriteKit

/// Класс отвечает ЗА ВСЁ, что связано с персонажем:
/// - загрузка анимации из атласа
/// - idle-текстура (кадр, когда не двигается)
/// - движение в стороны / вверх / вниз
/// - зеркаливание
/// - масштабирование
/// - запуск/остановка анимации ходьбы
class Player: SKSpriteNode {
    
    // MARK: - Анимации
    /// Все кадры анимации ходьбы
    private var walkFrames: [SKTexture] = []
    
    /// SKAction, которая проигрывается в цикле, когда персонаж идёт
    private var walkAnimation: SKAction!
    
    /// Стартовый (первый) кадр — нужен, чтобы вернуть персонажа в idle
    private(set) var idleTexture: SKTexture!

    // MARK: - Параметры движения
    /// Скорость передвижения игрока (чем больше — тем быстрее)
    var moveSpeed: CGFloat = 9
    // MARK: - Скорости движения
    var walkSpeed: CGFloat = 6          // обычная скорость
    var runSpeed: CGFloat = 12          // скорость бега
    var currentSpeed: CGFloat = 6       // активная скорость

    // MARK: - Инициализация персонажа
    /// Инициализатор отвечает за:
    /// - загрузку атласа Player
    /// - сортировку кадров
    /// - создание стартовой текстуры
    /// - создание анимации ходьбы
    /// - масштаб персонажа
    init() {
        let atlas = SKTextureAtlas(named: "Player")
        
        // сортировка кадров по числам (walk_01, walk_02, walk_03…)
        let frames = atlas.textureNames
            .sorted { a, b in
                let na = Int(a.replacingOccurrences(of: "walk_", with: "").replacingOccurrences(of: ".png", with: "")) ?? 0
                let nb = Int(b.replacingOccurrences(of: "walk_", with: "").replacingOccurrences(of: ".png", with: "")) ?? 0
                return na < nb
            }
            .map { atlas.textureNamed($0) }

        idleTexture = frames.first!
        walkFrames = frames

        super.init(texture: idleTexture,
                   color: .clear,
                   size: idleTexture.size())

        self.zPosition = 100

        // уменьшаем спрайт (в 4 раза)
        self.setScale(0.25)

        // создаём повторяющуюся анимацию
        walkAnimation = SKAction.repeatForever(
            SKAction.animate(with: walkFrames, timePerFrame: 0.08)
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Анимация
    /// Запускает анимацию ходьбы, если она ещё не запущена
    func startWalkAnimation() {
        if self.action(forKey: "walk") == nil {
            self.run(walkAnimation, withKey: "walk")
        }
    }

    /// Останавливает анимацию и ставит idle кадр
    func stopWalkAnimation() {
        self.removeAction(forKey: "walk")
        self.texture = idleTexture
    }
    // включить беговую анимацию (быстрее)
    func startRunAnimation() {
        let runAction = SKAction.repeatForever(
            SKAction.animate(with: walkFrames, timePerFrame: 0.07)
        )
        self.run(runAction, withKey: "walk")
    }
    // MARK: - Реальные движения персонажа
    /// Движение влево с зеркалированием
    func moveLeft() {
        self.xScale = -abs(self.xScale)
        self.position.x -= currentSpeed
    }

    func moveRight() {
        self.xScale = abs(self.xScale)
        self.position.x += currentSpeed
    }

    func moveUp() {
        self.position.y += currentSpeed
    }

    func moveDown() {
        self.position.y -= currentSpeed
    }
}
