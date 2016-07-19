Function Format-Pester
{
<#
    .SYNOPSIS
    Document Pester's tests results into the selected format (HTML, Word, Text).
   
    .DESCRIPTION
    Create documents in formats: HTML, Word, Text using PScribo PowerShell module. Documents are preformated to be human friendly.
    Local Word installation is not needed to be installed on the computers were documents 
    
    .PARAMETER PesterResult
    Specifies the Pester results Object
        
    .PARAMETER Format
    Specifies the document format. Might be:
    - Text
    - HTML
    - Word
    
    .PARAMETER Path
    Specifies where the documents will be stored. Default is the path where is executed this function.
    
    .PARAMETER BaseFileName
    Specifies the document name. Default is 'Pester_Results'.
	
    .PARAMETER GroupResultsBy
    Select how results should be groupped. Available options: Result, Result-Describe, Result-Describe-Context.
    
    .PARAMETER PassedOnly
    Select to return information about passed tests only.    
    
    .PARAMETER FailedOnly
    Select to return information about failed tests only.
    
    .PARAMETER SummaryOnly
    Select to return only summaries for tests only (sums of numbers passed/failed/etc. tests).
    
    .PARAMETER SkipTableOfContent
    Select to skip adding table of content at the begining of document(s).
        
    .PARAMETER SkipSummary
    Select to skip adding table with test summaries (sums of numbers passed/failed/etc. tests).
    
    .EXAMPLE
    Invoke-Pester -PassThru | Format-Pester -Path . -Format HTML,Word,Text -BaseFileName 'PesterResults'

    This command will document the results of the Pester's tests. Documents will be stored in the current path and they will be available in 3 formats (.html,.docx and .txt).
    
    .LINK
    https://github.com/equelin/Format-Pester
        
    .NOTES
    Initial author: Erwan Quelin 
    
    Credits/coauthors:
    Travis Plunk, github[at]ez13[dot]net
    Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
    
    LICENSE
    <Need to be selected and fullfilled correctly>
        
    TODO
    - add alligning of width for tables if grouping in used 
    - Pester test need to be updated - yes, post factum TDD ;-)
    
    
  #>
    
    [CmdletBinding(DefaultParameterSetName = 'AllParamSet')]
    [OutputType([System.IO.FileInfo])]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'SummaryOnlyParamSet')]
        [ValidateNotNullorEmpty()]
        [Array]$PesterResult,
        [Parameter(Mandatory = $true, HelpMessage = 'PScribo export format', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SummaryOnlyParamSet')]
        [ValidateSet('Text', 'Word', 'HTML')]
        [String[]]$Format,
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SummaryOnlyParamSet')]
        [ValidateNotNullorEmpty()]
        [String]$Path = (Get-Location -PSProvider FileSystem),
        [ValidateNotNullorEmpty()]
        [string]$BaseFileName = 'Pester_Results',
        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [ValidateSet('Result', 'Result-Describe', 'Result-Describe-Context')]
        [String]$GroupResultsBy = 'Result',
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Switch]$PassedOnly,
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Switch]$FailedOnly,
        [Parameter(Mandatory = $false, ParameterSetName = 'SummaryOnlyParamSet')]
        [switch]$SummaryOnly,
        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SummaryOnlyParamSet')]
        [Switch]$SkipTableOfContent,
        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Switch]$SkipSummary
        
    )
    
    $exportParams = @{ }
    if ($Format.Count -eq 1 -and $Format -eq 'HTML')
    {
        $exportParams += @{
            Options = @{ NoPageLayoutStyle = $true }
        }
    }
    
    If ($SummaryOnly.IsPresent)
    {
        
        $SkipTableOfContent = $true
        
    }
    
    Document $BaseFileName {
        $defaultColumns = @('TotalCount', 'PassedCount', 'FailedCount', 'SkippedCount', 'PendingCount')
        $defaultHeaders = 'Total Tests', 'Passed Tests', 'Failed Tests', 'Skipped Tests', 'Pending Tests'
        
        # Global options
        GlobalOption -PageSize A4
        
        # Style definitions
        Style -Name Total -Color White -BackgroundColor Blue
        Style -Name Passed -Color White -BackgroundColor Green
        Style -Name Failed -Color White -BackgroundColor Red
        Style -Name Other -Color White -BackgroundColor Gray
        
        If (-not $SkipTableOfContent.ispresent)
        {
            
            # Table of content
            TOC -Name 'Table of Contents'
            
        }
        
        If (-not $SkipSummary.IsPresent)
        {
            
            # Results Summary
            $ValidResults = $PesterResult | Where-Object { $null -ne $_.TotalCount } | Sort-Object -Property FailedCount -Descending
            Section -Style Heading2 'Results summary' {
                
                $ValidResults | Set-Style -Style 'Total' -Property 'TotalCount'
                $ValidResults | Set-Style -Style 'Passed' -Property 'PassedCount'
                $ValidResults | Set-Style -Style 'Failed' -Property 'FailedCount'
                $ValidResults | Set-Style -Style 'Other' -Property 'SkippedCount'
                $ValidResults | Set-Style -Style 'Other' -Property 'PendingCount'
                $ValidResults | Table -Columns $defaultColumns -Headers $defaultHeaders
                
            }
            
        }
        
        $Head1Counter = 1
        $Head2counter = 1
        $Head3counter = 1
        
        $PesterTestsResults = $PesterResult | Select-Object -ExpandProperty TestResult
        
        
        If (-not $SummaryOnly.IsPresent -and -not $PassedOnly.IsPresent -and $PesterResult.FailedCount -gt 0)
        {
            
            $FailedPesterTestsResults = $PesterTestsResults | Where-object -FilterScript { $_.Result -eq 'Failed' }
            
            If ($GroupResultsBy -eq 'Result')
            {
                
                Section -Style Heading2 "$Head2counter.`t Errors details" {
                    
                    $FailedPesterTestsResults |
                    Table -Columns Context, Name, FailureMessage -Headers 'Context', 'Name', 'Failure Message' -Width 0
                    
                }
                
                $Head2counter++
                
            }
            
            Else
            {
                
                Section -Style Heading1 "$Head1Counter.`t Errors" {
                    
                    #Get unique 'Describe' from failed Pester results
                    [Array]$FailedHeaders2 = $FailedPesterTestsResults | Select Describe -Unique
                    
                    # Failed tests results details - Grouped by Describe
                    foreach ($Header2 in $FailedHeaders2)
                    {
                        
                        Write-Verbose -Message "Found failed in Decribe blocks: $FailedHeaders2"
                        
                        $SubHeader2Number = "{0}.{1}.`t" -f $Head1Counter, $Head2counter
                        
                        Section -Style Heading2 "$SubHeader2Number.`t Errors details by Describe block: $($Header2.Describe)" {
                            
                            $FailedPesterTestsResults2 = $FailedPesterTestsResults | Where-Object -FilterScript { $_.Describe -eq $Header2.Describe }
                            
                            If ($GroupResultsBy -eq 'Result-Describe-Context')
                            {
                                
                                [Array]$FailedHeaders3 = $FailedPesterTestsResults2 | Select Context -Unique
                                
                                foreach ($Header3 in $FailedHeaders3)
                                {
                                    
                                    $FailedPesterTestsResults3 = $FailedPesterTestsResults2 | Where-Object -FilterScript { $_.Context -eq $Header3.Context }
                                    
                                    $SubHeader3Number = "{0}.{1}.{2}.`t" -f $Head1Counter, $Head2counter, $Head3counter
                                    
                                    Section -Style Heading3 "$SubHeader3Number Errors details by Context block: $($Header3.Context)" {
                                        
                                        #Paragraph "$($results.Count) test(s) failed:"
                                        
                                        $FailedPesterTestsResults3 |
                                        Table -Columns Context, Name, FailureMessage -Headers 'Context', 'Name', 'Failure Message' -Width 0
                                    }
                                    
                                    $Head3Counter++
                                    
                                }
                                
                            } #$GroupResultsBy -eq 'Result-Describe-Context'
                            Else
                            {
                                
                                $FailedPesterTestsResults2 |
                                Table -Columns Context, Name, FailureMessage -Headers 'Context', 'Name', 'Failure Message' -Width 0
                                
                            }
                            
                        }
                        
                        $Head2counter++
                        
                    } #end foreach ($Header2 in $FailedHeaders2)
                    
                }
                
                $Head1Counter++
                
            } #end $GroupResultsBy -ne 'Result' for Failed
                        
        } #end of creating section of failed tests details
        
        $Head3counter = 1
        
        If (-not $SummaryOnly.IsPresent -and -not $FailedOnly.IsPresent -and $PesterResult.PassedCount -gt 0)
        {
            
            $PassedPesterTestsResults = $PesterTestsResults | Where-object -FilterScript { $_.Result -eq 'Passed' }
            
            If ($GroupResultsBy -eq 'Result')
            {
                
                
                Section -Style Heading2 "$Head2counter. Success details" {
                    
                    $PassedPesterTestsResults |
                    Table -Columns Describe, Context, Name -Headers 'Describe', 'Context', 'Name' -Width 0
                    
                }
                
            }
            Else
            {
                
                Section -Style Heading1 "$Head1Counter.`t Success" {
                    
                    #Get unique 'Describe' from failed Pester results
                    [Array]$PassedHeaders2 = $PassedPesterTestsResults | Select Describe -Unique
                    
                    # Failed tests results details - Grouped by Describe
                    foreach ($Header2 in $PassedHeaders2)
                    {
                        
                        Write-Verbose -Message "Found success in Decribe blocks: $PassedHeaders2"
                        
                        $SubHeader2Number = "{0}.{1}.`t" -f $Head1Counter, $Head2counter
                        
                        Section -Style Heading2 "$SubHeader2Number Success details by Describe block: $($Header2.Describe)" {
                            
                            $PassedPesterTestsResults2 = $PassedPesterTestsResults | Where-Object -FilterScript { $_.Describe -eq $Header2.Describe }
                            
                            If ($GroupResultsBy -eq 'Result-Describe-Context')
                            {
                                
                                [Array]$PassedHeaders3 = $PassedPesterTestsResults2 | Select Context -Unique
                                
                                foreach ($Header3 in $PassedHeaders3)
                                {
                                    
                                    $PassedPesterTestsResults3 = $PassedPesterTestsResults2 | Where-Object -FilterScript { $_.Context -eq $Header3.Context }
                                    
                                    $SubHeader3Number = "{0}.{1}.{2}.`t" -f $Head1Counter, $Head2counter, $Head3counter
                                    
                                    Section -Style Heading3 "$SubHeader3Number Success details by Context block: $($Header3.Context)" {
                                        
                                        #Paragraph "$($results.Count) test(s) failed:"
                                        
                                        $PassedPesterTestsResults3 |
                                        Table -Columns Describe, Context, Name -Headers 'Describe', 'Context', 'Name' -Width 0
                                    }
                                    
                                    $Head3Counter++
                                    
                                }
                                
                            } #$GroupResultsBy -eq 'Result-Describe-Context'
                            Else
                            {
                                
                                $PassedPesterTestsResults2 |
                                Table -Columns Describe, Context, Name -Headers 'Describe', 'Context', 'Name' -Width 0
                                
                            }
                            
                        }
                        
                        $Head2counter++
                        
                    } #end foreach ($Header2 in $PassedHeaders2)
                    
                }
                
            } #end $GroupResultsBy -ne 'Result' for Passed
            
        } #end of creating section of passed tests details
        
        
    } | Export-Document -Path $Path -Format $Format @exportParams
}
