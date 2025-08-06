# DelivX Setup Script for Windows
Write-Host "🚀 Configurando o projeto DelivX..." -ForegroundColor Green

# Verificar se o Ruby está instalado
if (!(Get-Command ruby -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Ruby não encontrado. Por favor, instale o Ruby 3.0.0 ou superior." -ForegroundColor Red
    exit 1
}

# Verificar se o Bundler está instalado
if (!(Get-Command bundle -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Instalando Bundler..." -ForegroundColor Yellow
    gem install bundler
}

# Navegar para o diretório do backend
Set-Location backend

Write-Host "📦 Instalando gems..." -ForegroundColor Yellow
bundle install

Write-Host "🗄️  Criando banco de dados..." -ForegroundColor Yellow
rails db:create

Write-Host "🔄 Executando migrações..." -ForegroundColor Yellow
rails db:migrate

Write-Host "🌱 Populando banco com dados de exemplo..." -ForegroundColor Yellow
rails db:seed

Write-Host "✅ Configuração concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "Para iniciar o servidor Rails:" -ForegroundColor Cyan
Write-Host "  cd backend" -ForegroundColor White
Write-Host "  rails server" -ForegroundColor White
Write-Host ""
Write-Host "Para abrir o frontend:" -ForegroundColor Cyan
Write-Host "  Abra frontend/index.html no navegador" -ForegroundColor White
Write-Host "  ou execute um servidor local na pasta frontend" -ForegroundColor White
Write-Host ""
Write-Host "🎉 DelivX está pronto para uso!" -ForegroundColor Green
