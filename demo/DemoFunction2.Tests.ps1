$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Import-Module "$here\DemoFunction2.ps1"

Describe "DemoFunction2 - Random" -Tag Random {

    Context "Useless test R-2-1" {

        It "does something useful R-2-1-1" {

            DemoFunction2 -FirstParam $(Get-Random -Maximum 2 -Minimum 0) | Should Be $true

        }

        It "does something useful R-2-1-2" {

            DemoFunction2 -FirstParam $(Get-Random -Maximum 10 -Minimum 0) | Should BeLessThan 7

        }

        $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

        If ( $RandomResult -lt 50) {

            It "does something useless R-2-1-3 or Inconclusive" {

                Set-TestInconclusive -Message "Inconclusive result - random - R-1-1-5"

            }


            It "does something useless R-2-1-4 or Inconclusive" {

                Set-TestInconclusive -Message "Inconclusive result - random - R-1-1-5"

            }

        }

        Else {

            It "does something useless R-2-1-3 or Inconclusive" {

                DemoFunction2 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

            }


            It "does something useless R-2-1-4 or Inconclusive" {

                DemoFunction2 -FirstParam $(Get-Random -Maximum 64 -Minimum 40) | Should BeLessThan $RandomResult

            }

        }

        It "does something useful R-2-1-3" {

            DemoFunction2 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $(Get-Random -Maximum 100 -Minimum 0)

        }

    }

    Context "Useless test R-2-2" {

        It "does something  useless R-2-2-1" {

            DemoFunction2 -FirstParam $(Get-Random -Maximum 32 -Minimum 27) | Should Be 30

        }

        It "does something  useless R-2-2-2" {

            DemoFunction2 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeGreaterThan 30

        }

        It "does something useful R-2-2-3" {

            $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)

            DemoFunction2 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult

        }

    }

}

Describe "DemoFunction2 - Static" -Tag Static {

    Context "Useless test S-2-1" {

        It "does something useful S-2-1-1" {

            DemoFunction2 -FirstParam 3 | Should Be 3

        }

        It "does something useful S-2-2-2" {

            DemoFunction2 -FirstParam 8 | Should BeGreaterThan 7

        }

        It "doesn't do nothing - is inconclusive S-2-2-3" {

            Set-TestInconclusive -Message "Inconclusive by design 1"

        }

        It "doesn't do nothing - is inconclusive S-2-2-4" {

            Set-TestInconclusive -Message "Inconclusive by design 2"

        }


        It "does something useful S-2-2-5" {

            DemoFunction2 -FirstParam 56 | Should Not Be 56

        }

    }


    Context "Useless test S-2-2" {

        It "doesn't do nothing - is inconclusive S-2-2-1" {

            Set-TestInconclusive -Message "Inconclusive by design 3"

        }

        It "does something  useless S-2-2-2" {

            DemoFunction2 -FirstParam 6 | Should Be 6

        }

        It "does something  useless S-2-2-3" {

            DemoFunction2 -FirstParam 2 | Should BeGreaterThan 3

        }

        It "does something useful S-2-2-4" {

            DemoFunction2 -FirstParam 1 | Should BeLessThan 2

        }

    }

}
