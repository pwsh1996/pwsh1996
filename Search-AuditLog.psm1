#################################################################################################
# This is a tooled version of SearchAuditLog.ps1 For use in more live situations, original can  #
# be found https://docs.microsoft.com/en-us/microsoft-365/compliance/audit-log-search-script    #
#                                                                                               #
# by: Jacob Petrie                                                                              #
#################################################################################################

function Search-AuditLog {
    <#
    .SYNOPSIS
        A wrapper for Search-UnifiedAuditLog that can be used for searching larger amounts of logs
    .EXAMPLE
        Search-AuditLog AzureActiveDirectory -start "03-22-2022" -end "03-24-2022"
        
        This will search for Audit Logs in AAD from March 22nd to the 24th
    .PARAMETER record
        Specifies the record type of the audit activities (also called operations) to search for. This property indicates the service or feature that an activity was triggered in. For a list of record types that you can use for this variable, https://docs.microsoft.com/en-us/office/office-365-management-api/office-365-management-activity-api-schema#auditlogrecordtype
    .PARAMETER start
        Specifies the start date of the range for the audit log search. The script will return records for audit activities that occurred within the specified date range.
    .PARAMETER end
        Specifies the end date of the range for the audit log search. The script will return records for audit activities that occurred within the specified date range.
    .PARAMETER logFile
        Specifies the name and location for the log file that contains information about the progress of the audit log search performed. The script writes UTC timestamps to the log file.
    .PARAMETER outputFile
        Specifies the name and location of the CSV file that contains the audit records returned.
    .PARAMETER resultSize
        Specifies the number of results returned each time the Search-UnifiedAuditLog cmdlet is called by the script (called a result set). The value of 5,000 is the maximum value supported by the cmdlet. Leave this value as-is.
    .PARAMETER intervalMinutes
        To help overcome the limit of 5000 records returned, this variable takes the data range you specified and slices it up into smaller time intervals. Now each interval, not the entire date range, is subject to the 5000 record output limit of the command.
    #>

    [CmdletBinding()]
    Param (
        [validateset("ExhangeAdmin", "ExchangeItem", "ExchangeItemGroup", "SharePoint", "SharePointFileOperation", "OneDrive", "AzureActiveDirectory", "AzureActiveDirectoryAccountLogon", "DataCenterSecurityCmdlet", "ComplianceDLPSharePoint", "ComplianceDLPExchange", "SharePointSharingOperation", "AzureActiveDirectoryStsLogon", "SkypeForBusinessPSTNUsage", "SkypeForBusinessUsersBlocked", "SecurityComplianceCenterEOPCmdlet", "ExchangeAggregatedOperation", "PowerBIAudit", "CRM", "Yammer", "SkypeForBusinessCmdlets", "Discovery", "MicrosoftTeams", "ThreatIntelligence", "MailSubmission", "MicrosoftFlow", "AeD", "MicrosoftStream", "ComplianceDLPSharePointClassification", "ThreatFinder", "Project", "SharePointListOperation", "DataGovernance", "Kaizala", "SecurityComplianceAlerts", "ThreatIntelligenceUrl", "SecurityComplianceInsights", "MIPLabel", "WorkplaceAnalytics", "PowerAppsApp", "PowerAppsPlan", "ThreatIntelligenceAtpContent", "LabelContentExplorer", "TeamsHealthcare", "ExchangeItemAggregated", "HygieneEvent", "DataInsightsRestApiAudit", "InformationBarrierPolicyApplication", "SharePointListItemOperation", "SharePointContentTypeOperation", "SharePointFieldOperation", "MicrosoftTeamsAdmin", "HRSignal", "MicrosoftTeamsDevice", "MicrosoftTeamsAnalytics", "InformationWorkerProtection", "Campaign", "DLPEndpoint", "AirInvestigation", "Quarantine", "MicrosoftForms", "ApplicationAudit", "ComplianceSupervisionExchange", "CustomerKeyServiceEncryption", "OfficeNative", "MipAutoLabelSharePointItem", "MipAutoLabelSharePointPolicyLocation", "MicrosoftTeamsShifts", "MipAutoLabelExchangeItem", "CortanaBriefing", "WDATPAlerts", "SensitivityLabelPolicyMatch", "SensitivityLabelAction", "SensitivityLabeledFileAction", "AttackSim", "AirManualInvestigation", "SecurityComplianceRBAC", "UserTraining", "AirAdminActionInvestigation", "MSTIC", "PhysicalBadgingSignal", "AipDiscover", "AipSensitivityLabelAction", "AipProtectionAction", "AipFileDeleted", "AipHeartBeat", "MCASAlerts", "OnPremisesFileShareScannerDlp", "OnPremisesSharePointScannerDlp", "ExchangeSearch", "SharePointSearch", "PrivacyInsights", "MyAnalyticsSettings", "SecurityComplianceUserChange", "ComplianceDLPExchangeClassification", "MipExactDataMatch", "MS365DCustomDetection", "CoreReportingSettings")]
        $record = $null,
        [DateTime]$start = [DateTime]::UtcNow.AddDays(-1),
        [DateTime]$end = [DateTime]::UtcNow,
        $logFile = "C:\AuditLogSearch\AuditLogSearchLog.txt",
        $outputFile = "C:\AuditLogSearch\AuditLogRecords.csv",
        [validaterange(1, 5000)]
        $resultSize = 5000,
        $intervalMinutes = 60
    )

    process {

        ###############################################################
        #  Checks to make sure they are connected to Exchange Online  #  
        ###############################################################
        $hascommand = (get-command -verb search | Where-Object { $_.name -eq "Search-UnifiedAuditLog" })
        if ($hascommand) {}
        else {
            Write-host "You need to Connect to Exchange Online" -ForegroundColor Red
            Write-host "first run " -ForegroundColor Red -NoNewline; Write-Host "Connect-ExchangeOnline"
            Write-Host "to get access to the tools" -ForegroundColor Red
            return 
        }

        [DateTime]$currentStart = $start
        [DateTime]$currentEnd = $start

        Function Write-LogFile ([String]$Message) {
            $final = [DateTime]::Now.ToUniversalTime().ToString("s") + ":" + $Message
            $final | Out-File $logFile -Append
        }

        Write-LogFile "BEGIN: Retrieving audit records between $($start) and $($end), RecordType=$record, PageSize=$resultSize."
        Write-Host "Retrieving audit records for the date range between $($start) and $($end), RecordType=$record, ResultsSize=$resultSize"

        $totalCount = 0
        while ($true) {
            $currentEnd = $currentStart.AddMinutes($intervalMinutes)
            if ($currentEnd -gt $end) {
                $currentEnd = $end
            }

            if ($currentStart -eq $currentEnd) {
                break
            }

            $sessionID = [Guid]::NewGuid().ToString() + "_" + "ExtractLogs" + (Get-Date).ToString("yyyyMMddHHmmssfff")
            Write-LogFile "INFO: Retrieving audit records for activities performed between $($currentStart) and $($currentEnd)"
            Write-Host "Retrieving audit records for activities performed between $($currentStart) and $($currentEnd)"
            $currentCount = 0

            $sw = [Diagnostics.StopWatch]::StartNew()
            do {
                $results = Search-UnifiedAuditLog -StartDate $currentStart -EndDate $currentEnd -RecordType $record -SessionId $sessionID -SessionCommand ReturnLargeSet -ResultSize $resultSize

                if (($results | Measure-Object).Count -ne 0) {
                    $results | export-csv -Path $outputFile -Append -NoTypeInformation

                    $currentTotal = $results[0].ResultCount
                    $totalCount += $results.Count
                    $currentCount += $results.Count
                    Write-LogFile "INFO: Retrieved $($currentCount) audit records out of the total $($currentTotal)"

                    if ($currentTotal -eq $results[$results.Count - 1].ResultIndex) {
                        $message = "INFO: Successfully retrieved $($currentTotal) audit records for the current time range. Moving on!"
                        Write-LogFile $message
                        Write-Host "Successfully retrieved $($currentTotal) audit records for the current time range. Moving on to the next interval." -foregroundColor Yellow
                        ""
                        break
                    }
                }
            }
            while (($results | Measure-Object).Count -ne 0)

            $currentStart = $currentEnd
        }

        Write-LogFile "END: Retrieving audit records between $($start) and $($end), RecordType=$record, PageSize=$resultSize, total count: $totalCount."
        Write-Host "Script complete! Finished retrieving audit records for the date range between $($start) and $($end). Total count: $totalCount" -foregroundColor Green
    }
}

Export-ModuleMember -Function Search-AuditLog
