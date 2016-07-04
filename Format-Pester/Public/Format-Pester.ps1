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

        # Global options
        GlobalOption -PageSize A4
        
        # Style definitions
        Style -Name Total -Color White -BackgroundColor Blue
        Style -Name Passed -Color White -BackgroundColor Green
        Style -Name Failed -Color White -BackgroundColor Red

        # Table of content
        TOC -Name 'Table of Contents'
        
        # Results Summary
        Section -Style Heading2 'Results summary' {

            $PesterResult | Set-Style -Style 'Total' -Property 'TotalCount'
            $PesterResult | Set-Style -Style 'Passed' -Property 'PassedCount'
            $PesterResult | Set-Style -Style 'Failed' -Property 'FailedCount'
            $PesterResult | Table -Columns TotalCount,PassedCount,FailedCount -Headers 'Total Tests','Passed Tests','Failed Tests'

        }

        # Errors details
        Section -Style Heading2 'Errors details' {
            
            Paragraph "$($PesterResult.FailedCount) test(s) failed:"

            $PesterResult.TestResult | 
            Where { $_.Result -eq 'Failed'} | 
            Table -Columns Describe,Context,Name,FailureMessage -Headers 'Describe','Context','Name','Failure Message' -Width 0 
        }

        # Success details
        Section -Style Heading2 'Success details' {
            
            Paragraph "$($PesterResult.PassedCount) test(s) passed:"

            $PesterResult.TestResult | 
            Where { $_.Result -eq 'Passed'} | 
            Table -Columns Describe,Context,Name -Headers 'Describe','Context','Name' -Width 0
        }

    } | Export-Document -Path $Path -Format $Format
}
