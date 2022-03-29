This Join to host process is written to run from an Azure automation account.  It does make several assumptions that I will outline below.

1.  Your Automation account has a Credntial stored called "DomainSvcAccount"
2.  Your automation account is set up with a service principle for it's run as permissions
3.  The service principle has been provided the necessary permissions to the resources to actually add an extension to a VM.
4.  You are hosting the included ARM template in JSON format from an HTTP accessible location that your Runbook worker can reach.  Aka if using azure runbook workers, it needs to be internet facing.  If using hybrid runbook workers you'll need to ensure the hyrbid runbook worker can reach the network path
5.  It also assumes that you have edited lines 50 and 68 to reflect your tennant's configuration.




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
