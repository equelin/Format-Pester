$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Import-Module "$here\DemoFunction1.ps1"

Describe "DemoFunction1 - Random" -Tag Random {

    Context "Useless test R-1-1" {

        It "does something useful R-1-1-1" {

            DemoFunction1 -FirstParam $(Get-Random -Maximum 2 -Minimum 0) | Should Be $true

        }

        It "does something useful R-1-1-2" {

            DemoFunction1 -FirstParam $(Get-Random -Maximum 10 -Minimum 0) | Should BeLessThan 7

        }

        It "does something useful R-1-1-3" {

            DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $(Get-Random -Maximum 100 -Minimum 0)

        }

        It "does something useful R-1-1-4 or Inconclusive" {

            $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

            If ( $RandomResult -gt 49) {

                Set-TestInconclusive -Message "Inconclusive result - random - R-1-1-4"

            }
            Else {

                DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

            }

        }

        It "does something useless R-1-1-5 or Inconclusive" {

            $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

            If ( $RandomResult -gt 49) {

                Set-TestInconclusive -Message "Inconclusive result - random - R-1-1-5"

            }
            Else {

                DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

            }

        }

    }

    Context "Useless test R-1-2" {

        It "does something  useless R-1-2-1" {

            DemoFunction1 -FirstParam $(Get-Random -Maximum 32 -Minimum 27) | Should Be 30

        }

        It "does something  useless R-1-2-2" {

            DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeGreaterThan 30

        }

        It "does something useful R-1-2-3" {

            $RandomResult  = $(Get-Random -Maximum 100 -Minimum 0)

            DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

        }

        It "does something useless R-1-2-4 or Inconclusive" {

            $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

            If ( $RandomResult -gt 49) {

                Set-TestInconclusive -Message "Inconclusive result - random"

            }
            Else {

                DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

            }

        }

        $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

        If ( $RandomResult -lt 49) {

            It -Pending "does something useless R-1-2-5 or Pending" {

            }

        }
        Else {

            It "does something useless R-1-2-5 or Pending" {

                DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

            }

        }

        $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

        If ( $RandomResult -gt 30  -and $RandomResult -lt 69) {

            It -Skip "does something useless R-1-2-5 or Skipped" {

            }

        }
        Else {

            It "does something useless R-1-2-6 or Skipped" {

                $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

                DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

            }

        }

    }

}

Describe "DemoFunction1 - Static" -Tag Static {

    Context "Useless test S-1-1" {

        It "does something useful S-1-1-1" {

            DemoFunction1 -FirstParam 5 | Should BeLessThan 3

        }

        It "does something useful S-1-1-2" {

            DemoFunction1 -FirstParam 5 | Should BeLessThan 7

        }

        It "does something useful S-1-1-3" {

            DemoFunction1 -FirstParam 56 | Should Be 56

        }

        It "doesn't do anything - is inconclusive S-1-1-4" {

            Set-TestInconclusive -Message "Inconclusive by design 1"

        }

        It "doesn't do anything - is inconclusive S-1-1-5" {

            Set-TestInconclusive -Message "Inconclusive by design 2"

        }

        It -Pending "doesn't do anything - pending - S-1-1-6" {

        }

        It -Skip "doesn't do anything - skipped S-1-1-7" {

        }

        It -Skip "doesn't do anything - skipped S-1-1-8" {

        }

    }

    Context "Useless test S-1-2" {

        It "does something  useless S-1-2-1" {

            DemoFunction1 -FirstParam 6 | Should Be 5

        }

        It "does something  useless S-1-2-2" {

            DemoFunction1 -FirstParam 5 | Should BeGreaterThan 3

        }

        It -Pending "doesn't do anything - pending - S-1-2-3" {

        }

        It "does something useful S-1-2-4" {

            DemoFunction1 -FirstParam 2 | Should Not Be 2

        }

        It "doesn't do nothing - is inconclusive S-1-2-5" {

            Set-TestInconclusive -Message "Inconclusive by design 3"

        }

        It -Skip "doesn't do anything - skipped S-1-2-6" {

        }

        It -Pending "doesn't do anything - pending S-1-1-7" {

        }

    }

}
