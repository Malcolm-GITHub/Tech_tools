# Tech_tools
This repository contains a collection of scripts and ideas to simplify pc maintenance
New additions / scripts / tool links etc are added over time as pre and new releases
Examples include
Powershell / choco / winget / etc and usefull websites

How to access and usage scenario ::

The powershell script releases hosted on Github cannot be run directly using Invoke-RestMethod or Invoke-WebRequest within powershell
due to the http meta-redirect issues. To circumvent this I have created a cloudflare worker which is hosted on http://cloudflare.com 
that redirects the powershell Invoke-RestMethod or Invoke-Webrequest to my Github repository as a RAW http request.

Basically if you really wanted to you can download the script and run locally by accessing the correct GitHub page in a browser :/

Better idea :: Open (Powershell) >Invoke-RestMethod https://tinyurl.com/trixit | Invoke-Expression
If needed   :: Open (Powershell) > Invoke-WebRequest -UseBasicParsin https://tinyurl.com/trixit | Invoke-Expression
shortest possible run command :: (Powershell) >irm tinyurl.com/trixit | iex

tinyurl.com/trixit >>> This will redirect your IRM request to my worker hosted at cloudflare >>> The worker will send the RAW request to my GitHub repository >>> Script will load and run.

Note :: The script will also download the neccessary files and libraries (Anything is possible here)

