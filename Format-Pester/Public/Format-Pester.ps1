Function Format-Pester {
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
        [String[]]$Format
    )

    $exportParams = @{}
    if($Format -eq 'HTML')
    {
        $exportParams += @{
            Options = @{ NoPageLayoutStyle = $true }
        }
    }

    Document 'Pester_Results' {

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

    } | Export-Document -Path $Path -Format $Format @exportParams
}
