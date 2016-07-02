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

    Document 'Pester_Results' {
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
