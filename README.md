
Шаблон приложения был создан основе инструкции: https://nextjs.org/docs/api-reference/create-next-app

Командой npx create-next-app@latest

Создание образа: 	sudo docker build -t webapp .
Запуск контейнера:	sudo docker run -d 3000:3000 webapp

user@user-def:~/development/github/dev_ops/nextappdocker/app$ sudo docker run -p  3000:3000 webapp 
Listening on port 3000 url: http://localhost:3000


user@user-def:~$ curl http://localhost:3000 -i
HTTP/1.1 200 OK
X-Powered-By: Next.js
ETag: "j4tw0xd7hc271"
Content-Type: text/html; charset=utf-8
Content-Length: 2853
Vary: Accept-Encoding
Date: Sun, 20 Nov 2022 19:15:35 GMT
Connection: keep-alive
Keep-Alive: timeout=5

(тело html страницы).




* dev-loop (сохранение конда вызывает пересборку)
Реализовано через редактирование файла .git/hooks/pre-commit.sample.
# Если хотите пересобрать образ
sudo docker-compose up --build -d 

# Если хотите пересобрать проект. 
sudo npx next dev

возможно выбрать, что конкретно вы подразумеваете под "пересборкой". Если образа, то первая команда, проекта - вторая.

* Единый Dockerfile 
лежит в репозитории.

* мультистедж-сборка
_ далее пиведены три строки - начала для разных типов сборок: deps, builder, runner
 - FROM node:16-alpine AS deps
 
или Мультистедж сборка для билда
 - FROM node:16-alpine AS builder
 
или Мультистейдж сборка для продакшена
- FROM node:16-alpine AS runner

* package.lock и package-lock.json в репозитории
в репозитории

* ффективное кеширование на уровне докерфайла; 
достигается через команду "RUN apk add --no-cache libc6-compat" для сборки "deps"









