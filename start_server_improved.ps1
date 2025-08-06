# DelivX - Script de Inicialização Melhorado
param(
    [switch]$SkipSeed = $false
)

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-ColorOutput Green "🚀 Iniciando servidor DelivX..."
Write-Output ""

# Navegar para o diretório do backend
$backendPath = "c:\Delivery\delivx\backend"
if (Test-Path $backendPath) {
    Set-Location $backendPath
    Write-ColorOutput Green "✅ Navegando para: $backendPath"
} else {
    Write-ColorOutput Red "❌ Erro: Diretório não encontrado: $backendPath"
    exit 1
}

# Verificar se o Gemfile existe
if (-not (Test-Path "Gemfile")) {
    Write-ColorOutput Red "❌ Erro: Gemfile não encontrado"
    Write-ColorOutput Yellow "Certifique-se de que está no diretório correto"
    exit 1
}

Write-ColorOutput Green "✅ Gemfile encontrado!"
Write-Output ""

# Instalar dependências
Write-ColorOutput Yellow "📦 Instalando dependências..."
try {
    & bundle install
    if ($LASTEXITCODE -ne 0) {
        throw "Erro ao instalar dependências"
    }
    Write-ColorOutput Green "✅ Dependências instaladas com sucesso!"
} catch {
    Write-ColorOutput Red "❌ Erro ao instalar dependências: $_"
    exit 1
}

Write-Output ""

# Verificar e configurar banco de dados
Write-ColorOutput Yellow "🗄️ Configurando banco de dados..."
try {
    # Criar banco se não existir
    & bundle exec rails db:create 2>$null
    
    # Executar migrações
    & bundle exec rails db:migrate
    if ($LASTEXITCODE -ne 0) {
        throw "Erro nas migrações"
    }
    
    Write-ColorOutput Green "✅ Banco de dados configurado!"
} catch {
    Write-ColorOutput Red "❌ Erro ao configurar banco: $_"
    exit 1
}

# Popular dados de exemplo (opcional)
if (-not $SkipSeed) {
    Write-Output ""
    Write-ColorOutput Yellow "🌱 Populando dados de exemplo..."
    try {
        & bundle exec rails db:seed
        Write-ColorOutput Green "✅ Dados de exemplo criados!"
    } catch {
        Write-ColorOutput Yellow "⚠️ Aviso: Erro ao popular dados (pode ser normal se já existirem)"
    }
}

Write-Output ""
Write-ColorOutput Green "🚀 Iniciando servidor Rails..."
Write-ColorOutput Cyan "✅ API estará disponível em: http://localhost:3000/api/v1"
Write-ColorOutput Cyan "✅ Teste: http://localhost:3000/api/v1/restaurants"
Write-ColorOutput Cyan "✅ Frontend: Abra c:\Delivery\delivx\frontend\index.html no navegador"
Write-Output ""
Write-ColorOutput Yellow "Pressione Ctrl+C para parar o servidor"
Write-Output ""

# Iniciar servidor
try {
    & bundle exec rails server -p 3000 -b 0.0.0.0
} catch {
    Write-ColorOutput Red "❌ Erro ao iniciar servidor: $_"
    Write-Output ""
    Write-ColorOutput Yellow "Tente executar manualmente:"
    Write-ColorOutput White "cd c:\Delivery\delivx\backend"
    Write-ColorOutput White "bundle exec rails server"
}

Write-Output ""
Write-ColorOutput Green "Pressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
