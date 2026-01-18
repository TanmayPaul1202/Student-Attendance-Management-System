@echo off
REM Import attendancemsystem.sql into MySQL. Update user/password if needed.
REM Usage: double-click this file or run from command prompt in project root.

SET DB_NAME=attendancemsystem
SET SQL_PATH="DATABASE FILE\attendancemsystem.sql"

REM If your MySQL root user has a password, change the next line accordingly (e.g., -u root -pYourPassword)
mysql -u root %DB_NAME% < %SQL_PATH%

IF %ERRORLEVEL% EQU 0 (
  echo Import completed successfully.
) ELSE (
  echo Import failed. Check MySQL path/credentials and that the SQL file exists at %SQL_PATH%.
)
pause
