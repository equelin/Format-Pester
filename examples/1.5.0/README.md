# Example files

Files generated using

- Format-Pester v. 1.5.0
- Pester v. 3.4.6
- PScribo v. 0.7.15.63

## Known issues

- Links in TOC for HTML output are broken - #29

## en-US

### 20170611a

```powershell
Invoke-Pester -Path .\demo\ -Quiet -PassThru | Format-Pester -Include All -Format word,html,text -Path .\examples\1.5.0\en-US\ -BaseFileName 20170611a -GroupResultsBy Result-Describe -Language en-us
```

### 20170611b

```powershell
Invoke-Pester -Path .\demo\ -Quiet -PassThru -Tag Static | Format-Pester -Include Failed,Inconclusive -Format word,html,text -Path .\examples\1.5.0\en-US\ -BaseFileName 20170611b -GroupResultsBy Result-Describe-Context -Language en-us
```

### 20170611c

```powershell
Invoke-Pester -Path .\demo\ -Quiet -PassThru | Format-Pester -Include All -ResultsOrder Skipped,Failed,Inconclusive,Passed -Format word,html,text -Path .\examples\1.5.0\en-US\ -BaseFileName 20170611c -GroupResultsBy Result -Language en-us
```

## pl-PL

### 20170611a

```powershell
Invoke-Pester -Path .\demo\ -Quiet -PassThru | Format-Pester -Format word,html,text -Path .\examples\1.5.0\pl-PL\ -BaseFileName 20170611a -GroupResultsBy Result-Describe -Language pl-PL
```

### 20170611b

```powershell
Invoke-Pester -Path .\demo\ -Quiet -PassThru -Tag Static | Format-Pester -Format word,html,text -Path .\examples\1.5.0\pl-PL\ -BaseFileName 20170611b -GroupResultsBy Result-Describe-Context -Language pl-PL
```

### 20170611c

```powershell
Invoke-Pester -Path .\demo\ -Quiet -PassThru | Format-Pester -Include All -ResultsOrder Skipped,Failed,Inconclusive,Passed -Format word,html,text -Path .\examples\1.5.0\pl-PL\ -BaseFileName 20170611c -GroupResultsBy Result -Language pl-PL
```