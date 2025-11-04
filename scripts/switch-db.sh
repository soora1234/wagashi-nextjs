#!/bin/bash

# データベース切り替えスクリプト
# 使用方法: ./scripts/switch-db.sh [local|supabase]

MODE=$1

if [ "$MODE" = "local" ]; then
    # ローカルDB設定
    echo "Switching to local PostgreSQL database..."
    cat > .env.local << EOL
# Database (Local PostgreSQL)
DATABASE_URL="postgresql://wagashi_user:wagashi_password@localhost:5432/wagashi_simulator"
DIRECT_URL="postgresql://wagashi_user:wagashi_password@localhost:5432/wagashi_simulator"

# NextAuth.js
NEXTAUTH_SECRET="development-secret-key"
NEXTAUTH_URL="http://localhost:3000"

# App
NODE_ENV="development"

# Supabase (開発用ダミー値)
NEXT_PUBLIC_SUPABASE_URL="http://localhost:54321"
NEXT_PUBLIC_SUPABASE_ANON_KEY="dummy-key"
SUPABASE_SERVICE_ROLE_KEY="dummy-key"
SUPABASE_PROJECT_ID="dummy-id"
EOL
    echo "Local database configuration has been set."
    echo "Please ensure PostgreSQL is running locally with:"
    echo "  - Database: wagashi_simulator"
    echo "  - User: wagashi_user"
    echo "  - Password: wagashi_password"
    echo "You can start the local database using: docker compose up postgres"

elif [ "$MODE" = "supabase" ]; then
    if [ ! -f .env.supabase ]; then
        echo "Error: .env.supabase file not found."
        echo "Please create .env.supabase with your Supabase credentials first."
        exit 1
    fi
    echo "Switching to Supabase database..."
    cp .env.supabase .env.local
    echo "Supabase configuration has been set."

else
    echo "Error: Invalid mode. Use 'local' or 'supabase'"
    echo "Usage: ./scripts/switch-db.sh [local|supabase]"
    exit 1
fi

# Prismaクライアントの再生成
echo "Regenerating Prisma client..."
pnpm db:generate

echo "Done! Database configuration has been switched to $MODE mode."