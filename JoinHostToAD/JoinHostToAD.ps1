##Join existing VM to a domain using a JoinDomian Arm Template.

<#
MIT License

Copyright (c) 2022 taboc741

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

#>
param (
    [Parameter (Mandatory = $true)]
    [string] $vmList,
    [Parameter (Mandatory = $true)]
    [string] $virtualMachineRG,
    [Parameter (Mandatory = $true)]
    [string] $location,
    [Parameter (Mandatory = $true)]
    [string] $Subscription,
    [Parameter (Mandatory = $true)]
    [string] $domainFQDN,
    [Parameter (Mandatory = $true)]
    [string] $OUPath

)


#build the Join Domain parameters
Import-Module Az.resources -ErrorAction SilentlyContinue
Import-Module Az.Compute -ErrorAction SilentlyContinue

# Verify the user is logged in
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
$Tenant = "<InsertAzureTennantID here>" #Azure tenant ID
 
#output Con Details
Write-Output @"
`$Conn details are:
$Conn.ApplicationID
$Conn.TenantID
"@

#import Service principle details
#Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
#connect to Azure
Connect-AzAccount -Tenant $Tenant -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint -ServicePrincipal -Subscription $Subscription


#fetch local AD svc admin creds from automation Credential vault
$ADSApass = (Get-AutomationPSCredential -Name 'DomainSvcAccount')

$joinDomainTemplateURI = "<insert URL Path to Template here>/Join-VM-to-Domain.json"

$JoinADtemplateParameterObject = @{

    vmlist = $vmList
    location = $location
    domainJoinUserName = "$($ADSApass.UserName)"
    domainFQDN = $domainFQDN
    ouPath = $ouPath
}
#execute the extension Template

New-AzResourceGroupDeployment `
-ResourceGroupName $virtualMachineRG `
-TemplateUri $joinDomainTemplateURI `
-TemplateParameterObject $JoinADtemplateParameterObject `
-domainJoinUserPassword $($ADSApass.Password)
