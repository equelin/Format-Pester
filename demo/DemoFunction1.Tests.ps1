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
        
    }
    
    Context "Useless test S-1-2" {
        
        It "does something  useless S-1-2-1" {
            
            DemoFunction1 -FirstParam 6 | Should Be 5
            
        }
        
        It "does something  useless S-1-2-2" {
            
            DemoFunction1 -FirstParam 5 | Should BeGreaterThan 3
            
        }
        
        It "does something useful S-1-2-3" {
                        
            DemoFunction1 -FirstParam 2 | Should Not Be 2
            
        }
        
    }
    
}