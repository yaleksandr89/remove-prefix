# Запрашиваем у пользователя префиксы для удаления
$prefixesToRemove = Read-Host "Введите префиксы, которые нужно удалить из названий файлов и папок (через запятую)"

# Запрашиваем путь к папке
$folderPath = Read-Host "Введите полный путь к папке, где нужно переименовать файлы и папки"

# Проверяем, существует ли указанная папка
if (-Not (Test-Path -LiteralPath $folderPath)) {
    Write-Host "Ошибка: Папка '$folderPath' не существует." -ForegroundColor Red
    exit
}

# Начало выполнения скрипта
Write-Host "`nЗапуск процесса переименования..." -ForegroundColor Cyan
$startTime = Get-Date
$startMemory = (Get-Process -Id $PID).PrivateMemorySize64 / 1MB

# Разделяем введённые префиксы по запятой
$prefixesToRemove = $prefixesToRemove -split ',' | ForEach-Object { $_.Trim() }

# Получаем список всех файлов и папок, начиная с самых глубоких уровней вложенности
$items = Get-ChildItem -LiteralPath $folderPath -Recurse | Sort-Object { $_.FullName.Length } -Descending
$totalItems = $items.Count
$processedFiles = 0
$processedFolders = 0

# Переименовываем каждый элемент
foreach ($item in $items) {
    $newName = $item.Name
    foreach ($prefix in $prefixesToRemove) {
        if ($newName -match [regex]::Escape($prefix)) {
            $newName = $newName -replace [regex]::Escape($prefix), ''
        }
    }

    # Если имя изменилось, переименовываем файл или папку
    if ($newName -ne $item.Name) {
        # Проверяем, что у элемента есть родительская директория
        if ($item.Directory -ne $null) {
            $newPath = Join-Path -Path $item.Directory.FullName -ChildPath $newName
        } else {
            # Если это корневая папка, используем путь к самой папке
            $newPath = Join-Path -Path $folderPath -ChildPath $newName
        }

        # Проверяем, существует ли файл или папка перед переименованием
        if (Test-Path -LiteralPath $item.FullName) {
            Rename-Item -LiteralPath $item.FullName -NewName $newName
            if ($item.PSIsContainer) {
                $processedFolders++
                Write-Host "[Папка] Переименована: $($item.FullName) -> $newPath" -ForegroundColor Green
            } else {
                $processedFiles++
                Write-Host "[Файл] Переименован: $($item.FullName) -> $newPath" -ForegroundColor Blue
            }
        } else {
            Write-Host "[Ошибка] Файл или папка '$($item.FullName)' не существует." -ForegroundColor Red
        }
    }

    # Обновляем прогресс
    $processedItems = $processedFiles + $processedFolders
    Write-Progress -Activity "Переименование файлов и папок" -Status "Обработано: $processedItems из $totalItems" -PercentComplete (($processedItems / $totalItems) * 100)
}

# Завершение выполнения скрипта
$endTime = Get-Date
$endMemory = (Get-Process -Id $PID).PrivateMemorySize64 / 1MB
$timeSpent = [math]::Round(($endTime - $startTime).TotalSeconds, 2)
$memoryUsed = [math]::Round($endMemory - $startMemory, 2)

# Вывод отчёта
Write-Host "`nОтчёт о выполнении:" -ForegroundColor Cyan
Write-Host "-----------------" -ForegroundColor Cyan
Write-Host "Время выполнения: $timeSpent секунд" -ForegroundColor Yellow
Write-Host "Использовано памяти: $memoryUsed МБ" -ForegroundColor Yellow
Write-Host "Обработано папок: $processedFolders" -ForegroundColor Yellow
Write-Host "Обработано файлов: $processedFiles" -ForegroundColor Yellow
Write-Host "`nГотово! Указанные префиксы удалены из названий.`n" -ForegroundColor Green