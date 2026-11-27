$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot '..\scripts\remove_prefix.ps1'
. $scriptPath

$cases = @(
    @{ Name = 'ad_photo.jpg'; Prefixes = @('ad_'); Expected = 'photo.jpg' },
    @{ Name = 'my_ad_photo.jpg'; Prefixes = @('ad_'); Expected = 'my_ad_photo.jpg' },
    @{ Name = 'ad_ad_photo.jpg'; Prefixes = @('ad_'); Expected = 'photo.jpg' },
    @{ Name = 'pre_ad_photo.jpg'; Prefixes = @('pre_', 'ad_'); Expected = 'photo.jpg' },
    @{ Name = 'photo.jpg'; Prefixes = @(''); Expected = 'photo.jpg' },
    @{ Name = 'pre_ad_photo.jpg'; Prefixes = @('ad_', 'pre_'); Expected = 'ad_photo.jpg' },
    @{ Name = 'AD_photo.jpg'; Prefixes = @('ad_'); Expected = 'AD_photo.jpg' },
    @{ Name = 'ad_ad_'; Prefixes = @('ad_'); Expected = '' }
)

foreach ($case in $cases) {
    $actual = Remove-LeadingPrefixes -Name $case.Name -Prefixes $case.Prefixes
    if ($actual -cne $case.Expected) {
        throw (
            "Expected '{0}' for '{1}', got '{2}'." -f
            $case.Expected,
            $case.Name,
            $actual
        )
    }
}

function Invoke-Removal {
    param([string] $Prefixes, [string] $Root)

    $scriptLiteral = (Get-Item -LiteralPath $scriptPath).FullName.Replace("'", "''")
    $command = @"
[Console]::InputEncoding = New-Object System.Text.UTF8Encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
& '$scriptLiteral'
exit `$LASTEXITCODE
"@
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
    $startInfo = New-Object Diagnostics.ProcessStartInfo
    $startInfo.FileName = Join-Path $PSHOME 'powershell.exe'
    $startInfo.Arguments = "-NoProfile -EncodedCommand $encodedCommand"
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = [Text.Encoding]::UTF8
    $startInfo.StandardErrorEncoding = [Text.Encoding]::UTF8

    $process = [Diagnostics.Process]::Start($startInfo)
    try {
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        $inputBytes = [Text.Encoding]::UTF8.GetBytes("$Prefixes`r`n$Root`r`n")
        $process.StandardInput.BaseStream.Write($inputBytes, 0, $inputBytes.Length)
        $process.StandardInput.Close()
        $process.WaitForExit()
        @{
            ExitCode = $process.ExitCode
            Output = $stdout.GetAwaiter().GetResult() + $stderr.GetAwaiter().GetResult()
        }
    } finally {
        $process.Dispose()
    }
}

function Assert-Run {
    param($Result, [int] $ExitCode, [string[]] $ExpectedLines)

    if ($Result.ExitCode -ne $ExitCode) {
        throw "Expected exit $ExitCode, got $($Result.ExitCode).`n$($Result.Output)"
    }
    $lines = $Result.Output -split '\r?\n'
    foreach ($line in $ExpectedLines) {
        if ($lines -cnotcontains $line) {
            throw "Missing expected line '$line'.`n$($Result.Output)"
        }
    }
}

function Assert-Bytes {
    param([string] $Path, [string] $Expected)

    $expectedBytes = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Expected))
    if (-not [IO.File]::Exists($Path) -or
        [Convert]::ToBase64String([IO.File]::ReadAllBytes($Path)) -cne $expectedBytes) {
        throw "Missing file or changed bytes at '$Path'."
    }
}

# Файлы теста создаются в уникальном каталоге временных файлов текущего пользователя.
# Test files are created in a unique directory under the current user's temp path.
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('remove-prefix-' + [guid]::NewGuid().ToString('N'))
[void] [IO.Directory]::CreateDirectory($scratch)
$junctionPaths = @()
try {
    $root = Join-Path $scratch 'ad_root [буквально]'
    $parent = Join-Path $root 'ad_parent'
    $child = Join-Path $parent 'ad_child'
    [void] [IO.Directory]::CreateDirectory($child)
    [IO.File]::WriteAllText((Join-Path $child 'ad_ad_pre_photo.jpg'), 'nested')
    [IO.File]::WriteAllText((Join-Path $root 'pre_ad_order'), 'order')
    [IO.File]::WriteAllText((Join-Path $root 'my_ad_photo'), 'interior')
    [IO.File]::WriteAllText((Join-Path $root 'AD_upper'), 'uppercase')
    $hidden = Join-Path $root 'ad_hidden'
    [IO.File]::WriteAllText($hidden, 'hidden')
    [IO.File]::SetAttributes($hidden, [IO.FileAttributes]::Hidden)

    $result = Invoke-Removal ' ad_, ,pre_ ' $root
    Assert-Run $result 0 @(
        'Обработано папок: 2',
        'Обработано файлов: 2',
        "[Папка] Переименована: $child -> $(Join-Path $parent 'child')"
    )
    Assert-Bytes (Join-Path $root 'parent\child\photo.jpg') 'nested'
    Assert-Bytes (Join-Path $root 'ad_order') 'order'
    Assert-Bytes (Join-Path $root 'my_ad_photo') 'interior'
    Assert-Bytes (Join-Path $root 'AD_upper') 'uppercase'
    Assert-Bytes $hidden 'hidden'
    if ([IO.Directory]::Exists($parent) -or [IO.File]::Exists((Join-Path $root 'hidden'))) {
        throw 'Unexpected old parent or renamed hidden file.'
    }

    $root = Join-Path $scratch 'conflicts'
    [void] [IO.Directory]::CreateDirectory((Join-Path $root 'ad_existing-directory'))
    [void] [IO.Directory]::CreateDirectory((Join-Path $root 'existing-directory'))
    [IO.File]::WriteAllText((Join-Path $root 'ad_existing-directory\keep'), 'source folder')
    [IO.File]::WriteAllText((Join-Path $root 'existing-directory\keep'), 'destination folder')
    [IO.File]::WriteAllText((Join-Path $root 'ad_existing-file'), 'source file')
    [IO.File]::WriteAllText((Join-Path $root 'existing-file'), 'destination file')
    [IO.File]::WriteAllText((Join-Path $root 'ad_'), 'empty basename')
    [IO.File]::WriteAllText((Join-Path $root 'ad_ok'), 'continue')

    $result = Invoke-Removal 'ad_' $root
    Assert-Run $result 1 @('Обработано папок: 0', 'Обработано файлов: 1', 'Обработка завершена с ошибками.')
    foreach ($name in @('ad_existing-directory', 'ad_existing-file')) {
        if (-not $result.Output.Contains("[Ошибка] Переименование '$(Join-Path $root $name)'")) {
            throw "Missing rename error for '$name'.`n$($result.Output)"
        }
    }
    if (-not $result.Output.Contains("[Ошибка] Недопустимое имя для '$(Join-Path $root 'ad_')'")) {
        throw "Missing empty-name error.`n$($result.Output)"
    }
    Assert-Bytes (Join-Path $root 'ad_existing-directory\keep') 'source folder'
    Assert-Bytes (Join-Path $root 'existing-directory\keep') 'destination folder'
    Assert-Bytes (Join-Path $root 'ad_existing-file') 'source file'
    Assert-Bytes (Join-Path $root 'existing-file') 'destination file'
    Assert-Bytes (Join-Path $root 'ad_') 'empty basename'
    Assert-Bytes (Join-Path $root 'ok') 'continue'
    if ([IO.Directory]::Exists((Join-Path $root 'existing-directory\ad_existing-directory')) -or
        [IO.File]::Exists((Join-Path $root 'ad_ok'))) {
        throw 'Unexpected moved conflict or old successful source.'
    }

    $emptyRoot = Join-Path $scratch 'ad_empty'
    [void] [IO.Directory]::CreateDirectory($emptyRoot)
    Assert-Run (Invoke-Removal 'ad_' $emptyRoot) 0 @('Обработано папок: 0', 'Обработано файлов: 0')
    Assert-Run (Invoke-Removal ' , ' $emptyRoot) 1 @('Ошибка: Не указаны префиксы!')
    foreach ($invalidRoot in @('', (Join-Path $scratch 'missing'), (Join-Path $root 'ad_existing-file'), 'HKCU:\')) {
        $result = Invoke-Removal 'ad_' $invalidRoot
        Assert-Run $result 1 @()
        if (-not $result.Output.Contains('Ошибка:') -or $result.Output.Contains('Запуск процесса')) {
            throw "Root '$invalidRoot' reached processing or lacked an error.`n$($result.Output)"
        }
    }

    $permissionsRoot = Join-Path $scratch 'permissions'
    $unreadable = Join-Path $permissionsRoot 'unreadable'
    [void] [IO.Directory]::CreateDirectory($unreadable)
    [IO.File]::WriteAllText((Join-Path $unreadable 'ad_external'), 'unreadable')
    [IO.File]::WriteAllText((Join-Path $permissionsRoot 'ad_ok'), 'readable')
    $originalAcl = Get-Acl -LiteralPath $unreadable
    $restrictedAcl = Get-Acl -LiteralPath $unreadable
    $userSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
    $denyList = New-Object Security.AccessControl.FileSystemAccessRule($userSid, 'ListDirectory', 'Deny')
    $restrictedAcl.AddAccessRule($denyList)
    try {
        Set-Acl -LiteralPath $unreadable -AclObject $restrictedAcl
        $result = Invoke-Removal 'ad_' $permissionsRoot
        Assert-Run $result 1 @('Обработано папок: 0', 'Обработано файлов: 1', 'Обработка завершена с ошибками.')
        if (-not $result.Output.Contains("[Ошибка] Чтение папки '$permissionsRoot'")) {
            throw "Missing scan error.`n$($result.Output)"
        }
    } finally {
        Set-Acl -LiteralPath $unreadable -AclObject $originalAcl
    }
    Assert-Bytes (Join-Path $unreadable 'ad_external') 'unreadable'
    Assert-Bytes (Join-Path $permissionsRoot 'ok') 'readable'

    $linkRoot = Join-Path $scratch 'links'
    $outside = Join-Path $scratch 'outside'
    [void] [IO.Directory]::CreateDirectory($linkRoot)
    [void] [IO.Directory]::CreateDirectory($outside)
    [IO.File]::WriteAllText((Join-Path $outside 'ad_external'), 'outside')
    $sourceJunction = Join-Path $linkRoot 'ad_junction'
    $renamedJunction = Join-Path $linkRoot 'junction'
    $junctionPaths = @($sourceJunction, $renamedJunction)
    $junctionCreated = $false
    try {
        New-Item -ItemType Junction -Path $sourceJunction -Target $outside -ErrorAction Stop | Out-Null
        $junctionCreated = $true
    } catch {
        Write-Warning "NOT RUN: junction creation failed: $($_.Exception.Message)"
    }
    if ($junctionCreated) {
        $result = Invoke-Removal 'ad_' $linkRoot
        Assert-Run $result 0 @('Обработано папок: 1', 'Обработано файлов: 0')
        $junction = Get-Item -LiteralPath $renamedJunction
        if (-not ($junction.Attributes -band [IO.FileAttributes]::ReparsePoint) -or
            [IO.Directory]::Exists($sourceJunction) -or
            [IO.File]::Exists((Join-Path $outside 'external'))) {
            throw 'Junction was not renamed as an entry or traversal changed its target.'
        }
        Assert-Bytes (Join-Path $outside 'ad_external') 'outside'
        Assert-Bytes (Join-Path $renamedJunction 'ad_external') 'outside'
        Write-Host 'Junction regression passed.'
    }
} finally {
    # Удаляем сами junction до рекурсивной очистки временного каталога.
    # Remove junction entries before recursively deleting the temp directory.
    foreach ($linkPath in $junctionPaths) {
        if ([IO.Directory]::Exists($linkPath)) {
            [IO.Directory]::Delete($linkPath)
        }
    }
    Remove-Item -LiteralPath $scratch -Recurse -Force
}
Write-Host 'PowerShell regression tests passed.'
