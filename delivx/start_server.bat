@echo off
echo 🚀 Iniciando servidor DelivX...
echo.

cd /d "c:\Delivery\delivx\backend"

echo Verificando se estamos no diretório correto...
if not exist "Gemfile" (
    echo ❌ Erro: Não foi possível encontrar o Gemfile
    echo Certifique-se de que está no diretório correto: c:\Delivery\delivx\backend
    pause
    exit /b 1
)

echo ✅ Gemfile encontrado!
echo.

echo Instalando dependências...
call bundle install
if errorlevel 1 (
    echo ❌ Erro ao instalar dependências
    pause
    exit /b 1
)

echo.
echo 🗄️ Verificando banco de dados...
call bundle exec rails db:create 2>nul
call bundle exec rails db:migrate
if errorlevel 1 (
    echo ❌ Erro nas migrações
    pause
    exit /b 1
)

echo.
echo 🌱 Populando dados de exemplo...
call bundle exec rails db:seed

echo.
echo 🚀 Iniciando servidor na porta 3000...
echo ✅ Acesse: http://localhost:3000/api/v1/restaurants
echo ✅ Frontend: Abra c:\Delivery\delivx\frontend\index.html no navegador
echo.
echo Pressione Ctrl+C para parar o servidor
echo.

call bundle exec rails server -p 3000
pause
