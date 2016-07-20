$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Import-Module "$here\DemoFunction2.ps1"

Describe "DemoFunction2" {
    
    Context "Useless test 2-1" {
        
        It "does something useful 2-1-1" {
            DemoFunction2 -FirstParam 5 | Should BeLessThan 3
            
        }
        
        It "does something useful 2-1-2" {
            
            DemoFunction2 -FirstParam 5 | Should BeLessThan 6
            
        }
        
        It "does something useful 2-1-3" {
            
            DemoFunction2 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $(Get-Random -Maximum 100 -Minimum 0)
            
        }
        
    }
    
    Context "Useless test 2-2" {
        
        It "does something  useless 2-2-1" {
            
            DemoFunction2 -FirstParam 6 | Should Be 5
            
        }
        
        It "does something  useless 2-2-2" {
            
            DemoFunction2 -FirstParam 5 | Should Be 5
            
        }
        
        It "does something useful 2-2-3" {
            
            $RandomResult = $(Get-Random -Maximum 100 -Minimum 0)
            
            DemoFunction2 -FirstParam $(Get-Random -Maximum 100 -Minimum 0) | Should BeLessThan $RandomResult
            
            
        }
        
    }
    
}
