
FROM node:16-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# В зависимости от используемого пакетного менеджера, устанавливаем зависимости разными способами.
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi


# Мультистедж сборка для билда
FROM node:16-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Отключение телеметрии
ENV NEXT_TELEMETRY_DISABLED 1

# ---- Сборка 
RUN yarn build
# или
# RUN npm run build


# Мультистейдж сборка для продакшена
FROM node:16-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
# Всё равно выключаем телеметрию
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Две мультистедж сборки отличаются друго от друга выбранными к устнаовке в образ пакетами. 
# D ,



USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["node", "server.js"]
