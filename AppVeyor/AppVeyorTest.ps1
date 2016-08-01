﻿#---------------------------------# 
# Header                          # 
#---------------------------------# 
Write-Host 'Running AppVeyor build script' -ForegroundColor Yellow
Write-Host "Current working directory: $pwd"

#---------------------------------# 
# Run Pester Tests                # 
#---------------------------------# 
$testResultsFile = '.\TestsResults.xml'
$res             = Invoke-Pester -Script .\Tests\Demo.Tests.ps1 -OutputFormat NUnitXml -OutputFile $testResultsFile -PassThru

Write-Host 'Uploading results'
(New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $testResultsFile))

#---------------------------------# 
# Validate                        # 
#---------------------------------# 
if ($res.FailedCount -gt 0) { 
    throw "$($res.FailedCount) tests failed."
}