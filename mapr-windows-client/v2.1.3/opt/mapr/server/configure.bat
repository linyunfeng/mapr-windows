@echo off
setlocal enabledelayedexpansion

rem Configures the Windows client
if not defined MAPR_HOME (
  echo MAPR_HOME is not set. Set MAPR_HOME to the installation folder and run this command.
  goto end
)

set MY_MAPR_HOME=%MAPR_HOME%
set FC=%MY_MAPR_HOME:~0,1%

if [!FC!]==[^"] (
  set MY_MAPR_HOME=%MAPR_HOME:~1,-1%
)

if exist "%MY_MAPR_HOME%\conf\env.bat" (
  call "%MY_MAPR_HOME%\conf\env.bat"
)

set IS_CLIENT=0
set HAS_CLDB=0
set CLDB_LIST=

rem Parse args first
:parseArgs
if "%1" == "" goto parsedArgs
if "%1" == "-c" (
  set IS_CLIENT=1
  goto shift1
)
if "%1" == "-C" (
  if "%HAS_CLDB%" == "1" (
    echo "Argument -C passed twice"
    goto printUsage
  )
  set HAS_CLDB=1
  goto parseCLDBList
)
if "%1" == "-M" (
  goto parseMultiHomeCLDBList
)

rem Print usage and exit
echo Unknown option %1
goto printUsage

:printUsage
echo "Usage: configure.bat  -C <cldbip1[:port1],cldbip2[:port2],cldbipN[:portN]> -c"
goto end

:shift1
shift
goto parseArgs

:parsedArgs
if not "%IS_CLIENT%" == "1" (
  echo "-c option not provided. Re-run the command after specifying the -c option"
  goto printUsage
)

rem Create the conf/mapr-clusters.conf file
if "%CLDB_LIST%" == "" (
  if "%HAS_CLDB%" == "1" (
    echo "-C option did not specify any CLDB nodes"
    goto printUsage
  )
  echo "No CLDB nodes provided. Specify one or more CLDB nodes via the -C option"
  goto printUsage
)

if not exist "%MY_MAPR_HOME%" md "%MY_MAPR_HOME%"
if not exist "%MY_MAPR_HOME%\logs" md "%MY_MAPR_HOME%\logs"
if not exist "%MY_MAPR_HOME%\conf" md "%MY_MAPR_HOME%\conf"

echo my.cluster.com %CLDB_LIST% > "%MY_MAPR_HOME%\conf\mapr-clusters.conf"

:end
goto scriptDone

:parseCLDBList
rem Parse arguments passed to -C option
shift

set CLDB_IP=%1
if "%CLDB_IP%" == "" goto parseArgs
if "%CLDB_IP:~0,1%" == "-" goto parseArgs
set CLDB_LIST=%CLDB_LIST% %CLDB_IP%
goto parseCLDBList

:parseMultiHomeCLDBList
rem Parse arguments passed to -M option
rem Multiple calls can be made. This represents a CLDB with multiple IPs
rem Each IP is separated by a ,

set CLDB_IP=
:continueParseMultiHomeCLDBList
shift
set CLDB_MH_IP=%1
if "%CLDB_MH_IP%" == "" (
  set CLDB_LIST=%CLDB_LIST% %CLDB_IP%
  goto parseArgs
)

if "%CLDB_MH_IP:~0,1%" == "-" (
  set CLDB_LIST=%CLDB_LIST% %CLDB_IP%
  goto parseArgs
)

if "%CLDB_IP%" == "" (
  set CLDB_IP=%CLDB_MH_IP%
) else (
  set CLDB_IP=%CLDB_IP%;%CLDB_MH_IP%
)
goto continueParseMultiHomeCLDBList

:scriptDone
endlocal
