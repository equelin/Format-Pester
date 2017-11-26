# Example files

Files generated using

- Format-Pester v. 1.6.0
- Pester v. 4.1.0
- PScribo v. 0.7.19.93

## Known issues

- The exception message "'ClassID' cannot be found" is displayed under formatitng to HTML document.  Result files look like correctly rendered. - #36.

## en-US

### 20171125a

```powershell

$FormatPesterArguments = @{
                            'Include' = 'All'
                            'Format' = @('word','html','text')
                            'Path' = '.\examples\1.6.0\en-US\'
                            'BaseFileName' = '20171125a'
                            'ReportTitle' = 'Results of tests - a customized report title'
                            'GroupResultsBy' = 'Result-Describe'
                            'Language' = 'en-us'
                        }

Invoke-Pester -Path .\demo\ -Show None -PassThru | Format-Pester @FormatPesterArguments

```

### 20171125b

```powershell

$FormatPesterArguments = @{
                            'Format' = @('word','html','text')
                            'Path' = '.\examples\1.6.0\en-US\'
                            'BaseFileName' = '20171125b'
                            'ReportTitle' = 'Tests results to check'
                            'Include' = @('Title','Failed','Inconclusive')
                            'GroupResultsBy' = 'Result-Describe-Context'
                            'Language' = 'en-us'
                        }

Invoke-Pester -Path .\demo\ -Show None -PassThru -Tag Static | Format-Pester @FormatPesterArguments

```

### 20171125c

```powershell

$FormatPesterArguments = @{
                            'Format' = @('word','html','text')
                            'Path' = '.\examples\1.6.0\en-US\'
                            'BaseFileName' = '20171125c'
                            'Include' = 'All'
                            'ResultsOrder' = 'Skipped','Failed','Inconclusive','Passed'
                            'GroupResultsBy' = 'Result'
                            'Language' = 'en-US'
                        }

Invoke-Pester -Path .\demo\ -Show None -PassThru | Format-Pester @FormatPesterArguments

```

## pl-PL

### 20171125a

```powershell

$FormatPesterArguments = @{
                            'Format' = @('word','html','text')
                            'Path' = '.\examples\1.6.0\pl-PL\'
                            'BaseFileName' = '20171125a'
                            'Title' = 'Wyniki testów'
                            'Include' = 'Passed','Failed','Title'
                            'GroupResultsBy' = 'Result-Describe'
                            'Language' = 'pl-PL'
                        }


Invoke-Pester -Path .\demo\ -Show None -PassThru | Format-Pester @FormatPesterArguments

```

### 20171125b

```powershell

$FormatPesterArguments = @{
                            'Format' = @('word','html','text')
                            'Path' = '.\examples\1.6.0\pl-PL\'
                            'BaseFileName' = '20171125b'
                            'Include' = @('Inconclusive','Failed')
                            'GroupResultsBy' = 'Result-Describe-Context'
                            'Language' = 'pl-PL'
                        }

Invoke-Pester -Path .\demo\ -Show None -PassThru -Tag Static | Format-Pester @FormatPesterArguments

```

### 20171125c

```powershell

$FormatPesterArguments = @{
                            'Format' = 'word','html','text'
                            'Path' = '.\examples\1.6.0\pl-PL\'
                            'BaseFileName' = '20171125c'
                            'Title' = 'Super ważne testy'
                            'Include' = 'All'
                            'ResultsOrder' = 'Skipped','Failed','Inconclusive','Passed'
                            'GroupResultsBy' = 'Result'
                            'Language' = 'pl-PL'
                        }

Invoke-Pester -Path .\demo\ -Show None -PassThru | Format-Pester @FormatPesterArguments

```