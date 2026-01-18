# Student Attendance Management System - Setup and Run Script
# This script helps set up and run the project

Write-Host "=== Student Attendance Management System Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check for PHP
$phpPath = $null
if (Get-Command php -ErrorAction SilentlyContinue) {
    $phpPath = "php"
    Write-Host "[OK] PHP found in PATH" -ForegroundColor Green
    php --version
} else {
    Write-Host "[WARNING] PHP not found in PATH" -ForegroundColor Yellow
    Write-Host "Checking common installation paths..." -ForegroundColor Yellow
    
    $commonPaths = @(
        "C:\php\php.exe",
        "C:\xampp\php\php.exe",
        "C:\wamp64\bin\php\php8.3.0\php.exe",
        "C:\wamp64\bin\php\php8.2.0\php.exe",
        "C:\wamp64\bin\php\php8.1.0\php.exe",
        "C:\wamp64\bin\php\php8.0.0\php.exe",
        "C:\wamp64\bin\php\php7.4.0\php.exe"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $phpPath = $path
            Write-Host "[OK] Found PHP at: $path" -ForegroundColor Green
            & $path --version
            break
        }
    }
    
    if (-not $phpPath) {
        Write-Host "[ERROR] PHP not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please install PHP:" -ForegroundColor Yellow
        Write-Host "  1. Download XAMPP from https://www.apachefriends.org/" -ForegroundColor White
        Write-Host "  2. Or download WAMP from https://www.wampserver.com/" -ForegroundColor White
        Write-Host "  3. Or install PHP standalone from https://windows.php.net/download/" -ForegroundColor White
        Write-Host ""
        exit 1
    }
}

Write-Host ""

# Check for MySQL
$mysqlPath = $null
if (Get-Command mysql -ErrorAction SilentlyContinue) {
    $mysqlPath = "mysql"
    Write-Host "[OK] MySQL found in PATH" -ForegroundColor Green
} else {
    Write-Host "[WARNING] MySQL not found in PATH" -ForegroundColor Yellow
    Write-Host "Checking common installation paths..." -ForegroundColor Yellow
    
    $commonPaths = @(
        "C:\xampp\mysql\bin\mysql.exe",
        "C:\wamp64\bin\mysql\mysql8.0.37\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $mysqlPath = $path
            Write-Host "[OK] Found MySQL at: $path" -ForegroundColor Green
            break
        }
    }
    
    if (-not $mysqlPath) {
        Write-Host "[WARNING] MySQL not found. You may need to import the database manually." -ForegroundColor Yellow
        Write-Host "  Database file: DATABASE FILE\attendancemsystem.sql" -ForegroundColor White
    }
}

Write-Host ""

# Import database if MySQL is available
if ($mysqlPath) {
    Write-Host "Attempting to import database..." -ForegroundColor Cyan
    $dbFile = "DATABASE FILE\attendancemsystem.sql"
    
    if (Test-Path $dbFile) {
        Write-Host "Creating database if it doesn't exist..." -ForegroundColor Yellow
        & $mysqlPath -u root -e "CREATE DATABASE IF NOT EXISTS attendancemsystem;" 2>&1 | Out-Null
        
        Write-Host "Importing database schema and data..." -ForegroundColor Yellow
        & $mysqlPath -u root attendancemsystem < $dbFile
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Database imported successfully!" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] Database import may have failed. Check MySQL credentials." -ForegroundColor Yellow
            Write-Host "  You can import manually using: $mysqlPath -u root attendancemsystem < `"$dbFile`"" -ForegroundColor White
        }
    } else {
        Write-Host "[ERROR] Database file not found: $dbFile" -ForegroundColor Red
    }
} else {
    Write-Host "[INFO] Skipping database import. Please import manually using phpMyAdmin or MySQL CLI." -ForegroundColor Yellow
}

Write-Host ""

# Start PHP development server
Write-Host "Starting PHP development server..." -ForegroundColor Cyan
Write-Host "Server will be available at: http://localhost:8000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

if ($phpPath) {
    & $phpPath -S localhost:8000 -t .
} else {
    Write-Host "[ERROR] Cannot start server - PHP not found!" -ForegroundColor Red
    exit 1
}
