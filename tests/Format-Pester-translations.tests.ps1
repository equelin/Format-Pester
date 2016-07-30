Import-Module Pester

Describe -Name 'Unit tests for Format-Pester translations' -Tag 'Translations' {
    
    
    AfterAll {
        
        #RemoveGlobalVariables
        
        $VariablesToRemove = @("enUSLocalizedStrings1", "enUSLocalizedStrings2", "GlobalenUSLocalizedStrings", "GlobalenUSLocalizedStringCount", "GlobalenUSLocalizedStringKeys", `
            "SkipDueEnUSNotImported", "GlobalCurrentLanguageLocalizedStringCount", "GlobalCurrentLanguageLocalizedStringKeys")
        
        foreach ($VariableToRemove in $VariablesToRemove) {
            
            Remove-Variable -Scope Global -Name $VariableToRemove -Force -ErrorAction SilentlyContinue
            
        }
        
    }
    
    
    Import-Module "$PSScriptRoot\..\Format-Pester" -Force -Scope Global
    
    $FormatPesterModule = $(Get-Module -Name Format-Pester)
    
    $FormatPesterModuleVersion = $([Version]$FormatPesterModule.Version).ToString()
    
    $FormatPesterModulePath = $([System.IO.FileInfo]$FormatPesterModule.Path).DirectoryName
    
    Write-host $FormatPesterModulePath
    
    Context 'Compare versions numbers included in module of Format-Pester module and function' {
        
        It 'Compare versions numbers between module and function' {
            
            $FormatPesterModuleVersion | Should be $(Format-Pester -Version)
            
        }
        
    }
    
    Context 'Check subfolder en-US - main language' {
        
        $enUSfolderInPublic = Get-Item -Path "$FormatPesterModulePath\Public\en-US" -ErrorAction SilentlyContinue
        
        It 'Check if the en-US folder exist' {
            { Test-Path -Path $enUSfolderInPublic -PathType Container } | Should be $true
            
        }
        
        It "Check if the subfolder en-US contains Format-Pester.psd1 file " {
            { Test-Path -Path "$enUSfolderInPublic\Format-Pester.psd1" -PathType Leaf } | Should be $true
            
        }
        
        It "Check if Format-Pester.psd1 from en-US folder can be imported" {
            { Import-LocalizedData -BaseDirectory $("$FormatPesterModulePath\Public") -FileName 'Format-Pester.psd1' -BindingVariable enUSLocalizedStrings1 -UICulture 'en-US' -ErrorAction SilentlyContinue } | Should Not Throw
            
            Import-LocalizedData -BaseDirectory $("$FormatPesterModulePath\Public") -FileName 'Format-Pester.psd1' -BindingVariable enUSLocalizedStrings2 -UICulture 'en-US'
            
            New-Variable -Scope Global -Name GlobalenUSLocalizedStrings -Value $enUSLocalizedStrings2 -Force
            
            New-Variable -Scope Global -Name GlobalenUSLocalizedStringCount -Value $enUSLocalizedStrings2.Count -Force
            
            New-Variable -Scope Global -Name GlobalenUSLocalizedStringKeys -Value $enUSLocalizedStrings2.Keys -Force
            
        }
        
        It "Check if data from the file Format-Pester.psd1 for en-US was correctly assigned to variable."  {
            
            $GlobalenUSLocalizedStringCount | Should BeGreaterThan 0
            
        }
        
        It "Compare version of en-US translation with version of module" {
            
            $GlobalenUSLocalizedStrings.msg00 | Should be $FormatPesterModuleVersion
            
        }
        
    }
    
    
    $SubfoldersInPublic =   hildItem -Path "$FormatPesterModulePath\Public\" -Directory
    
    ForEach ($SubfolerInPublic in $SubfoldersInPublic) {
        
        $SubfolderInPublicName = $SubfolerInPublic.Name
        
        If ($SubfolderInPublicName -ne 'en-US') {
            
            Context "Check translations for subfolder $SubfolderInPublicName" {
                
                
                $SubfolderInPublicNamePath = $SubfolderInPublic.FullName
                
                It "Check subfolder name format for the folder $SubfolderInPublicName" {
                    
                    $SubfolderInPublicName.Substring(2, 1) | Should be '-'
                    
                }
                
                It "Check if the subfolder $SubfolderInPublicName contains Format-Pester.psd1 file " {
                    { Test-Path -Path "$SubfolderInPublicNamePath\Format-Pester.ps1" -PathType Leaf } | Should be $true
                    
                }
                
                It "Check if Format-Pester.psd1 from $SubfolderInPublicName folder can be imported and contains data" {
                    { Import-LocalizedData -BaseDirectory $("$FormatPesterModulePath\Public") -FileName 'Format-Pester.psd1' -BindingVariable CurrentLanguageLocalizedStrings1 -UICulture $SubfolderInPublicName -ErrorAction SilentlyContinue } | Should Not Throw
                    
                    Import-LocalizedData -BaseDirectory $("$FormatPesterModulePath\Public") -FileName 'Format-Pester.psd1' -BindingVariable CurrentLanguageLocalizedStrings2 -UICulture $SubfolderInPublicName -ErrorAction SilentlyContinue
                    
                    New-Variable -Scope Global -Name GlobalCurrentLanguageLocalizedStrings -Value $CurrentLanguageLocalizedStrings2 -Force
                    
                    New-Variable -Scope Global -Name GlobalCurrentLanguageLocalizedStringCount -Value $CurrentLanguageLocalizedStrings2.Count -Force
                    
                    New-Variable -Scope Global -Name GlobalCurrentLanguageLocalizedStringKeys -Value $CurrentLanguageLocalizedStrings2.Keys -Force
                    
                }
                
                It "Check if data from the file Format-Pester.psd1 for $SubfolderInPublicName was correctly assigned to variable."  {
                    
                    $GlobalCurrentLanguageLocalizedStringCount | Should BeGreaterThan 0
                    
                }
                
                It "Compare version of $SubfolderInPublicName translation with version of module" {
                    
                    $GlobalCurrentLanguageLocalizedStrings.msg00 | Should be $FormatPesterModuleVersion
                    
                }
                
                It "Compare amount of strings for en-US and $SubfolderInPublicName" {
                    
                    $GlobalenUSLocalizedStringCount | Should be $GlobalCurrentLanguageLocalizedStringCount
                    
                }
                
                It "Compare if names of localization keys for en-US and $SubfolderInPublicName are equal" {
                    
                    $GlobalenUSLocalizedStringKeys | Should be $GlobalCurrentLanguageLocalizedStringKeys
                    
                    New-Variable -Name KeysNotEqual -Value $($GlobalenUSLocalizedStringKeys -ne $GlobalCurrentLanguageLocalizedStringKeys) -Scope Global -Force
                    
                }
                
                foreach ($CurrentenUSLocalizedKey in $GlobalenUSLocalizedStringKeys) {
                    
                    if ($GlobalCurrentLanguageLocalizedStringKeys -notcontains $CurrentenUSLocalizedKey) {
                        
                        It "The language file $SubfolderInPublicName not contains $CurrentenUSLocalizedKey" {
                            
                            $GlobalCurrentLanguageLocalizedStringKeys | Should Contain $CurrentenUSLocalizedKey
                            
                        }
                        
                    }
                    
                }
                
                foreach ($CurrentenLanguageLocalizedKey in $GlobalCurrentLanguageLocalizedStringKeys) {
                    
                    if ($GlobalenUSLocalizedStringKeys -notcontains $CurrentenLanguageLocalizedKey) {
                        
                        It "The language file en-US doesn't contain $CurrentenLanguageLocalizedKey available in $SubfolderInPublicName" {
                            
                            $GlobalenUSLocalizedStringKeys | Should Contain $CurrentenLanguageLocalizedKey
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}