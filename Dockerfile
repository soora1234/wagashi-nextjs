FROM node:24

WORKDIR /app

# Copy everything first (we ignore local node_modules via .dockerignore)
COPY . .

# Install pnpm and project dependencies
RUN npm install -g pnpm && \
	pnpm install --frozen-lockfile

# Build the application
RUN pnpm build

# ENTRYPOINT ["/app/setup.sh"]

EXPOSE 3000

CMD ["pnpm", "start"]
