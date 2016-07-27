#Helpful article http://community.bartdesmet.net/blogs/bart/archive/2008/03/23/windows-powershell-2-0-feature-focus-script-internationalization.aspx
#Write also Get-Help about_Script_Internationalization

#The language file prepared by Wojciech Sciesinski, wojciech[at]sciesinski[dot]net

#Translate values, don't touch 'msgxx' fields !

# culture="en-US"
ConvertFrom-StringData @'
        msg01 = Table of Contents
        msg02 = Total Tests
        msg03 = Passed Tests
        msg04 = Failed Tests
        msg05 = Skipped Tests
        msg06 = Pending Tests
        msg07 = Results summary
        msg08 = Evaluating tests results for
        msg09 = Passed
        msg10 = Details for passed tests
        msg11 = Details for passed tests by Describe block:
        msg12 = Details for passed tests by Context block: 
        msg13 = Found passed tests in Decribe blocks: 
        msg14 = Found passed tests in Describe block: 
        msg15 = Describe
        msg16 = Context
        msg17 = Name
        msg18 = Failed
        msg19 = Details for failed tests
        msg20 = Details for failed tests by Describe block: 
        msg21 = Details for failed tests by Context block: 
        msg22 = Found failed tests in Decribe blocks: 
        msg23 = Found failed in Context blocks: 
        msg24 = Failure Message
        msg25 = Passed tests
        msg26 = Failed tests
'@