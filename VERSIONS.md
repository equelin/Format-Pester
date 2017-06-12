#Format-Pester - history of versions

## 1.0.0 - 2016-06-16

## 1.1.0 - 2016-07-04

## 1.2.0 - 2016-07-20

## 1.3.0 - 2016-08-14

## 1.3.1 - 2016-08-14

- Fix: added explicit Throw for null or empty PesterResult parameter
- verbose messages updated
- validateSet for the Format parameter added/uncommented
- names in code cleaned

## 1.3.3 - 2016-08-20

- Fix issue #14

##  1.4.0 - 2016-09-04

- Fix issue #12
- Updates
  - help: descriptions of INPUTS, OUTPUTS added
  - possibility to dump the PScribo Document object added

## 1.4.1 - 2016-12-04

- Updates
  - help: an example added, link to PScribo added
  - module manifest: added link to the VERSION.md

## 1.4.2 - 2017-05-10

- Fix
  - errors in translations en-US, pl-PL
- Updates
  - Tests for style rules added
  - Code cleaned, mostly removing of trailing spaces, replacing tabs->spaces

## 1.5.0 - 2017-06-11

- Fix
  - corrected behaviour when the parameter PassedOnly is used - #25
  - incorrectly created aand used the variable Options for the PScribo Export-document - #27, #28
  - Polish translation corrected
- Updates
  - Added support for Skipped, Pending, Inconclusive tests results
  - Parameters related to sorting of sections changed: the parameter ResultsOrder added, the parameter Order deprecated
  - Parameters to skipping/including sections changed: the parameter Include added, the parameter FailedOnly, Passed only deprecated
  - Added support for returning refecences to created files - the PassThru parameter
  - the structure of translations files changed
  - formating of document sections updated