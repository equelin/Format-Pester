# Format-Pester

## SYNOPSIS
Document Pester's tests results into the selected format (HTML, Word, Text).

## SYNTAX

### AllParamSet (Default)
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-ResultsOrder <String[]>] [-Order <String>] [-GroupResultsBy <String>] [-Include <String[]>] [-SummaryOnly]
 [-SkipTableOfContent] [-SkipSummary] [-Language <String>] [-DumpPScriboObject] [-PassThru]
```

### VersionOnlyParamSet
```
Format-Pester [[-PesterResult] <Array>] [-Format <String[]>] [-Version]
```

### SummaryOnlyParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-SummaryOnly] [-SkipTableOfContent] [-Language <String>] [-DumpPScriboObject] [-PassThru]
```

### FailedOnlyParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-GroupResultsBy <String>] [-FailedOnly] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
 [-DumpPScriboObject] [-PassThru]
```

### PassedOnlyParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-GroupResultsBy <String>] [-PassedOnly] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
 [-DumpPScriboObject] [-PassThru]
```

### IncludeParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-ResultsOrder <String[]>] [-Order <String>] [-GroupResultsBy <String>] [-Include <String[]>]
 [-SkipTableOfContent] [-SkipSummary] [-Language <String>] [-DumpPScriboObject] [-PassThru]
```

### DeprecatedOrderParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-Order <String>] [-Include <String[]>] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
 [-DumpPScriboObject] [-PassThru]
```

### ResultOrderParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-ResultsOrder <String[]>] [-Include <String[]>] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
 [-DumpPScriboObject] [-PassThru]
```

### DumpPScriboObjectParamSet
```
Format-Pester [-DumpPScriboObject]
```

### PassThruParamSet
```
Format-Pester [-PassThru]
```

## DESCRIPTION
Create documents in formats: HTML, Word, Text using PScribo PowerShell module.
Documents are preformated to be human friendly.
Local Word installation is not needed to be installed on the computers were documents.

Additional languages (other than en-US) can be used - please read info for translator on the project web page.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-Pester -PassThru | Format-Pester -Path . -Format HTML,Word,Text -BaseFileName 'PesterResults'
```

This command will document the results of the Pester's tests.
Documents will be stored in the current path and they will be available in 3 formats (.html,.docx and .txt).

### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-Pester -PassThru | Export-Clixml -Path .\Test-Result.xml
```

Import-Clixml -Path .\Test-Result.xml | Format-Pester -Format .\ -BaseFileName Test-Result -Format HTML -FailedOnly

The first command you can run e.g.
on a server where PScribo and Format-Pester is not installed.
The tests results will be stored in a file as xml representation of object.

After copy the file to the computer where PScribo and Format-Pester are available you can generate report.
The html file will be generated with results of failed tests only.

## PARAMETERS

### -PesterResult
Specifies the Pester results Object

```yaml
Type: Array
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

```yaml
Type: Array
Parameter Sets: VersionOnlyParamSet
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Format
Specifies the document format.
Might be:
- HTML
- Text
- Word

```yaml
Type: String[]
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: VersionOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies where the documents will be stored.
Default is the path where is executed this function.

```yaml
Type: String
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: (Get-Location -PSProvider FileSystem)
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseFileName
Specifies the document name.
Default is 'Pester_Results'.

```yaml
Type: String
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: Pester_Results
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResultsOrder
Specify in which order tests results need to be evaluated - menas included in a report.

Default order is: Passed, Failed, Skipped, Pending, Inconclusive.

If any results are ommited will be added on the end of a reports - based on default order if more than one will be ommited.

```yaml
Type: String[]
Parameter Sets: AllParamSet, IncludeParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Order
Since the version 1.5.0 a usage of the Order parameter is deprecated.
Please use ResultsOrder instead.

Specify what results need to be evaluated first - passed or failed - means that will be included on the top of report.
By default failed tests are evaluated first.

```yaml
Type: String
Parameter Sets: AllParamSet, IncludeParamSet, DeprecatedOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupResultsBy
Select how results should be groupped.
Available options: Result, Result-Describe, Result-Describe-Context.

```yaml
Type: String
Parameter Sets: AllParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet
Aliases: 

Required: False
Position: Named
Default value: Result
Accept pipeline input: False
Accept wildcard characters: False
```

### -Include
Customizes the output what Format-Pester writes to created documents.

Available options are All, Passed, Failed, Pending, Skipped, Inconclusive.
The options can be combined to define presets.

This parameter does not affect the content of the summary table - it will be contains
information (counts) about all types of tests/results.

```yaml
Type: String[]
Parameter Sets: AllParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassedOnly
Since the version 1.5.0 a usage of the PassedOnly parameter is deprecated.
Please use Include instead.

Select to return information about passed tests only.

```yaml
Type: SwitchParameter
Parameter Sets: PassedOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailedOnly
Since the version 1.5.0 a usage of the PassedOnly parameter is deprecated.
Please use Include instead.

Select to return information about failed tests only.

```yaml
Type: SwitchParameter
Parameter Sets: FailedOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SummaryOnly
Select to return only summaries for tests only (sums of numbers passed/failed/etc.
tests).

```yaml
Type: SwitchParameter
Parameter Sets: AllParamSet, SummaryOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipTableOfContent
Select to skip adding table of content at the begining of document(s).

```yaml
Type: SwitchParameter
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipSummary
Select to skip adding table with test summaries (sums of numbers passed/failed/etc.
tests).

```yaml
Type: SwitchParameter
Parameter Sets: AllParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Language
Select language what need to be used for generated reports.
By default language is detected by Get-Culture with fallback to en-US if translation is not available.

```yaml
Type: String
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet
Aliases: 

Required: False
Position: Named
Default value: $($(Get-Culture).Name)
Accept pipeline input: False
Accept wildcard characters: False
```

### -DumpPScriboObject
When DumpPscriboObject is used the result of the function is custom object containing PScribo Document.
Use this parameter for prepare tests or debug of document generation.

```yaml
Type: SwitchParameter
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet, DumpPScriboObjectParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
If PassThru will be selected than Format-Pester returns PowerShell objects which contain references to
created files.

By default Format-Pester create files without provides additional output about created files.

```yaml
Type: SwitchParameter
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet, IncludeParamSet, DeprecatedOrderParamSet, ResultOrderParamSet, PassThruParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Use that parameter to display version of Format-Pester only.
This parameter can be used to verify translations.

```yaml
Type: SwitchParameter
Parameter Sets: VersionOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### An expected input is the result of the command Invoke-Pester with the parameter -PassThru.
With that command Invoke-Pester returns a custom object (PSCustomObject) that contains the test results.

## OUTPUTS

### Files what contain results of test. Files format and structure is based on values of parameters used.

## NOTES
Initial author: Erwan Quelin

Credits/coauthors:
- Travis Plunk, github\[at\]ez13\[dot\]net
- Wojciech Sciesinski, wojciech\[at\]sciesinski\[dot\]net

LICENSE
Licensed under the MIT License - https://github.com/equelin/Format-Pester/blob/master/LICENSE

## RELATED LINKS

[https://github.com/equelin/Format-Pester](https://github.com/equelin/Format-Pester)

[https://github.com/iainbrighton/PScribo](https://github.com/iainbrighton/PScribo)

