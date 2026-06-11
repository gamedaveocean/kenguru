# 🦘 Запуск игры Кенгуру-головоломка

## Вариант 1: Android Studio (рекомендуется)

### Шаг 1: Откройте проект
1. Откройте Android Studio
2. File → Open
3. Выберите папку `/workspace/project/kenguru`
4. Нажмите OK

### Шаг 2: Дождитесь синхронизации
- Android Studio автоматически загрузит зависимости Flutter
- Подождите пока статус внизу станет "Gradle sync finished"

### Шаг 3: Запустите приложение
1. Вверху Android Studio найдите панель устройств (рядом с зелёным треугольником)
2. Выберите эмулятор Android или подключённое устройство
3. Нажмите зелёный треугольник ▶️ (Run) или Shift+F10

---

## Вариант 2: Командная строка

### Если Android SDK не найден в Android Studio:

1. **Скачайте Android Studio**: https://developer.android.com/studio

2. **При первом запуске** Android Studio предложит установить Android SDK

3. **Или установите SDK вручную**:
   ```bash
   # Откройте SDK Manager в Android Studio:
   # Tools → SDK Manager → SDK Tools
   
   # Установите:
   - Android SDK Command-line Tools
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   ```

### Запуск через терминал:
```bash
cd /workspace/project/kenguru

# Проверьте Flutter
flutter doctor

# Запустите на эмуляторе/устройстве
flutter run
```

---

## Вариант 3: Сборка APK для установки

```bash
cd /workspace/project/kenguru
flutter build apk --debug
```

APK будет создан в: `build/app/outputs/flutter-apk/app-debug.apk`

Скопируйте этот файл на телефон и установите.

---

## Если игра не отображается в браузере

Flutter Web требует CanvasKit для корректной работы. Попробуйте:

1. Очистите кэш браузера
2. Используйте другой браузер (Chrome/Firefox)
3. Или запустите через Flutter DevTools:
   ```bash
   flutter run -d chrome --web-renderer canvaskit
   ```

---

## Структура проекта

```
kenguru/
├── lib/
│   ├── main.dart          # Точка входа
│   ├── models/            # Модели данных
│   ├── widgets/           # Виджеты игры
│   ├── screens/           # Экраны
│   ├── state/             # Управление состоянием
│   └── data/              # Уровни игры
├── android/               # Android проект
├── ios/                   # iOS проект
└── web/                   # Web версия
```

## Управление игрой

1. **Клик на платформу** → кенгуру прыгает туда
2. **Сбор предметов** → автоматически при приближении
3. **Перетаскивание** → drag & drop предметов в карман
4. **Заполнение формы** → переход на следующий уровень

---

*Игра создана с использованием Flutter + Provider*