#Please read the section 'Information for translators' on the GitHub project page
#Read also Get-Help about_Script_Internationalization

#The language en-US file prepared by Wojciech Sciesinski, wojciech[at]sciesinski[dot]net
#String aligned to version - see the value of msgA000

#Translate values, don't touch 'msgxxxx' fields !

# Groups of translation strings
# A = general
# X - temporary deprecation messages
# B = passed tests
# C = failed tests
# D = skipped tests
# E = pending tests
# F = inconclusive tests

# culture = "en-US"
ConvertFrom-StringData @'
    msgA000 = 1.5.0
    msgA001 = Table of Contents
    msgA002 = Total Tests
    msgA003 = Passed Tests
    msgA004 = Failed Tests
    msgA005 = Skipped Tests
    msgA006 = Pending Tests
    msgA007 = Inconclusive Tests
    msgA008 = Results summary
    msgA009 = Evaluating tests results for
    msgA010 = Describe
    msgA011 = Context
    msgA012 = Name
    msgA013 = The language
    msgA014 = is not supported. Language en-US will be used.
    msgA015 = Version of used language file is different than than version of Format-Pester.ps1 file. Some texts can not be displayed correctly.
    msgA016 = Performing action for
    msgA017 = amount of results
    #Type of encoding used for write text files
    #Suppurted vales: ASCII,Unicode,UTF7,UTF8
    msgA018 = ASCII
    msgA019 = Value of the parameter PesterResult can't be null or empty.
    msgA020 = The test result named: '{0}' is duplicated in the ResultOrder parameter values. It will be skipped to avoid duplicating of a report section.
    msgA021 = The test result named: '{0}' in unrecognized and will not be included in a report.
    msgA022 = Documents will be exported with options:
    msgX001 = The parameter '{0}' is deprecated and will be removed in the further version of Format-Pester. Please use the parameters Include instead.
    msgX002 = The parameter Order is deprecated and will be removed in the further version of Format-Pester. Please use the parameter ResultOrder instead."
    msgX003 = The parameter PassedFirst parameter was used but passed results are not included in the report.
    msgX004 = The parameter FailedFirst parameter was used but failed results are not included in the report.
    msgB000 = Passed
    msgB001 = Details for passed tests
    msgB002 = Details for passed tests by Describe block:
    msgB003 = Details for passed tests by Context block:
    msgB004 = Found passed tests in Describe blocks
    msgB005 = Found passed tests in Context block
    msgB006 = NOT_EXISTS
    msgB007 = Passed tests
    msgC000 = Failed
    msgC001 = Details for failed tests
    msgC002 = Details for failed tests by Describe block:
    msgC003 = Details for failed tests by Context block:
    msgC004 = Found failed tests in Describe blocks
    msgC005 = Found failed tests in Context blocks
    msgC006 = Failure Message
    msgC007 = Failed tests
    msgD000 = Skipped
    msgD001 = Details for skipped tests
    msgD002 = Details for skipped tests by Describe block:
    msgD003 = Details for skipped tests by Context block:
    msgD004 = Found skipped tests in Describe blocks
    msgD005 = Found skipped tests in Context blocks
    msgD006 = Skip Message
    msgD007 = Skipped Tests
    msgE000 = Pending
    msgE001 = Details for pending tests
    msgE002 = Details for pending tests by Describe block:
    msgE003 = Details for pending tests by Context block:
    msgE004 = Found pending tests in Describe blocks
    msgE005 = Found pending tests in Context blocks
    msgE006 = Pending Message
    msgE007 = Pending Tests
    msgF000 = Inconclusive
    msgF001 = Details for inconclusive tests
    msgF002 = Details for inconclusive tests by Describe block:
    msgF003 = Details for inconclusive tests by Context block:
    msgF004 = Found inconclusive tests in Describe blocks
    msgF005 = Found inconclusive tests in Context blocks
    msgF006 = Inconclusive Message
    msgF007 = Inconclusive Tests
'@
