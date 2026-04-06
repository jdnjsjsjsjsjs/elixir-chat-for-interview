# 💬 Elixir Chat (OTP)

Простой чат на Elixir с использованием OTP (GenServer, Supervisor и процессы).

---

## 🚀 Возможности

* Отправка сообщений всем (broadcast)
* Приватные сообщения между пользователями
* Подключение пользователей
* Автоматическое удаление при выходе (process monitoring)

---

## 🏗 Как устроено

* `ChatServer` — GenServer, хранит пользователей и рассылает сообщения
* `ChatClient` — отдельный процесс пользователя
* Supervisor — следит за сервером
* Используется обмен сообщениями между процессами (`send/receive`)

---

## ▶️ Запуск

```bash
iex -S mix
```

---

## 👤 Создать пользователей

```elixir
alice = ChatClient.start("Alice")
bob = ChatClient.start("Bob")
```

---

## 💬 Отправить сообщение всем

```elixir
ChatClient.send_message(alice, "Hello!")
```

---

## 🔒 Приватное сообщение

```elixir
ChatClient.send_private(alice, "Bob", "Hi Bob!")
```

---

## 📋 Список пользователей

```elixir
ChatServer.list_users()
```

---

## 📌 Примечание

Это учебный проект для изучения Elixir и OTP.
