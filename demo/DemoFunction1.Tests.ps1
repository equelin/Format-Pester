$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Import-Module "$here\DemoFunction1.ps1"

Describe "DemoFunction1" {
    
    Context "Useless test 1-1" {
        
        It "does something useful 1-1-1" {
            DemoFunction1 -FirstParam 5 | Should BeLessThan 3
            
        }
        
        It "does something useful 1-1-2" {
            
            DemoFunction1 -FirstParam 5 | Should BeLessThan 7
            
        }
        
        It "does something useful 1-1-3" {
            
            DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $(Get-Random -Maximum 100 -Minimum 0)
            
        }
        
    }
    
    Context "Useless test 1-2" {
        
        It "does something  useless 1-2-1" {
            
            DemoFunction1 -FirstParam 6 | Should Be 5
            
        }
        
        It "does something  useless 1-2-2" {
            
            DemoFunction1 -FirstParam 5 | Should Be 5
            
        }
        
        It "does something useful 1-2-3" {
            
            $RandomResult  = $(Get-Random -Maximum 100 -Minimum 0)
            
            DemoFunction1 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult
            
        }
        
    }
    
}

