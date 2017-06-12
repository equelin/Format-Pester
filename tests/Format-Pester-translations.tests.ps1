<#
    .SYNOPSIS
    Pester tests to validate translations of PowerShell psd1 files.

    .DESCRIPTION
    Pester test to validate completeness, versions and equality of used fields between main language (en-US) and other languages stored in language related subfolders.

    General information about PowerShell support for internationalization, please read Get-Help about_Script_Internationalization.

    The tests created initially for the Format-Pester project - https://github.com/equelin/format-pester - internationalization supported since v. 1.3.0.

    .LINK
    https://github.com/equelin/Format-Pester

    .NOTES
    AUTHOR: Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
    KEYWORDS: PowerShell, Translation, Pester, psd1

    VERSIONS HISTORY
    0.1.0 - 2016-07-30 - The first version
    0.2.0 - 2016-08-02 - Checking if null/empty strings are used, messages for failed tests improved
    0.3.0 - 2016-08-09 - Names of variables used in code generalized, base names located at the begining of code
    0.3.1 - 2016-09-04 - Some tests corrected

    TODO
    - improve performance for testing in context "Check translation for $SubfolderInPublicName - detailed fields name comparison" - based on the previously calculated difference
    - add support for multi functions modules

    REMARKS
    - Tests for check encoding used for translation files based on the 4 bytes of data (BOM) are the waste of time - due that some editors don't set this bytes e.g. Notepad++

    LICENSE
    Copyright (c) 2016 Wojciech Sciesinski
    This function is licensed under The MIT License (MIT)
    Full license text: https://opensource.org/licenses/MIT

#>

$ModuleName = 'Format-Pester'

$BaseTranslationFileName = 'Format-Pester.psd1'

New-Variable -Scope Global -Name GlobalModuleName -Value $ModuleName -Force

New-Variable -Scope Global -Name GlobalBaseTranslationFileName -Value $BaseTranslationFileName -Force

[scriptblock]$ModuleVersionReturned = { Format-Pester -Version }

Describe -Name "Unit tests for $GlobalModuleName translations" -Tag 'Translations' {

    BeforeAll {

        Remove-Module -Name $GlobalModuleName -ErrorAction SilentlyContinue

        Import-Module "$PSScriptRoot\..\$GlobalModuleName" -Force -Scope Global -ErrorAction Stop

    }

    AfterAll {

        #Remove previously defined variables scoped as global

        $VariablesToRemove = @('GlobalModuleName', 'GlobalBaseTranslationFileName', 'enUSLocalizedStrings1', 'enUSLocalizedStrings2', 'GlobalenUSLocalizedStrings', 'GlobalenUSLocalizedStringCount', 'GlobalenUSLocalizedStringKeys', `
            'SkipDueEnUSNotImported', 'GlobalCurrentLanguageLocalizedStringCount', 'GlobalCurrentLanguageLocalizedStringKeys', 'DifferencesInKeys', 'KeysNotEqual')

        ForEach ($VariableToRemove in $VariablesToRemove) {

            Remove-Variable -Scope Global -Name $VariableToRemove -Force -ErrorAction SilentlyContinue

        }

    }

    $Module = $(Get-Module -Name $GlobalModuleName)

    $ModuleVersion = $([Version]$Module.Version).ToString()

    $ModulePath = $([System.IO.FileInfo]$Module.Path).DirectoryName

    Context "Compare versions numbers included in module of $GlobalModuleName module and function" {

        It 'Compare versions numbers between module and function' {

            $ModuleVersion | Should be $(& $ModuleVersionReturned)

        }

    }

    Context 'Check the subfolder en-US - main language' {

        $enUSfolderInPublic = Get-Item -Path "$ModulePath\Public\en-US" -ErrorAction SilentlyContinue

        It 'Check if the en-US folder exist' {
            { Test-Path -Path $enUSfolderInPublic -PathType Container } | Should be $true

        }

        It "Check if the subfolder en-US contains $GlobalBaseTranslationFileName file " {
            { Test-Path -Path "$enUSfolderInPublic\$GlobalBaseTranslationFileName" -PathType Leaf } | Should be $true

        }

        It "Check if $BaseTranslationFileName from en-US folder can be imported" {
            { Import-LocalizedData -BaseDirectory $("$ModulePath\Public") -FileName $GlobalBaseTranslationFileName -BindingVariable enUSLocalizedStrings1 -UICulture 'en-US' -ErrorAction SilentlyContinue } | Should Not Throw

            Import-LocalizedData -BaseDirectory $("$ModulePath\Public") -FileName $GlobalBaseTranslationFileName -BindingVariable enUSLocalizedStrings2 -UICulture 'en-US'

            New-Variable -Scope Global -Name GlobalenUSLocalizedStrings -Value $enUSLocalizedStrings2

            New-Variable -Scope Global -Name GlobalenUSLocalizedStringCount -Value $enUSLocalizedStrings2.Count -Force

            New-Variable -Scope Global -Name GlobalenUSLocalizedStringKeys -Value $enUSLocalizedStrings2.Keys -Force

            $GlobalenUSLocalizedStrings = $GlobalenUSLocalizedStrings.GetEnumerator() | Sort-Object -Property Name

            $GlobalenUSLocalizedStringKeys = $GlobalenUSLocalizedStringKeys | Sort-Object

        }

        It "Check if data from the file $BaseTranslationFileName for en-US was correctly assigned to variable."  {

            $GlobalenUSLocalizedStringCount | Should BeGreaterThan 0

        }

        It "Compare version of en-US translation with version of module" {

            $GlobalenUSLocalizedStrings.msgA000 | Should be $ModuleVersion

        }

        #Enumerate hashtable and check if keys has assigned values (translations strings are fullfilled)
        $GlobalenUSLocalizedStrings.GetEnumerator() | ForEach-Object -Process {

            $CurrentenUSLocalizedStringValue = $_

            If ([String]::IsNullOrEmpty($CurrentenUSLocalizedStringValue.Value)) {

                It "Check if value for $($_.Key) for en-US is not null or empty." {

                    $CurrentenUSLocalizedStringValue.Value | Should Not BeNullOrEmpty

                }

            }

        }

    }

    $SubfoldersInPublic = Get-ChildItem -Path "$ModulePath\Public\" -Directory

    ForEach ($SubfolderInPublic in $SubfoldersInPublic) {

        $SubfolderInPublicName = $SubfolderInPublic.Name

        If ($SubfolderInPublicName -ne 'en-US') {

            Context "Check translations for subfolder $SubfolderInPublicName" {

                $SubfolderInPublicNamePath = $SubfolderInPublic.FullName

                It "Check subfolder name format for the folder $SubfolderInPublicName" {

                    $SubfolderInPublicName.Substring(2, 1) | Should be '-'

                }

                It "Check if the subfolder $SubfolderInPublicName contains $BaseTranslationFileName file " {
                    { Test-Path -Path "$SubfolderInPublicNamePath\Format-Pester.psd1" -PathType Leaf } | Should be $true

                }

                It "Check if $GlobalBaseTranslationFileName from $SubfolderInPublicName folder can be imported and contains data" {
                    { Import-LocalizedData -BaseDirectory $("$ModulePath\Public") -FileName $GlobalBaseTranslationFileName -BindingVariable CurrentLanguageLocalizedStrings1 -UICulture $SubfolderInPublicName -ErrorAction SilentlyContinue } | Should Not Throw

                    Import-LocalizedData -BaseDirectory $("$ModulePath\Public") -FileName $GlobalBaseTranslationFileName -BindingVariable CurrentLanguageLocalizedStrings2 -UICulture $SubfolderInPublicName -ErrorAction SilentlyContinue

                    New-Variable -Scope Global -Name GlobalCurrentLanguageLocalizedStrings -Value $CurrentLanguageLocalizedStrings2 -Force

                    New-Variable -Scope Global -Name GlobalCurrentLanguageLocalizedStringCount -Value $CurrentLanguageLocalizedStrings2.Count -Force

                    New-Variable -Scope Global -Name GlobalCurrentLanguageLocalizedStringKeys -Value $CurrentLanguageLocalizedStrings2.Keys -Force

                    $GlobalCurrentLanguageLocalizedStrings = $GlobalCurrentLanguageLocalizedStrings.GetEnumerator() | Sort-Object -Property Name

                    $GlobalCurrentLanguageLocalizedStringKeys = $GlobalCurrentLanguageLocalizedStringKeys | Sort-Object

                }

                It "Check if data from the file $BaseTranslationFileName for $SubfolderInPublicName was correctly assigned to variable."  {

                    $GlobalCurrentLanguageLocalizedStringCount | Should BeGreaterThan 0

                }

                It "Compare version of $SubfolderInPublicName translation with version of module" {

                    $GlobalCurrentLanguageLocalizedStrings.msgA000 | Should be $ModuleVersion

                }

                It "Compare amount of strings for en-US and $SubfolderInPublicName" {

                    $GlobalenUSLocalizedStringCount | Should be $GlobalCurrentLanguageLocalizedStringCount

                }

                #Enumerate hashtable and check if keys has assigned values (translations strings are fullfilled)
                $GlobalCurrentLanguageLocalizedStrings.GetEnumerator() | ForEach-Object -Process {

                    $CurrentCurrentLanguageLocalizedStringValue = $_

                    If ([String]::IsNullOrEmpty($CurrentCurrentLanguageLocalizedStringValue.Value)) {

                        It "Check if value for $($_.Key) for en-US is not null or empty." {

                            $CurrentCurrentLanguageLocalizedStringValue.Value | Should Not BeNullOrEmpty

                        }

                    }

                }

                It "Compare if names of localization keys for en-US and $SubfolderInPublicName are equal" {

                    $DifferencesInKeys = Compare-Object -ReferenceObject $GlobalenUSLocalizedStringKeys -DifferenceObject $GlobalCurrentLanguageLocalizedStringKeys

                    If ($DifferencesInKeys) {

                        New-Variable -Name KeysNotEqual -Value $true -Scope Global -Force

                        #New-Variable -Name GlobalDifferencesInKeys -Value $DifferencesInKeys -Scope Global -Force

                    }

                    $KeysNotEqual | Should BeNullOrEmpty

                }

            }

            If ($KeysNotEqual) {

                Context "Check translation for $SubfolderInPublicName - detailed fields name comparison" {

                    ForEach ($CurrentenUSLocalizedKey in $GlobalenUSLocalizedStringKeys) {

                        if ($GlobalCurrentLanguageLocalizedStringKeys -notcontains $CurrentenUSLocalizedKey) {

                            It "The language file $SubfolderInPublicName not contains $CurrentenUSLocalizedKey" {

                                $CurrentLanguageContainResult = ($GlobalCurrentLanguageLocalizedStringKeys -contains $CurrentenUSLocalizedKey)

                                $CurrentLanguageContainResult | Should be $true

                            }

                        }

                    }

                    ForEach ($CurrentenLanguageLocalizedKey in $GlobalCurrentLanguageLocalizedStringKeys) {

                        if ($GlobalenUSLocalizedStringKeys -notcontains $CurrentenLanguageLocalizedKey) {

                            It "The language file en-US does not contain $CurrentenLanguageLocalizedKey available in $SubfolderInPublicName" {

                                $EnUSLanguageContainResult = ($GlobalenUSLocalizedStringKeys -contains $CurrentenLanguageLocalizedKey)

                                $EnUSLanguageContainResult | Should be $true

                            }

                        }

                    }

                }

            }

        }

    }

}
