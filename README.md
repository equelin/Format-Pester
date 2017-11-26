[![Build status](https://ci.appveyor.com/api/projects/status/36q06wp2c4vwfu7w/branch/master?svg=true)](https://ci.appveyor.com/project/equelin/format-pester/branch/master)

# Format-Pester

Powershell module for documenting Pester's results.

All the formatting work is done by the module [PScribo](https://github.com/iainbrighton/PScribo).

Reports are generated based on a custom PowerShell object returned by Invoke-Pester. You have to provide the parameter `PassThru` to Pester. Currently, NUnit style files generated by Pester are not supported.

If you can't generate report on a computer where tests are executed please save tests results piping them to `Export-Clixml`.

You can be interested also in the
- [ReportUnit](https://github.com/reportunit/reportunit) tool. It's a report generator for the test-runner family. It uses stock reports from NUnit, MsTest, xUnit, TestNG and Gallio and converts them into HTML reports with dashboards.
- [PSTestReport](https://github.com/Xainey/PSTestReport) - it's an early example to generate a static PowerShell test report. You can read about it in the blog post ["Hitchhikers Guide to the PowerShell Module Pipeline"](https://xainey.github.io/2017/powershell-module-pipeline) by Michael Willis.

## Report example

![](./img/Format-Pester-1.6.0-part.png)

Partial screenshot for a HTML report generated by Format-Pester v. 1.6.0, PScribo v. 0.7.19, [the full screenshot](./img/Format-Pester-1.6.0-full.png).

You can find more examples [here](/examples/).

## Supported languages

Since version 1.3.0 internationalization of generated reports is supported. It means that reports parts e.g. section names, columns headers, etc. can be wrote in a different language than English.

Currently available languages are:

- en-US - English United States - main language
- pl-PL - Polish

If you would like to add support for your language please read the section [Information for translators](https://github.com/equelin/Format-Pester/wiki/Information-for-translators) in the project's wiki.

# Requirements

- Powershell v.4.x
- [Pester](https://github.com/pester/Pester)
- [PScribo](https://github.com/iainbrighton/PScribo)

# Usage

Format-Pester is a PowerShell module so it has to be imported before using it - you can find more instructions in the [wiki](https://github.com/equelin/Format-Pester/wiki/Importing-Format-Pester).

## Example 1

```PowerShell
  Invoke-Pester -PassThru | Format-Pester -Path . -Format HTML,Word,Text
```

This command will document the results of the Pester's tests. Documents will be stored in the current path and they will be available in 3 formats (.html,.docx and .txt).

## Example 2

```PowerShell
    Invoke-Pester -PassThru | Export-Clixml -Path .\Test-Result.xml

    Import-Clixml -Path .\Test-Result.xml | Format-Pester -Format .\ -BaseFileName Test-Result -Format HTML -FailedOnly
```

You can run the first command on a server where PScribo and Format-Pester are not installed. The tests results object will be stored in a xmf file.

After copying the file to the computer where PScribo and Format-Pester are available you can generate a report. In this example, the HTML file will be generated with results of failed tests only.

## Online help

You can read [online version of help](/doc/Format-Pester.md) - online help generated by [platyPS module](https://github.com/powershell/platyps).

# Initial author

- Erwan Quélin - [GitHub](https://github.com/equelin) - [Twitter](https://twitter.com/erwanquelin)

# Contributors

- Travis Plunk - [GitHub](https://github.com/TravisEz13) - [Twitter](https://twitter.com/TravisPlunk)
- Wojciech Sciesinski - [GitHub](https://github.com/it-praktyk) - [Twitter](https://twitter.com/ITpraktyk)

# [Version history](VERSIONS.md)

# [TODO and development plans](TODO.md)

# License

Copyright 2016-17 Erwan Quelin and the community.  
Licensed under [the MIT License](LICENSE)
