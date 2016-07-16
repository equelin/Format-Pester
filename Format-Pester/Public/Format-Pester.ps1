Function Format-Pester
{
    
  <#
      .SYNOPSIS
      Document Pester's tests results into the selected format (HTML, Word, Text).
      .DESCRIPTION
      Document Pester's tests results into the selected format (HTML, Word, Text).
      .NOTES
      Written by Erwan Quelin and the community under Apache licence
      .LINK
      https://github.com/equelin/Format-Pester
      .PARAMETER PesterResult
      Specifies the Pester results Object
      .PARAMETER Path
      Specifies where the documents will be stored. Default is the path where is executed this function.
      .PARAMETER Format
      Specifies the document format. Might be:
      - Text
      - HTML
      - Word
      .PARAMETER BaseFileName
      Specifies the document name. Default is 'Pester_Results'
      .EXAMPLE
      Invoke-Pester -PassThru | Format-Pester -Path . -Format HTML,Word,Text -BaseFileName 'PesterResults'

      This command will document the results of the pester's tests. Documents will be stored in the current path and they will be available in 3 formats (.html,.docx and .txt).
  #>
    
    [CmdletBinding(DefaultParameterSetName = 'AllResultsParamSet')]
    [OutputType([System.IO.FileInfo])]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object')]
        [ValidateNotNullorEmpty()]
        [Array]$PesterResult,
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path')]
        [ValidateNotNullorEmpty()]
        [String]$Path = (Get-Location -PSProvider FileSystem),
        [Parameter(Mandatory = $true, HelpMessage = 'PScribo export format')]
        [ValidateSet('Text', 'Word', 'HTML')]
        [String[]]$Format,
        [ValidateNotNullorEmpty()]
        [string]$BaseFileName = 'Pester_Results',
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Switch]$PassedOnly,
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Switch]$FailedOnly,
        [Parameter(Mandatory = $false)]
        [Switch]$SkipTableOfContent,
        [Parameter(Mandatory = $false)]
        [Switch]$SkipSummary
        
    )
    
    $exportParams = @{ }
    if ($Format.Count -eq 1 -and $Format -eq 'HTML')
    {
        $exportParams += @{
            Options = @{ NoPageLayoutStyle = $true }
        }
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
        
        $Head2counter = 1
        $Head3counter = 1
        
        $PesterTestsResults = $PesterResult | Select-Object -ExpandProperty TestResult
        
        
        If (-not $PassedOnly.IsPresent -and $PesterResult.FailedCount -gt 0)
        {
            
            $FailedPesterTestsResults = $PesterTestsResults | Where-object -FilterScript { $_.Result -eq 'Failed' }
            
            #Get unique 'Describe' from failed Pester results
            [Array]$FailedHeaders2 = $FailedPesterTestsResults | Select Describe -Unique
            
            Write-Verbose -Message "Found failed in Decribe blocks: $FailedHeaders2"
            
            
            # Failed tests results details - Grouped by Describe
            foreach ($Header2 in $FailedHeaders2)
            {
                
                Section -Style Heading2 "$Head2counter. Errors details by Describe block: $($Header2.Describe)" {
                    
                    $FailedPesterTestsResultsHeader2 = $FailedPesterTestsResults | Where-Object -FilterScript { $_.Describe -eq $Header2.Describe }
                    
                    [Array]$FailedHeaders3 = $FailedPesterTestsResults | Select Context -Unique
                    
                    foreach ($Header3 in $FailedHeaders3)
                    {
                        
                        $FailedPesterTestsResultsHeader3 = $FailedPesterTestsResultsHeader2 | Where-Object -FilterScript { $_.Context -eq $Header3.Context }
                        
                        $SubHeaderNumber = "{0}.{1}" -f $Head2counter, $Head3counter
                        
                        Section -Style Heading3 "$SubHeaderNumber Errors details by Context block:  $($Header3.Context)" {
                            
                            #Paragraph "$($results.Count) test(s) failed:"
                            
                            $FailedPesterTestsResultsHeader3 |
                            Table -Columns Context, Name, FailureMessage -Headers 'Context', 'Name', 'Failure Message' -Width 0
                        }
                        
                        $Head3Counter++
                        
                        
                    }
                    
                }
                
                
                
                $Head2counter++
                
            }
            
        }
        
        If (-not $FailedOnly.IsPresent)
        {
            
            
            
            $PassedPesterTestsResults = $PesterTestsResults | Where-object -FilterScript { $_.Result -eq 'Passed' }
            
            
            
            # Success tests results details
            $results = $PesterResult.TestResult | Where-Object { $_.Result -eq 'Passed' }
            if ($results)
            {
                Section -Style Heading2 "$Head2counter. Success details" {
                    
                    Paragraph "$($results.Count) test(s) passed:"
                    
                    $results |
                    Table -Columns Describe, Context, Name -Headers 'Describe', 'Context', 'Name' -Width 0
                }
            }
            
        }
        
    } | Export-Document -Path $Path -Format $Format @exportParams
}
