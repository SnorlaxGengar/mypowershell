#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $user = $s1.CurrentUser
    $prompt = Write-Prompt -Object "$user " -ForegroundColor $s1.Colors.UsernameForegroundColor
    $day = 5 - (Get-Date).DayOfWeek
    $ts = New-TimeSpan -Days $day
    $weekend = (Get-Date -hour 18 -minute 0 -second 0) + $ts
    $remainWeek = New-TimeSpan $weekend (Get-Date)

    $remainDay = New-TimeSpan (Get-Date -hour 18 -minute 0 -second 0) (Get-Date)

    $prompt += Write-Prompt "Weekend:[$remainWeek] Off duty:[$remainDay]" -ForegroundColor $sl.Colors.PromptForegroundColor
    $prompt += Set-Newline
    # $prompt += Write-Prompt -Object ":: " -ForegroundColor $s1.Colors.AdminIconForegroundColor
    $prompt += Write-Prompt -Object "$(Get-FullPath -dir $pwd) " -ForegroundColor $s1.Colors.DriveForegroundColor

    $status = Get-VCSStatus
    if ($status) {
        $gitbranchpre = [char]::ConvertFromUtf32(0x003c)
        $gitbranchpost = [char]::ConvertFromUtf32(0x003e)

        $gitinfo = get-vcsinfo -status $status
        $prompt += Write-Prompt -Object "$gitbranchpre$($gitinfo.vcinfo)$gitbranchpost " -ForegroundColor $($gitinfo.backgroundcolor)
    }

    $prompt += Set-Newline
    # $prompt += Write-Prompt -Object $s1.PromptSymbols.PromptIndicator -ForegroundColor $s1.Colors.AdminIconForegroundColor
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $prompt += Write-Prompt -Object "# " -ForegroundColor $s1.Colors.AdminIconForegroundColor
    } else {
        $prompt += Write-Prompt -Object "$ " -ForegroundColor $s1.Colors.AdminIconForegroundColor
    }
    $prompt
}

$s1 = $global:ThemeSettings
$s1.GitSymbols.BranchIdenticalStatusToSymbol = ""
$s1.GitSymbols.BranchSymbol = ""
$s1.GitSymbols.BranchUntrackedSymbol = "*"
$s1.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x00BB)

# Colors
$s1.Colors.UsernameForegroundColor = [ConsoleColor]::DarkBlue
$s1.Colors.PromptForegroundColor = [ConsoleColor]::White
$s1.Colors.AdminIconForegroundColor = [ConsoleColor]::Blue
$s1.Colors.DriveForegroundColor = [ConsoleColor]::Cyan
