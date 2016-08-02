---
external help file: Format-Pester-help.xml
online version: https://github.com/equelin/Format-Pester
schema: 2.0.0
---

# Format-Pester
## SYNOPSIS
Document Pester's tests results into the selected format (HTML, Word, Text).

## SYNTAX

### AllParamSet (Default)
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-Order <String>] [-GroupResultsBy <String>] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
```

### VersionOnlyParamSet
```
Format-Pester [[-PesterResult] <Array>] [-Format <String[]>] [-BaseFileName <String>] [-Version]
```

### SummaryOnlyParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-SummaryOnly] [-SkipTableOfContent] [-Language <String>]
```

### FailedOnlyParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-GroupResultsBy <String>] [-FailedOnly] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
```

### PassedOnlyParamSet
```
Format-Pester [-PesterResult] <Array> -Format <String[]> [-Path <String>] [-BaseFileName <String>]
 [-GroupResultsBy <String>] [-PassedOnly] [-SkipTableOfContent] [-SkipSummary] [-Language <String>]
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

## PARAMETERS

### -PesterResult
Specifies the Pester results Object

```yaml
Type: Array
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet
Aliases: 

Required: True
Position: 1
Default value: 
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

```yaml
Type: Array
Parameter Sets: VersionOnlyParamSet
Aliases: 

Required: False
Position: 1
Default value: 
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Format
Specifies the document format.
Might be:
- Text
- HTML
- Word

```yaml
Type: String[]
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet
Aliases: 

Required: True
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: VersionOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies where the documents will be stored.
Default is the path where is executed this function.

```yaml
Type: String
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet
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
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: Pester_Results
Accept pipeline input: False
Accept wildcard characters: False
```

### -Order
Specify what results need to be evaluated first - passed or failed - means that will be included on the top of report.
By default failed tests are evaluated first.

```yaml
Type: String
Parameter Sets: AllParamSet
Aliases: 

Required: False
Position: Named
Default value: FailedFirst
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupResultsBy
Select how results should be groupped.
Available options: Result, Result-Describe, Result-Describe-Context.

```yaml
Type: String
Parameter Sets: AllParamSet, FailedOnlyParamSet, PassedOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: Result
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassedOnly
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
Parameter Sets: SummaryOnlyParamSet
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
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet
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
Parameter Sets: AllParamSet, FailedOnlyParamSet, PassedOnlyParamSet
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
Parameter Sets: AllParamSet, SummaryOnlyParamSet, FailedOnlyParamSet, PassedOnlyParamSet
Aliases: 

Required: False
Position: Named
Default value: $($(Get-Culture).Name)
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

## OUTPUTS

### System.IO.FileInfo

## NOTES
Initial author: Erwan Quelin 

Credits/coauthors:  
- Travis Plunk, github\[at\]ez13\[dot\]net 
- Wojciech Sciesinski, wojciech\[at\]sciesinski\[dot\]net  

LICENSE
Licensed under the MIT License - https://github.com/equelin/Format-Pester/blob/master/LICENSE

TODO
- Pester test need to be updated - yes, post factum TDD ;-)
- INPUTS, OUTPUTS need to be described

## RELATED LINKS

[https://github.com/equelin/Format-Pester](https://github.com/equelin/Format-Pester)

