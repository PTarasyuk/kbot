# KBot

DevOps application from scratch

**KBot** is a Telegram bot written in the Go programming language, utilizing the Cobra-CLI v1.8.0 framework for command handling and Telebot v3.1.4 for integration with the Telegram API.

## Installation

To get started with KBot, clone the repository:

```bash
git clone https://github.com/PTarasyuk/kbot.git
cd kbot
```

To install all necessary dependencies and compile the project, use:

```bash
go get
go build -ldflags "-X="github.com/PTarasyuk/kbot/cmd.appVersion=v1.0.2
```

To test the compiled project, do the following:

```bash
./kbot version
```

as a result, you should get the app's version `v1.0.2`.

## Configuration

Enter your Telegram bot token in silent mode:

```bash
read -s TELE_TOKEN
```

Export the value of the TELE TOKEN variable to the current shell environment.

```bash
export TELE_TOKEN
```

## Running

Run KBot using the following command:

```bash
./kbot start
```

## Link to Telegram bot

[@ptarasyuk_bot](https://t.me/ptarasyuk_bot)

## Usage

```bash
/start hello
```
