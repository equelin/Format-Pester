$script:mockedTestResultCount =0
function New-MockedTestResult 
{
    param(
        [ValidateSet('Passed','Failed')]
        [String] $Result = 'Passed'
    )

    $script:mockedTestResultCount++;
    $testResult = [PSCustomObject] @{
                    Describe ="Mocked Describe ${script:mockedTestResultCount}"
                    Context = $null
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
Describe 'Format-Pester' {
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
        $mockedTestResult = [PSCustomObject] @{
            PassedCount =1
            FailedCount =1
            TotalCount =2
            TestResult = @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
    
            )
        }
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
        $mockedTestResult = [PSCustomObject] @{
            PassedCount =1
            FailedCount =1
            TotalCount =2
            TestResult = @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
    
            )
        }
        Mock -CommandName Export-Document  -MockWith {} -ModuleName Format-Pester 

        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format Word} | Should not throw
        }

        it 'should have called export document without NoPageLayoutStyle option' {
            Assert-MockCalled -CommandName Export-Document -ModuleName Format-Pester -ParameterFilter {!$options.NoPageLayoutStyle}
        }
    }

    Context 'Format Text' {
        $mockedTestResult = [PSCustomObject] @{
            PassedCount =1
            FailedCount =1
            TotalCount =2
            TestResult = @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
    
            )
        }
        Mock -CommandName Export-Document  -MockWith {} -ModuleName Format-Pester 

        it 'Should not throw'  {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format Text} | Should not throw
        }

        it 'should have called export document without NoPageLayoutStyle option' {
            Assert-MockCalled -CommandName Export-Document -ModuleName Format-Pester -ParameterFilter {!$options.NoPageLayoutStyle} 
        }
    }


    Context 'BaseFileName not specified' {
        $mockedTestResult = [PSCustomObject] @{
            PassedCount =1
            FailedCount =1
            TotalCount =2
            TestResult = @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Failed
    
            )
        }
        $logFolder = 'TestDrive:\logs'
        if(!(Test-path $logFolder))
        {
            md $logFolder > $null
        }
        it 'Should not throw' {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML} | Should not throw
        }
        
        it 'should have used the default, Pester_Results' {
            join-path TestDrive:\logs Pester_Results.Html | should exist
        }
    }
    Context 'Result Processing - all passed' {
        $mockedTestResult = [PSCustomObject] @{
            PassedCount =2
            FailedCount =0
            TotalCount =2
            TestResult = @(
                New-MockedTestResult -Result Passed
                New-MockedTestResult -Result Passed
            )
        }

        $logFolder = 'TestDrive:\logs'
        if(!(Test-path $logFolder))
        {
            md $logFolder > $null
        }
        
        # Pending test due to https://github.com/equelin/Format-Pester/issues/1
        it 'should not throw when all results are passed' -Pending {
            {$mockedTestResult | Format-Pester -Path TestDrive:\logs -Format HTML} | should not throw
        }
        
    }
}