$script:mockedTestResultCount =0
function New-MockedTestResult
{
    param(
        [ValidateSet('Passed', 'Failed', 'Skipped', 'Pending', 'Inconclusive')]
        [String] $Result = 'Passed'
    )

    $script:mockedTestResultCount++;
    $testResult = [PSCustomObject] @{
                    Describe ="Mocked Describe ${script:mockedTestResultCount}"
                    Context = 'Test Context'
                    Name = "Mocked test ${script:mockedTestResultCount}"
                    Result = $Result
                    Time = New-TimeSpan -Seconds 1
                    FailureMessage = $null
                    StackTrace = $null
                    ErrorRecord = $null
                    ParameterizedSuiteName = $null
                    Parameters = $null
                }

    return $testResult
}

function New-MockedTestResultCollection
{
    param(
        [int] $passedCount = 0,
        [int] $failedCount = 0,
        [int] $skippedCount = 0,
        [int] $pendingCount = 0,
        [int] $inconclusiveCount = 0,
        [object[]] $testResult
    )
        $mockedTestResult = [PSCustomObject] @{
            PassedCount = $passedCount
            FailedCount = $failedCount
            SkippedCount = $skippedCount
            PendingCount = $pendingCount
            InconclusiveCount = $inconclusiveCount
            TotalCount = $passedCount+$failedCount+$skippedCount+$pendingCount+$inconclusiveCount
            TestResult = $testResult
        }
        return $mockedTestResult
}

Describe 'Unit tests for Format-Pester' {
    BeforeAll {
        # Backup the default parameters so we can restor them
        # It must be a clone because it is an object, otherwise updates will update this
        # reference
        $script:OriginalPSDefaultParameterValues = $Global:PSDefaultParameterValues.Clone()

        # If BeforeAll fails, Skip everything
        $Global:PSDefaultParameterValues["It:Skip"]=$true
        Get-Module Format-Pester -ErrorAction SilentlyContinue | Remove-Module
        it 'Format-Pester should load without error' -Skip:$false {
            {Import-Module "$PSScriptRoot\..\..\Format-Pester" -Force -Scope Global} | should not throw
            Get-Module Format-Pester | should not be null

            # Since BeforeAll has passed, set skip to false
            $Global:PSDefaultParameterValues["It:Skip"]=$false
        }
    }

    AfterAll{
        $Global:PSDefaultParameterValues = $script:OriginalPSDefaultParameterValues
    }

    Context 'Format HTML' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 -skippedCount 1 -pendingCount 1 -InconclusiveCount 1 `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Skipped
                New-MockedTestResult -Result Pending
                New-MockedTestResult -Result Inconclusive
            )

        Mock -CommandName Export-Document  -MockWith {} -ModuleName Format-Pester

        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML} | Should not throw
        }

        it 'should have called export document with NoPageLayoutStyle option' {
            Assert-MockCalled -CommandName Export-Document -ModuleName Format-Pester -ParameterFilter {
                $true -eq $options.NoPageLayoutStyle
            }
        }
    }

    Context 'Format Word' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 -skippedCount 1 -pendingCount 1 -InconclusiveCount 1  `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Skipped
                New-MockedTestResult -Result Pending
                New-MockedTestResult -Result Inconclusive
            )

        Mock -CommandName Export-Document  -MockWith {} -ModuleName Format-Pester

        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format Word} | Should not throw
        }

        it 'should have called export document without NoPageLayoutStyle option' {
            Assert-MockCalled -CommandName Export-Document -ModuleName Format-Pester -ParameterFilter {!$options.NoPageLayoutStyle}
        }
    }

    Context 'Format Text' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 -skippedCount 1 -pendingCount 1 -InconclusiveCount 1  `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Skipped
                New-MockedTestResult -Result Pending
                New-MockedTestResult -Result Inconclusive
            )

        Mock -CommandName Export-Document  -MockWith {} -ModuleName Format-Pester

        it 'Should not throw'  {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format Text} | Should not throw
        }

        it 'should have called export document without NoPageLayoutStyle option' {
            Assert-MockCalled -CommandName Export-Document -ModuleName Format-Pester -ParameterFilter {!$options.NoPageLayoutStyle}
        }
    }

    Context 'Format Word and HTML' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 -skippedCount 1 -pendingCount 1 -InconclusiveCount 1  `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Skipped
                New-MockedTestResult -Result Pending
                New-MockedTestResult -Result Inconclusive
            )

        Mock -CommandName Export-Document  -MockWith {} -ModuleName Format-Pester

        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format Word, HTML} | Should not throw
        }

        it 'should have called export document without NoPageLayoutStyle option' {
            Assert-MockCalled -CommandName Export-Document -ModuleName Format-Pester -ParameterFilter {$options.NoPageLayoutStyle}
        }
    }

    Context 'BaseFileName specified' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 -skippedCount 1 -pendingCount 1 -InconclusiveCount 1  `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Skipped
                New-MockedTestResult -Result Pending
                New-MockedTestResult -Result Inconclusive
            )

        $logFolder = 'TestDrive:\logs'
        if(!(Test-path $logFolder))
        {
            New-Item -Path $logFolder -ItemType Container | Out-Null
        }
        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -BaseFileName TestBaseName -Format HTML} | Should not throw
        }
        # does not exist in this version
        it 'should have used the test base name' {
            join-path TestDrive:\logs TestBaseName.Html | should exist
        }
    }

    Context 'BaseFileName not specified' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 -skippedCount 1 -pendingCount 1 -InconclusiveCount 1  `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Skipped
                New-MockedTestResult -Result Pending
                New-MockedTestResult -Result Inconclusive
            )

        $logFolder = 'TestDrive:\logs'
        if(!(Test-path $logFolder))
        {
            New-Item -Path $logFolder -ItemType Container | Out-Null
        }
        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML} | Should not throw
        }

        it 'should have used the default, Pester_Results' {
            join-path TestDrive:\logs Pester_Results.Html | should exist
        }
    }

    Context 'Result Processing - all passed' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 2 -failedCount 0 `
            -testResult @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Passed
            )

        $logFolder = 'TestDrive:\logs'
        if(!(Test-path $logFolder))
        {
            New-Item -Path $logFolder -ItemType Container | Out-Null
        }

        # Pending test due to https://github.com/equelin/Format-Pester/issues/1
        it 'should not throw when all results are passed' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML} | should not throw
        }

    }

    Context 'Result Processing - all failed' {
        $mockedTestResult = New-MockedTestResultCollection -passedCount 0 -failedCount 2 `
            -testResult @(
                New-MockedTestResult -Result Failed
                New-MockedTestResult -Result Failed
            )

        $logFolder = 'TestDrive:\logs'
        if(!(Test-path $logFolder))
        {
            New-Item -Path $logFolder -ItemType Container | Out-Null
        }

        # Pending test due to https://github.com/equelin/Format-Pester/issues/1

        it 'should not throw when all results are failed' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML} | should not throw
        }

    }

    Context 'Parameters checking' {

        $mockedTestResult = New-MockedTestResultCollection -passedCount 1 -failedCount 1 `
                                                           -testResult @(
            New-MockedTestResult -Result Passed
            New-MockedTestResult -Result Failed
        )

        it 'should throw when parameters from the different parameters sets provided' {
            { $mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML -PassedOnly -FailedOnly } | should throw
        }

    }
}
