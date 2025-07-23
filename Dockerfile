FROM node:18-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json* ./ 
RUN npm install

COPY . .

RUN npm run build

FROM node:18-alpine AS runner

WORKDIR /app

COPY --from=deps /app/.next .next
COPY --from=deps /app/public public
COPY --from=deps /app/package.json .
COPY --from=deps /app/node_modules node_modules
COPY --from=deps /app/prisma prisma

EXPOSE 8080

ENV PORT=8080

CMD ["npm", "start"]