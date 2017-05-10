Function Format-Pester {
<#
    .SYNOPSIS
    Document Pester's tests results into the selected format (HTML, Word, Text).

    .DESCRIPTION
    Create documents in formats: HTML, Word, Text using PScribo PowerShell module. Documents are preformated to be human friendly.
    Local Word installation is not needed to be installed on the computers were documents.

    Additional languages (other than en-US) can be used - please read info for translator on the project web page.

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

    .PARAMETER Order
    Specify what results need to be evaluated first - passed or failed - means that will be included on the top of report.
    By default failed tests are evaluated first.

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

    .PARAMETER Language
    Select language what need to be used for generated reports.
    By default language is detected by Get-Culture with fallback to en-US if translation is not available.

    .PARAMETER Version
    Use that parameter to display version of Format-Pester only.
    This parameter can be used to verify translations.

    .PARAMETER DumpPScriboObject
    When DumpPscriboObject is used the result of the function is custom object containing PScribo Document.
    Use this parameter for prepare tests or debug of document generation.

    .INPUTS
    An expected input is the result of the command Invoke-Pester with the parameter -PassThru.
    With that command Invoke-Pester returns a custom object (PSCustomObject) that contains the test results.

    .OUTPUTS
    Files what contain results of test. Files format and structure is based on values of parameters used.

    .EXAMPLE
    Invoke-Pester -PassThru | Format-Pester -Path . -Format HTML,Word,Text -BaseFileName 'PesterResults'

    This command will document the results of the Pester's tests.
    Documents will be stored in the current path and they will be available in 3 formats (.html,.docx and .txt).

    .EXAMPLE
    Invoke-Pester -PassThru | Export-Clixml -Path .\Test-Result.xml

    Import-Clixml -Path .\Test-Result.xml | Format-Pester -Format .\ -BaseFileName Test-Result -Format HTML -FailedOnly

    The first command you can run e.g. on a server where PScribo and Format-Pester is not installed. The tests results will be stored in a file as xml representation of object.

    After copy the file to the computer where PScribo and Format-Pester are available you can generate report. The html file will be generated with results of failed tests only.

    .LINK
    https://github.com/equelin/Format-Pester

    .LINK
    https://github.com/iainbrighton/PScribo

    .NOTES
    Initial author: Erwan Quelin

    Credits/coauthors:
    - Travis Plunk, github[at]ez13[dot]net
    - Wojciech Sciesinski, wojciech[at]sciesinski[dot]net

    LICENSE
    Licensed under the MIT License - https://github.com/equelin/Format-Pester/blob/master/LICENSE

    #>

    [CmdletBinding(DefaultParameterSetName = 'AllParamSet')]
    [OutputType([IO.FileInfo])]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'SummaryOnlyParamSet')]
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'VersionOnlyParamSet')]
        [Array]$PesterResult,
        [Parameter(Mandatory = $true, HelpMessage = 'PScribo export format', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SummaryOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'VersionOnlyParamSet')]
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
        [ValidateSet('FailedFirst', 'PassedFirst')]
        [String]$Order = 'FailedFirst',
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
        [Switch]$SkipSummary,
        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SummaryOnlyParamSet')]
        [String]$Language = $($(Get-Culture).Name),
        [Parameter(Mandatory = $false, ParameterSetName = 'VersionOnlyParamSet')]
        [Switch]$Version,
        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'FailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SummaryOnlyParamSet')]
        [Switch]$DumpPScriboObject
    )

    [Version]$ScriptVersion = "1.4.2"

    If ($Version.IsPresent) {

        Return $ScriptVersion.ToString()

        Break

    }
    Else {

        if ($null -eq $PesterResult) {

            $MessageText = "Value of the parameter PesterResult can't be null or empty."

            Throw $MessageText

        }

    }

    Import-LocalizedData -FileName Format-Pester.psd1 -BindingVariable LocalizedStrings -UICulture $Language -ErrorAction SilentlyContinue

    If ([String]::IsNullOrEmpty($LocalizedStrings)) {

        Import-LocalizedData -FileName Format-Pester.psd1 -BindingVariable LocalizedStrings -UICulture 'en-US' -ErrorAction Stop

        [String]$MessageText = "{0} {1} {2}" -f $LocalizedStrings.msg27, $Language, $LocalizedStrings.msg28

        Write-Verbose -Message $MessageText

    }

    If ($LocalizedStrings.msg00 -lt $ScriptVersion) {

        [String]$MessageText = "{0}" -f $LocalizedStrings.msg29

        Write-Warning -Message $MessageText

    }

    $TextFileEncoding = $LocalizedStrings.msg32

    #LocalizedStrings are not sorted alphabeticaly -even if you are using Sort-Object !
    #$LocalizedStrings

    $exportParams = @{ }
    if ($Format.Count -eq 1 -and $Format -eq 'HTML') {

        $exportParams += @{

            Options = @{ NoPageLayoutStyle = $true }
        }


    }
    elseif ($Format -contains 'text' -and $TextFileEncoding -ne 'ASCII') {

        $exportParams += @{

            Options = @{ Encoding = $TextFileEncoding }

        }


    }


    $PScriboObject = Document $BaseFileName {

        # Global options
        GlobalOption -PageSize A4


        #Variables used to create numbers for TOC and subsections
        $Head1Counter = 1

        If (-not $SkipTableOfContent.ispresent) {

            # Table of content header text
            [String]$TOCName = $LocalizedStrings.msg01

            TOC -Name $TOCName

        }

        If (-not $SkipSummary.IsPresent) {

            # Columns used for the summary table

            #This variable can't be translated
            $SummaryColumnsData = @('TotalCount', 'PassedCount', 'FailedCount', 'SkippedCount', 'PendingCount')

            $SummaryColumnsHeaders = @($LocalizedStrings.msg02, $LocalizedStrings.msg03, $LocalizedStrings.msg04, $LocalizedStrings.msg05, $LocalizedStrings.msg06)

            # Style definitions used for the summary table
            Style -Name Total -Color White -BackgroundColor Blue
            Style -Name Passed -Color White -BackgroundColor Green
            Style -Name Failed -Color White -BackgroundColor Red
            Style -Name Other -Color White -BackgroundColor Gray

            # Results Summary

            $ResultsSummaryTitle = "{0}.`t{1}" -f $Head1Counter, $LocalizedStrings.msg07

            $Head1Counter++

            $ValidResults = $PesterResult | Where-Object { $null -ne $_.TotalCount } | Sort-Object -Property FailedCount -Descending
            Section -Name $ResultsSummaryTitle -Style Heading2 -ScriptBlock {

                $ValidResults | Set-Style -Style 'Total' -Property 'TotalCount'
                $ValidResults | Set-Style -Style 'Passed' -Property 'PassedCount'
                $ValidResults | Set-Style -Style 'Failed' -Property 'FailedCount'
                $ValidResults | Set-Style -Style 'Other' -Property 'SkippedCount'
                $ValidResults | Set-Style -Style 'Other' -Property 'PendingCount'
                $ValidResults | Table -Columns $SummaryColumnsData -Headers $SummaryColumnsHeaders -Width 90

            }

        }

        If (-not $SummaryOnly.IsPresent) {

            #Expanding Pester summary to receive all tests results
            $PesterTestsResults = $PesterResult | Select-Object -ExpandProperty TestResult

            [Array]$EvaluateResults = $null

            If ((-not $PassedOnly.IsPresent) -and $PesterResult.FailedCount -gt 0) {

                $EvaluateResults += 'Failed'

            }

            If ((-not $FailedOnly.IsPresent) -and $PesterResult.PassedCount -gt 0) {

                $EvaluateResults += 'Passed'

                If ($Order -eq 'PassedFirst') {

                    $EvaluateResults = $($EvaluateResults | Sort-Object -Descending)

                }

            }

            foreach ($CurrentResultType in $EvaluateResults) {

                switch ($CurrentResultType) {

                    'Passed' {

                        $CurrentResultTypeLocalized = $LocalizedStrings.msg09

                        $Head1SectionTitle = $LocalizedStrings.msg25

                        $Header1TitlePart = $LocalizedStrings.msg10

                        $Header2TitlePart = $LocalizedStrings.msg11

                        $Header3TitlePart = $LocalizedStrings.msg12

                        $VerboseMsgHeader2Part = $LocalizedStrings.msg13

                        $VerboseMsgHeader3Part = $LocalizedStrings.msg14

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Describe', 'Context', 'Name')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msg15, $LocalizedStrings.msg16, $LocalizedStrings.msg17)

                    }


                    'Failed' {

                        $CurrentResultTypeLocalized = $LocalizedStrings.msg18

                        $Head1SectionTitle = $LocalizedStrings.msg26

                        $Header1TitlePart = $LocalizedStrings.msg19

                        $Header2TitlePart = $LocalizedStrings.msg20

                        $Header3TitlePart = $LocalizedStrings.msg21

                        $VerboseMsgHeader2Part = $LocalizedStrings.msg22

                        $VerboseMsgHeader3Part = $LocalizedStrings.msg23

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Context', 'Name', 'FailureMessage')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msg16, $LocalizedStrings.msg17, $LocalizedStrings.msg24)

                    }

                }

                $VerboseMsgMainLoop = $LocalizedStrings.msg08

                [String]$MessageText = "{0} {1} " -f $VerboseMsgMainLoop, $CurrentResultTypeLocalized

                Write-Verbose -Message $MessageText

                $Head2counter = 1

                $Head3counter = 1

                If (-not $PassedOnly.IsPresent) {

                    $CurrentPesterTestResults = $PesterTestsResults | Where-object -FilterScript { $_.Result -eq $CurrentResultType }

                    If ($GroupResultsBy -eq 'Result') {

                        [String]$Header1Title = "{0}.`t {1}" -f $Head1counter, $Header1TitlePart

                        Section -Name $Header1Title -Style Heading1   {

                            $CurrentPesterTestResults |
                            Table -Columns $TestsResultsColumnsData -Headers $TestsResultsColumnsHeaders -Width 90

                        }

                        $Head1counter++

                    }

                    Else {

                        Section -Name "$Head1Counter.`t $Head1SectionTitle " -Style Heading1 -ScriptBlock {

                            #Get unique 'Describe' from Pester results
                            [Array]$Headers2 = $CurrentPesterTestResults | Select-Object -Property Describe -Unique

                            # Tests results details - Grouped by Describe
                            foreach ($Header2 in $Headers2) {

                                [String]$MessageText = "{0}: {1} " -f $VerboseMsgHeader2Part, $($Header2.Describe)

                                Write-Verbose -Message $MessageText

                                $SubHeader2Number = "{0}.{1}" -f $Head1Counter, $Head2counter

                                [String]$Header2Title = "{0}.`t {1} {2}" -f $SubHeader2Number, $Header2TitlePart, $($Header2.Describe)

                                Section -Name $Header2Title -Style Heading2 -ScriptBlock {

                                    $CurrentPesterTestResults2 = $CurrentPesterTestResults | Where-Object -FilterScript { $_.Describe -eq $Header2.Describe }

                                    If ($GroupResultsBy -eq 'Result-Describe-Context') {

                                        [Array]$Headers3 = $CurrentPesterTestResults2 | Select-Object -Property Context -Unique

                                        foreach ($Header3 in $Headers3) {

                                            [String]$MessageText = "{0}: {1} " -f $VerboseMsgHeader3Part, $($Header3.Context)

                                            Write-Verbose -Message $MessageText

                                            $CurrentPesterTestResults3 = $CurrentPesterTestResults2 | Where-Object -FilterScript { $_.Context -eq $Header3.Context }

                                            $CurrentPesterTestResultsCount3 = ($CurrentPesterTestResults3 | Measure-Object).Count

                                            $SubHeader3Number = "{0}.{1}.{2}" -f $Head1Counter, $Head2counter, $Head3counter

                                            [String]$Header3Title = "{0}.`t {1} {2}" -f $SubHeader3Number, $Header3TitlePart, $($Header3.Context)

                                            Section -Name $Header3Title -Style Heading3 -ScriptBlock {

                                                $MessageText = "{0} {1} {2}, {3} {4}" -f $LocalizedStrings.msg30, $Header3TitlePart, $($Header3.Context), $LocalizedStrings.msg31, $CurrentPesterTestResultsCount3

                                                Write-Verbose -Message $MessageText

                                                $CurrentPesterTestResults3 |
                                                Table -Columns $TestsResultsColumnsData -Headers $TestsResultsColumnsHeaders -Width 90
                                            }

                                            $Head3Counter++

                                        }

                                    } #$GroupResultsBy -eq 'Result-Describe-Context'
                                    Else {

                                        $MessageText = "{0} {1} {2}, {3}: {4}" -f $LocalizedStrings.msg30, $Header3TitlePart, $($Header3.Context), $LocalizedStrings.msg31, $CurrentPesterTestResultsCount3

                                        Write-Verbose -Message $MessageText

                                        $CurrentPesterTestResults2 |
                                        Table -Columns $TestsResultsColumnsData -Headers $TestsResultsColumnsHeaders -Width 90

                                    }

                                }

                                $Head2counter++

                            } #end foreach ($Header2 in $Headers2)

                        }

                        $Head1Counter++

                    } #end $GroupResultsBy -ne 'Result'

                }

            }

        }

    }

    If ($DumpPScriboObject.IsPresent) {

        Return $PScriboObject

    }

        $PScriboObject | Export-Document -Path $Path -Format $Format @exportParams

}
