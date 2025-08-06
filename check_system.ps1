# Script de Verificação do Sistema DelivX
Write-Host "🔍 Verificando sistema para DelivX..." -ForegroundColor Green
Write-Host ""

# Verificar Ruby
Write-Host "Verificando Ruby..." -ForegroundColor Yellow
try {
    $rubyVersion = ruby --version
    Write-Host "✅ Ruby encontrado: $rubyVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Ruby não encontrado. Instale Ruby 3.0+ primeiro." -ForegroundColor Red
    exit 1
}

# Verificar Bundler
Write-Host "Verificando Bundler..." -ForegroundColor Yellow
try {
    $bundlerVersion = bundle --version
    Write-Host "✅ Bundler encontrado: $bundlerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Bundler não encontrado. Instalando..." -ForegroundColor Yellow
    gem install bundler
    Write-Host "✅ Bundler instalado!" -ForegroundColor Green
}

# Verificar diretório do projeto
Write-Host "Verificando diretório do projeto..." -ForegroundColor Yellow
$projectPath = "c:\Delivery\delivx\backend"
if (Test-Path $projectPath) {
    Write-Host "✅ Diretório do projeto encontrado: $projectPath" -ForegroundColor Green
} else {
    Write-Host "❌ Diretório do projeto não encontrado: $projectPath" -ForegroundColor Red
    exit 1
}

# Verificar Gemfile
Set-Location $projectPath
if (Test-Path "Gemfile") {
    Write-Host "✅ Gemfile encontrado" -ForegroundColor Green
} else {
    Write-Host "❌ Gemfile não encontrado no diretório do projeto" -ForegroundColor Red
    exit 1
}

# Verificar banco de dados
Write-Host "Verificando banco de dados..." -ForegroundColor Yellow
if (Test-Path "db\development.sqlite3") {
    Write-Host "✅ Banco de dados existe" -ForegroundColor Green
} else {
    Write-Host "⚠️ Banco de dados não existe - será criado automaticamente" -ForegroundColor Yellow
}

# Verificar frontend
Write-Host "Verificando frontend..." -ForegroundColor Yellow
$frontendPath = "c:\Delivery\delivx\frontend\index.html"
if (Test-Path $frontendPath) {
    Write-Host "✅ Frontend encontrado: $frontendPath" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend não encontrado: $frontendPath" -ForegroundColor Red
}

# Verificar porta 3000
Write-Host "Verificando porta 3000..." -ForegroundColor Yellow
$port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($port3000) {
    Write-Host "⚠️ Porta 3000 está em uso. O servidor pode usar outra porta." -ForegroundColor Yellow
} else {
    Write-Host "✅ Porta 3000 está disponível" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Verificação concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "Para iniciar o projeto:" -ForegroundColor Cyan
Write-Host "1. Execute: c:\Delivery\delivx\start_server.bat" -ForegroundColor White
Write-Host "2. Abra: c:\Delivery\delivx\frontend\index.html" -ForegroundColor White
Write-Host ""
Write-Host "Pressione qualquer tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
