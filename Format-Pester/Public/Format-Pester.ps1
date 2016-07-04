Function Format-Pester {

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

    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    Param(
        [Parameter(Mandatory = $true,Position = 0,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Pester results Object')]
        [ValidateNotNullorEmpty()]
        [Array]$PesterResult,
        [Parameter(Mandatory = $false,HelpMessage = 'PScribo export path')]
        [ValidateNotNullorEmpty()]
        [String]$Path = (Get-Location -PSProvider FileSystem),
        [Parameter(Mandatory = $true,HelpMessage = 'PScribo export format')]
        [ValidateSet('Text','Word','HTML')]
        [String[]]$Format,
        [ValidateNotNullorEmpty()]
        [string] $BaseFileName='Pester_Results'
    )

    Document $BaseFileName {
        $defaultColumns = @('TotalCount','PassedCount','FailedCount','SkippedCount','PendingCount')
        $defaultHeaders = 'Total Tests','Passed Tests','Failed Tests','Skipped Tests','Pending Tests'

        # Global options
        GlobalOption -PageSize A4
        
        # Style definitions
        Style -Name Total -Color White -BackgroundColor Blue
        Style -Name Passed -Color White -BackgroundColor Green
        Style -Name Failed -Color White -BackgroundColor Red
        Style -Name Other -Color White -BackgroundColor Gray

        # Table of content
        TOC -Name 'Table of Contents'
        
        # Results Summary
        $ValidResults = $PesterResult | Where-Object { $null -ne $_.TotalCount} |Sort-Object -Property FailedCount -Descending
        Section -Style Heading2 'Results summary' {

            $ValidResults | Set-Style -Style 'Total' -Property 'TotalCount'
            $ValidResults | Set-Style -Style 'Passed' -Property 'PassedCount'
            $ValidResults | Set-Style -Style 'Failed' -Property 'FailedCount'
            $ValidResults | Set-Style -Style 'Other' -Property 'SkippedCount'
            $ValidResults | Set-Style -Style 'Other' -Property 'PendingCount'
            $ValidResults | Table -Columns $defaultColumns -Headers $defaultHeaders   

        }
        $counter = 1

        # Errors details - Grouped by Describe
        foreach($resultsGroup in $PesterResult.TestResult | Where-Object {$_.Result -eq 'Failed'} |Group-Object -Property Describe )
        {
            $results = $resultsGroup.Group
            $name = $resultsGroup.Name

            Section -Style Heading2 "$counter. Errors details:  $name" {
            
                Paragraph "$($results.Count) test(s) failed:"

                $results | 
                Table -Columns Context,Name,FailureMessage -Headers 'Context','Name','Failure Message' -Width 0 
        }
            $counter++
        }

        # Success details
        $results = $PesterResult.TestResult | Where-Object {$_.Result -ne 'Failed'}
        if($results)
        {
            Section -Style Heading2 "Success details" {
                
                Paragraph "$($results.Count) test(s) passed:"

                $results | 
                Table -Columns Describe, Context,Name -Headers 'Describe','Context','Name' -Width 0 
            }
        }

    } | Export-Document -Path $Path -Format $Format
}
