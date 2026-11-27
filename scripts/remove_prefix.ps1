function Remove-LeadingPrefixes {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string[]] $Prefixes
    )

    $newName = $Name
    foreach ($prefix in $Prefixes) {
        if ([string]::IsNullOrEmpty($prefix)) {
            continue
        }

        while ($newName.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            $newName = $newName.Substring($prefix.Length)
        }
    }

    return $newName
}

if ($MyInvocation.InvocationName -eq '.') {
    return
}

try {
    $prefixesInput = Read-Host "Введите префиксы, которые нужно удалить из названий файлов и папок (через запятую)" -ErrorAction Stop
    $folderPath = Read-Host "Введите полный путь к папке, где нужно переименовать файлы и папки" -ErrorAction Stop
    $prefixesToRemove = @($prefixesInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })

    if ($prefixesToRemove.Count -eq 0) {
        throw 'Не указаны префиксы!'
    }
    if ([string]::IsNullOrWhiteSpace($folderPath)) {
        throw 'Не указан путь к папке!'
    }

    $root = Get-Item -LiteralPath $folderPath -Force -ErrorAction Stop
    if ($root -isnot [System.IO.DirectoryInfo]) {
        throw "'$folderPath' не является папкой файловой системы."
    }
} catch {
    Write-Host "Ошибка: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nЗапуск процесса переименования..." -ForegroundColor Cyan
$startTime = Get-Date
$startMemory = (Get-Process -Id $PID).PrivateMemorySize64 / 1MB
$failed = $false

# Сохраняем найденные элементы даже при ошибке чтения части дерева.
# Keep the items already found if part of the tree cannot be read.
$scanErrors = @()
$items = @(
    try {
        Get-ChildItem -LiteralPath $root.FullName -Recurse -ErrorAction SilentlyContinue -ErrorVariable +scanErrors
    } catch {
        $scanErrors += $_
    }
)
foreach ($scanError in $scanErrors) {
    Write-Host "[Ошибка] Чтение папки '$($root.FullName)': $($scanError.Exception.Message)" -ForegroundColor Red
    $failed = $true
}

$totalItems = $items.Count
$visitedItems = 0
$processedFiles = 0
$processedFolders = 0

# Полный путь потомка всегда длиннее пути его родителя.
# A descendant's full path is always longer than its parent's.
foreach ($item in ($items | Sort-Object { $_.FullName.Length } -Descending)) {
    $visitedItems++
    Write-Progress -Activity "Переименование файлов и папок" -Status "Обработано: $visitedItems из $totalItems" -PercentComplete (($visitedItems / $totalItems) * 100)

    $newName = Remove-LeadingPrefixes -Name $item.Name -Prefixes $prefixesToRemove
    if ($newName -ceq $item.Name) {
        continue
    }
    if ([string]::IsNullOrEmpty($newName) -or $newName -eq '.' -or $newName -eq '..') {
        Write-Host "[Ошибка] Недопустимое имя для '$($item.FullName)'." -ForegroundColor Red
        $failed = $true
        continue
    }

    try {
        $parent = [System.IO.Path]::GetDirectoryName($item.FullName)
        $newPath = [System.IO.Path]::Combine($parent, $newName)
        Rename-Item -LiteralPath $item.FullName -NewName $newName -ErrorAction Stop
    } catch {
        Write-Host "[Ошибка] Переименование '$($item.FullName)': $($_.Exception.Message)" -ForegroundColor Red
        $failed = $true
        continue
    }

    if ($item.PSIsContainer) {
        $processedFolders++
        Write-Host "[Папка] Переименована: $($item.FullName) -> $newPath" -ForegroundColor Green
    } else {
        $processedFiles++
        Write-Host "[Файл] Переименован: $($item.FullName) -> $newPath" -ForegroundColor Blue
    }
}
Write-Progress -Activity "Переименование файлов и папок" -Completed

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
if ($failed) {
    Write-Host "`nОбработка завершена с ошибками.`n" -ForegroundColor Red
    exit 1
}
Write-Host "`nГотово! Указанные префиксы удалены из названий.`n" -ForegroundColor Green
exit 0
