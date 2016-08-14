[![Build status](https://ci.appveyor.com/api/projects/status/36q06wp2c4vwfu7w/branch/master?svg=true)](https://ci.appveyor.com/project/equelin/format-pester/branch/master)

# Format-Pester
Powershell module for documenting Pester's results.

All the formating work is done by the module [PScribo](https://github.com/iainbrighton/PScribo).

## Example

![](./img/format-pester.png)

Screenshot from HTML report generated by Format-Pester v. 1.3.0, PScribo v. 0.7.11

More examples you can find [here](/examples/).

## Supported languages
Since version 1.3.0 internationalization of generated reports is supported.

Currently available languages
- en-US - English United Staes - main language
- pl-PL - Polish

If would you like add support for your language please read the section 'Information for translators'

# Requirements

- Powershell v.4.x
- [Pester](https://github.com/pester/Pester)
- [PScribo](https://github.com/iainbrighton/PScribo) - preferred the version >= 0.7.12.47 due to [bug](https://github.com/iainbrighton/PScribo/issues/20)

# Instructions
## Install the module
```powershell
# One time setup with Powershell 5
    Install-Module Format-Pester

# Or Manually
    # Download the repository
    # Unblock the zip
    # Extract the Format-Pester folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

# Import the module
    Import-Module Format-Pester   #Alternatively, Import-Module \\Path\To\Format-Pester

# Get commands in the module
    Get-Command -Module Format-Pester

# Help for commands
    Get-Help Format-Pester -Full
```
## Online help
You can read [online version of help](/doc/Format-Pester.md) - online help generated by [platyPS module](https://github.com/powershell/platyps)

# Usage

```PowerShell
  Invoke-Pester -PassThru | Format-Pester -Path . -Format HTML,Word,Text
```

This command will document the results of the Pester's tests. Documents will be store in the current path and they will be available in 3 formats (.html,.docx and .txt).

# Available functions

- [Format-Pester](/doc/Format-Pester.md)

# Contributors

- Travis Plunk - [GitHub](https://github.com/TravisEz13) - [Twitter](https://twitter.com/TravisPlunk)
- Wojciech Sciesinski - [GitHub](https://github.com/it-praktyk) - [Twitter](https://twitter.com/ITpraktyk)

# Author

**Erwan Quélin**
- <https://github.com/equelin>
- <https://twitter.com/erwanquelin>

# Information for translators
Format-Pester can be used to prepare reports in languages different than English but a language file for your PSCulture/language need to be available.

To translate required strings to your language please
- read general information about PowerShell support for internationalization
 ```
 Get-Help about_Script_Internationalization
 ```
 online version about_Script_Internationalization available [here](https://technet.microsoft.com/en-us/library/hh847854.aspx).
- create subfolder with your language/culture code under Public - e.g. xx-XX
- copy the file [Format-Pester.psd1](/Public/en-US/Format-Pester.psd1) from Public\en-US\ to your xx-XX - please don't translate module manifest - files have the same name!
- translate required strings
- test - please use Pester, to skip non-translation related tests please use the command 
```
Invoke-Pester -Path .\tests\ -Tag Translations
```
you can also uncomment line in the Format-Pester.ps1 file (remember about re-import module with Force)
```
#$LocalizedStrings
```
- use the Language parameter if your PSCulture is different than required language for output   
- submit your translation to public repo, pull request are welcomed

# [Version history](VERSIONS.md)

# License
Copyright 2016 Erwan Quelin and the community.  
Licensed under the MIT License

# TODO
- updated examples - align them to v. 1.3.0 and PScribo 0.7.12.47
- update VERSIONS.md
