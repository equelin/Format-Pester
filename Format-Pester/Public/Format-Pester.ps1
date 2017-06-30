Function Format-Pester {
<#
    .SYNOPSIS
    Document Pester's tests results into the selected format (HTML, Word, Text).

    .DESCRIPTION
    Create documents in formats: HTML, Word, Text using PScribo PowerShell module. Documents are preformated to be human friendly.
    Local Word installation is not needed to be installed on the computers were documents.

    Additional languages (other than en-US) can be used - please read info for translator on the project web page.

    .PARAMETER PesterResult
    Specifies the Pester results object.

    An results objects is returned by Pester when the PassThru parameter is used to to run Invoke-Pester.

    .PARAMETER Format
    Specifies the document format. Might be:
    - HTML
    - Text
    - Word

    .PARAMETER Path
    Specifies where the documents will be stored. Default is the path where is executed this function.

    .PARAMETER BaseFileName
    Specifies a name for file(s) what will be created. Default is 'Pester_Results'.

    .PARAMETER ReportTitle
    Specifies a title of generated document.

    The document title will be included at the main header level of created document.

    .PARAMETER ResultsOrder
    Specify in which order tests results need to be evaluated - menas included in a report.

    Default order is: Passed, Failed, Skipped, Pending, Inconclusive.

    If any results are ommited will be added on the end of a reports - based on default order if more than one will be ommited.

    .PARAMETER Order
    Since the version 1.5.0 a usage of the Order parameter is deprecated. Please use ResultsOrder instead.

    Specify what results need to be evaluated first - passed or failed - means that will be included on the top of report.
    By default failed tests are evaluated first.

    .PARAMETER GroupResultsBy
    Select how results should be groupped. Available options: Result, Result-Describe, Result-Describe-Context.

    .PARAMETER Include
    Customizes the output what Format-Pester writes to created documents.

    Available options are All, Passed, Failed, Pending, Skipped, Inconclusive.
    The options can be combined to define presets.

    This parameter does not affect the content of the summary table - it will be contains
    information (counts) about all types of tests/results.

    .PARAMETER PassedOnly
    Since the version 1.5.0 a usage of the PassedOnly parameter is deprecated. Please use Include instead.

    Select to return information about passed tests only.

    .PARAMETER FailedOnly
    Since the version 1.5.0 a usage of the PassedOnly parameter is deprecated. Please use Include instead.

    Select to return information about failed tests only.

    .PARAMETER SummaryOnly

    Since the version 1.5.2 a usage of the Order parameter is deprecated. Please use Include instead.

    Select to return only summaries for tests only (sums of numbers passed/failed/etc. tests).

    .PARAMETER SkipTableOfContent

    Since the version 1.5.2 a usage of the Order parameter is deprecated. Please use Include instead.

    Select to skip adding table of content at the begining of document(s).

    .PARAMETER SkipSummary

    Since the version 1.5.2 a usage of the Order parameter is deprecated. Please use Include instead.

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

    .PARAMETER PassThru
    If PassThru will be selected than Format-Pester returns PowerShell objects which contain references to
    created files.

    By default Format-Pester create files without provides additional output about created files.

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
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True, HelpMessage = 'Pester results Object', ParameterSetName = 'VersionOnlyParamSet')]
        [Array]$PesterResult,

        [Parameter(Mandatory = $true, HelpMessage = 'PScribo export format', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [ValidateSet('Text', 'Word', 'HTML')]
        [String[]]$Format,

        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, HelpMessage = 'PScribo export path', ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [ValidateNotNullorEmpty()]
        [String]$Path = (Get-Location -PSProvider FileSystem),

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [ValidateNotNullorEmpty()]
        [string]$BaseFileName = 'Pester_Results',

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Alias('Title')]
        [String]$ReportTitle,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [String[]]$ResultsOrder,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [ValidateSet('FailedFirst', 'PassedFirst')]
        [String]$Order,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [ValidateSet('Result', 'Result-Describe', 'Result-Describe-Context')]
        [String]$GroupResultsBy = 'Result',

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [ValidateNotNullorEmpty()]
        [ValidateSet('All', 'Passed', 'Failed', 'Skipped', 'Pending', 'Inconclusive', 'Title', 'Summary','TOC')]
        [String[]]$Include = 'All',

        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Switch]$PassedOnly,

        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Switch]$FailedOnly,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [switch]$SummaryOnly,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Switch]$SkipTableOfContent,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Switch]$SkipSummary,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [String]$Language = $($(Get-Culture).Name),

        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DumpPScriboObjectParamSet')]
        [Switch]$DumpPScriboObject,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ResultsOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedOrderParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'IncludeParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedPassedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedFailedOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'DeprecatedSummaryOnlyParamSet')]
        [Parameter(Mandatory = $false, ParameterSetName = 'PassThruParamSet')]
        [Switch]$PassThru,

        [Parameter(Mandatory = $false, ParameterSetName = 'VersionOnlyParamSet')]
        [Switch]$Version

    )

    [Version]$ScriptVersion = "1.5.2"

    #LocalizedStrings are not sorted alphabeticaly -even if you are using Sort-Object !
    Import-LocalizedData -FileName Format-Pester.psd1 -BindingVariable LocalizedStrings -UICulture $Language -ErrorAction SilentlyContinue

    If ([String]::IsNullOrEmpty($LocalizedStrings)) {

        Import-LocalizedData -FileName Format-Pester.psd1 -BindingVariable LocalizedStrings -UICulture 'en-US' -ErrorAction Stop

        [String]$MessageText = "{0} {1} {2}" -f $LocalizedStrings.msgA013, $Language, $LocalizedStrings.msgA014

        Write-Verbose -Message $MessageText

    }

    If ($Version.IsPresent) {

        Return $ScriptVersion.ToString()

        Break

    }
    Else {

        if ($null -eq $PesterResult) {

            $MessageText = $LocalizedStrings.msgA019

            Throw $MessageText

        }

    }

    If ($LocalizedStrings.msgA000 -ne $ScriptVersion) {

        [String]$MessageText = "{0}" -f $LocalizedStrings.msgA015

        Write-Warning -Message $MessageText

    }

    $exportParams = @{ }

    if ($Format -contains 'HTML') {

        $exportParams = $exportParams + @{"NoPageLayoutStyle"= $true}

    }

    if ($Format -contains 'text' -and $LocalizedStrings.msgA018 -ne 'ASCII') {

        $exportParams = $exportParams + @{"Encoding" = $LocalizedStrings.msgA018}

    }

    $DeprecatedParameters = @{'PassedOnly' = 'Include';
                            'FailedOnly' = 'Include';
                            'SkipTableOfContent'='Include';
                            'SkipSummary' = 'Include';
                            'SummaryOnly' = 'Include';
                            'PassedFirst' = 'ResultsOrder';
                            'FailedFirst' = 'ResultsOrder'}

    ForEach ( $DeprecatedParameter in $DeprecatedParameters.keys) {

        if ($PSBoundParameters.ContainsKey( $DeprecatedParameter )) {

                [String]$MessageText = $LocalizedStrings.msgX001 -f $DeprecatedParameter, $DeprecatedParameters[$DeprecatedParameter]

                Write-Warning -Message $MessageText

        }

    }

    #Initiate SkipSomethingInternal parameters
    [Bool]$SkipTableOfContentInternal = $false

    [Bool]$SkipSummaryInternal = $false

    #Evaluate values of deprecated parameters and translate it to internal parameters

    If ( $SkipTableOfContent.IsPresent) {

        $SkipTableOfContentInternal = $true

    }

    If ( $SkipSummary.IsPresent) {

        $SkipSummaryInternal = $true

    }

    #Evaluate Inlucde parameter values and translate it to internal parameters

    If ( $Include -notcontains 'TOC' -and $Include -notcontains 'All' ) {

        $SkipTableOfContentInternal = $true

    }

    If ( $Include -notcontains 'Summary' -and $Include -notcontains 'All' ) {

        $SkipSummaryInternal = $true

    }

    $PScriboObject = Document $BaseFileName {

        # Document options
        DocumentOption -PageSize A4 -EnableSectionNumbering

        If ( -not [String]::IsNullOrEmpty($ReportTitle) -and ($Include -contains 'All' -or $Include -contains 'Title') ) {

            Style -Name Title -Size 18 -Color 0072af;

            Paragraph -Style Title $ReportTitle

        }

        If (-not $SkipTableOfContent ) {

            # Table of content header text
            [String]$TOCName = $LocalizedStrings.msgA001

            TOC -Name $TOCName

        }

        # Test results names
        #This variable can't be translated
        $TestResultsNames = @('Passed', 'Failed', 'Skipped', 'Pending', 'Inconclusive')

        $ResultsOrderInternal = @()

        #ValidResulsts are used by ResultsOrder too
        $ValidResults = $PesterResult | Where-Object { $null -ne $_.TotalCount } | Sort-Object -Property FailedCount -Descending

        If (-not $SkipSummaryInternal ) {

            # Columns used for the summary table

            #This variable can't be translated
            $SummaryColumnsData = @('TotalCount', 'PassedCount', 'FailedCount', 'SkippedCount', 'PendingCount', 'InconclusiveCount')

            $SummaryColumnsHeaders = @($LocalizedStrings.msgA002, $LocalizedStrings.msgA003, $LocalizedStrings.msgA004, $LocalizedStrings.msgA005, $LocalizedStrings.msgA006, $LocalizedStrings.msgA007)

            # Style definitions used for the summary table
            Style -Name TableDefaultHeading -Size 11 -Color fff -Bold -BackgroundColor 4472c4 -Align Center
            Style -Name SummaryRow -Color Black -BackgroundColor White -Align Center

            # Results Summary
            $ResultsSummaryTitle = $LocalizedStrings.msgA008

            Section -Name $ResultsSummaryTitle -Style Heading1 -ScriptBlock {

                $ValidResults | Set-Style -Style 'SummaryRow' -Property 'TotalCount'
                $ValidResults | Set-Style -Style 'SummaryRow' -Property 'PassedCount'
                $ValidResults | Set-Style -Style 'SummaryRow' -Property 'FailedCount'
                $ValidResults | Set-Style -Style 'SummaryRow' -Property 'SkippedCount'
                $ValidResults | Set-Style -Style 'SummaryRow' -Property 'PendingCount'
                $ValidResults | Set-Style -Style 'SummaryRow' -Property 'InconclusiveCount'

                $ValidResults | Table -Columns $SummaryColumnsData -Headers $SummaryColumnsHeaders -Width 90

            }

        }

        If (-not $SummaryOnly.IsPresent) {

            #Expanding Pester summary to receive all tests results
            $PesterTestsResults = $PesterResult | Select-Object -ExpandProperty TestResult

            [Array]$EvaluateResults = $null

            If ( $PassedOnly.IsPresent -and $PesterResult.PassedCount -gt 0 ) {

                $EvaluateResults += 'Passed'

            }
            Elseif( $FailedOnly.IsPresent -and $PesterResult.FailedCount -gt 0) {


                $EvaluateResults += 'Failed'

            }
            Else {

                If ( $Include -contains 'All' ) {

                    $IncludeInternal = $TestResultsNames

                }
                Else {

                    $IncludeInternal = $Include

                }

                If ( $Order -eq 'PassedFirst' ) {

                    $ResultsOrderInternal = @('Passed', 'Failed', 'Skipped', 'Pending', 'Inconclusive')

                    If ( $IncludeInternal -notcontains 'Passed' ) {

                        [String]$MessageText = $LocalizedStrings.msgX003

                        Write-Warning -Message $MessageText

                    }

                }
                ElseIf ( $Order -eq 'FailedFirst' ) {

                    $ResultsOrderInternal = @('Failed', 'Passed', 'Skipped', 'Pending', 'Inconclusive')

                    If ( $IncludeInternal -notcontains 'Passed' ) {

                        [String]$MessageText = $LocalizedStrings.msgX004

                        Write-Warning -Message $MessageText

                    }

                }
                ElseIf ( [String]::IsNullOrEmpty($ResultsOrder) ) {

                    $ResultsOrderInternal = @('Failed', 'Passed', 'Skipped', 'Pending', 'Inconclusive')

                }
                Else {

                    ForEach ( $CurrentResult in $ResultsOrder ) {

                        If ( $TestResultsNames -contains $CurrentResult) {

                            If ( $ResultsOrderInternal -contains $CurrentResult ) {

                                [String]$MessageText = $LocalizedStrings.msgA020 -f $CurrentResult

                                Write-Warning -Message $MessageText

                            }
                            else {

                                $ResultsOrderInternal += $CurrentResult

                            }

                        }
                        Else {

                            [String]$MessageText = LocalizedStrings.msgA021 -f $CurrentResult

                            Write-Warning -Message $MessageText

                        }

                    }

                }

                $MissedResultsNames = @()

                ForEach ( $CurrentResultTestName in $TestResultsNames ) {

                    If ( $ResultsOrderInternal -notcontains $CurrentResultTestName ) {

                        $MissedResultsNames += $CurrentResultTestName

                    }

                }

                If ( $MissedResultsNames.Count -gt 0 ) {

                    ForEach ( $CurrentMissedResultName in $MissedResultsNames ) {

                        $ResultsOrderInternal += $CurrentMissedResultName

                    }

                }

                ForEach ( $CurrentResultTestName in $ResultsOrderInternal ) {

                    If ( $IncludeInternal -contains $CurrentResultTestName ) {

                        [String]$CurrentTestCountName = "{0}Count" -f $CurrentResultTestName

                        If ( $PesterResult.$CurrentTestCountName -gt 0 ) {

                            $EvaluateResults += $CurrentResultTestName

                        }

                    }

                }

            }

            foreach ($CurrentResultType in $EvaluateResults) {

                switch ($CurrentResultType) {

                    'Passed' {

                        [String]$TranslationGroup = "B"

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Describe', 'Context', 'Name')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msgA010, $LocalizedStrings.msgA011, $LocalizedStrings.msgA012)

                    }

                    'Failed' {

                        [String]$TranslationGroup = "C"

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Context', 'Name', 'FailureMessage')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msgA011, $LocalizedStrings.msgA012, $LocalizedStrings.msgC006)

                    }

                    'Skipped' {

                        [String]$TranslationGroup = "D"

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Describe', 'Context', 'Name')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msgA010, $LocalizedStrings.msgA011, $LocalizedStrings.msgA012)

                    }

                    'Pending' {

                        [String]$TranslationGroup = "E"

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Describe', 'Context', 'Name')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msgA010, $LocalizedStrings.msgA011, $LocalizedStrings.msgA012)

                    }

                    'Inconclusive' {

                        [String]$TranslationGroup = "F"

                        #This variable can't be translated
                        $TestsResultsColumnsData = @('Context', 'Name', 'FailureMessage')

                        $TestsResultsColumnsHeaders = @($LocalizedStrings.msgA011, $LocalizedStrings.msgA012, $LocalizedStrings.msgF006)

                    }

                }

                $CurrentResultTypeLocalized = $LocalizedStrings.item($("msg{0}000" -f $TranslationGroup))

                $Head1SectionTitle = $LocalizedStrings.item($("msg{0}007" -f $TranslationGroup))

                $Header1TitlePart = $LocalizedStrings.item($("msg{0}001" -f $TranslationGroup))

                $Header2TitlePart = $LocalizedStrings.item($("msg{0}002" -f $TranslationGroup))

                $Header3TitlePart = $LocalizedStrings.item($("msg{0}003" -f $TranslationGroup))

                $VerboseMsgHeader2Part = $LocalizedStrings.item($("msg{0}004" -f $TranslationGroup))

                $VerboseMsgHeader3Part = $LocalizedStrings.item($("msg{0}005" -f $TranslationGroup))

                $VerboseMsgMainLoop = $LocalizedStrings.msgA009

                [String]$MessageText = "{0} {1} " -f $VerboseMsgMainLoop, $CurrentResultTypeLocalized

                Write-Verbose -Message $MessageText

                $CurrentPesterTestResults = $PesterTestsResults | Where-object -FilterScript { $_.Result -eq $CurrentResultType }

                If ($GroupResultsBy -eq 'Result') {

                    [String]$Header1Title = $Header1TitlePart

                    Section -Name $Header1Title -Style Heading1   {

                        $CurrentPesterTestResults |
                        Table -Columns $TestsResultsColumnsData -ColumnWidths @(34,33,33) -Headers $TestsResultsColumnsHeaders -Width 90

                    }

                }
                Else {

                    Section -Name $Head1SectionTitle -Style Heading1 -ScriptBlock {

                        #Get unique 'Describe' from Pester results
                        [Array]$Headers2 = $CurrentPesterTestResults | Select-Object -Property Describe -Unique

                        # Tests results details - Grouped by Describe
                        foreach ($Header2 in $Headers2) {

                            [String]$MessageText = "{0}: {1} " -f $VerboseMsgHeader2Part, $($Header2.Describe)

                            Write-Verbose -Message $MessageText

                            [String]$Header2Title = "{0} {1}" -f $Header2TitlePart, $($Header2.Describe)

                            Section -Name $Header2Title -Style Heading2 -ScriptBlock {

                                $CurrentPesterTestResults2 = $CurrentPesterTestResults | Where-Object -FilterScript { $_.Describe -eq $Header2.Describe }

                                $CurrentPesterTestResultsCount2 = ($CurrentPesterTestResults2 | Measure-Object).Count

                                [String]$MessageText = "{0} {1}, {2} {3}" -f $LocalizedStrings.msgA016, $Header2TitlePart, $LocalizedStrings.msgA017, $CurrentPesterTestResultsCount2

                                Write-Verbose -Message $MessageText

                                If ($GroupResultsBy -eq 'Result-Describe-Context') {

                                    [Array]$Headers3 = $CurrentPesterTestResults2 | Select-Object -Property Context -Unique

                                    foreach ($Header3 in $Headers3) {

                                        [String]$MessageText = "{0}: {1} " -f $VerboseMsgHeader3Part, $($Header3.Context)

                                        Write-Verbose -Message $MessageText

                                        $CurrentPesterTestResults3 = $CurrentPesterTestResults2 | Where-Object -FilterScript { $_.Context -eq $Header3.Context }

                                        $CurrentPesterTestResultsCount3 = ($CurrentPesterTestResults3 | Measure-Object).Count

                                        [String]$Header3Title = "{0} {1}" -f $Header3TitlePart, $($Header3.Context)

                                        Section -Name $Header3Title -Style Heading3 -ScriptBlock {

                                            [String]$MessageText = "{0} {1} {2}, {3} {4}" -f $LocalizedStrings.msgA016, $Header3TitlePart, $($Header3.Context), $LocalizedStrings.msgA017, $CurrentPesterTestResultsCount3

                                            Write-Verbose -Message $MessageText

                                            $CurrentPesterTestResults3 |
                                            Table -Columns $TestsResultsColumnsData -ColumnWidths @(34,33,33) -Headers $TestsResultsColumnsHeaders -Width 90
                                        }

                                    }

                                } #$GroupResultsBy -eq 'Result-Describe-Context'
                                Else {

                                    [String]$MessageText = "{0} {1} {2}, {3}: {4}" -f $LocalizedStrings.msgA016, $Header3TitlePart, $($Header3.Context), $LocalizedStrings.msgA017, $CurrentPesterTestResultsCount3

                                    Write-Verbose -Message $MessageText

                                    $CurrentPesterTestResults2 |
                                    Table -Columns $TestsResultsColumnsData -ColumnWidths @(34,33,33) -Headers $TestsResultsColumnsHeaders -Width 90

                                }

                            }

                        } #end foreach ($Header2 in $Headers2)

                    }

                } #end $GroupResultsBy -ne 'Result'

            }

        }

    }

    If ($DumpPScriboObject.IsPresent) {

        Return $PScriboObject

    }

    If ( $exportParams.Count -gt 0 ) {

        [String]$MessageText = $LocalizedStrings.msgA022

        Write-Verbose -message $MessageText

        foreach($key in $exportParams.Keys){

            Write-Verbose -message "    $key $($exportParams[$key])"

        }

    }

    $PScriboObject | Export-Document -Path $Path -Format $Format -Options $exportParams -PassThru:$PassThru

}
