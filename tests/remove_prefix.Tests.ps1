$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $PSScriptRoot '..\scripts\remove_prefix.ps1'
. $scriptPath

$cases = @(
    @{ Name = 'ad_photo.jpg'; Prefixes = @('ad_'); Expected = 'photo.jpg' },
    @{ Name = 'my_ad_photo.jpg'; Prefixes = @('ad_'); Expected = 'my_ad_photo.jpg' },
    @{ Name = 'ad_ad_photo.jpg'; Prefixes = @('ad_'); Expected = 'photo.jpg' },
    @{ Name = 'pre_ad_photo.jpg'; Prefixes = @('pre_', 'ad_'); Expected = 'photo.jpg' },
    @{ Name = 'photo.jpg'; Prefixes = @(''); Expected = 'photo.jpg' }
)

foreach ($case in $cases) {
    $actual = Remove-LeadingPrefixes -Name $case.Name -Prefixes $case.Prefixes
    if ($actual -ne $case.Expected) {
        throw (
            "Expected '{0}' for '{1}', got '{2}'." -f
            $case.Expected,
            $case.Name,
            $actual
        )
    }
}

