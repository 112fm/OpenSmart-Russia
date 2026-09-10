# 🌐 OpenSmart-Russia

**Курируемые списки доменов и IP для раздельной (умной) маршрутизации трафика (Smart Routing) в РФ.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/112fm/OpenSmart-Russia?style=social)](https://github.com/112fm/OpenSmart-Russia)

---

## 🎯 Назначение проекта

При использовании VPN или прокси-туннелей в РФ возникает две проблемы:
1. **Зарубежные сервисы** (YouTube, Instagram, Twitter/X, Discord, ChatGPT, Notion и др.) замедляются или блокируются без туннеля.
2. **Российские сервисы** (Сбер, Т-Банк, Госуслуги, ФНС, Авито, Кинопоиск, Ozon, Wildberries, Mos.ru) блокируют или ограничивают доступ с зарубежных IP-адресов.

**OpenSmart-Russia** решает эту задачу, предоставляя чистые, регулярно обновляемые списки для маршрутизации по принципу:
* 🇷🇺 **Российские сервисы (Direct)** — идут напрямую через вашего провайдера на максимальной скорости и без капч.
* 🌍 **Зарубежные ресурсы (Proxy / VPN)** — направляются в защищенный туннель.

---

## 📁 Структура списков

| Файл | Описание | Raw URL (Прямая ссылка) |
| :--- | :--- | :--- |
| **[`direct-domains.txt`](direct-domains.txt)** | **Белый список РФ (Direct)**. Домены ключевых российских банков, госорганов, маркетплейсов и сервисов (включая `.com`, `.net`, `.org`, защищенные QRATOR/WAF). | `https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/direct-domains.txt` |
| **[`proxy-domains.txt`](proxy-domains.txt)** | **Список проксирования (Proxy)**. YouTube, Instagram, X/Twitter, Discord, OpenAI, Anthropic, Notion, торрент-трекеры, запрещенные СМИ. | `https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/proxy-domains.txt` |
| **[`direct-cidrs.txt`](direct-cidrs.txt)** | **Подсети РФ (Direct CIDR)**. Диапазоны IP основных российских инфраструктурных сервисов и CDN. | `https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/direct-cidrs.txt` |
| **[`singbox-ruleset-direct.json`](singbox-ruleset-direct.json)** | Готовый Rule-Set (формат sing-box source) для прямого подключения. | `https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/singbox-ruleset-direct.json` |
| **[`singbox-ruleset-proxy.json`](singbox-ruleset-proxy.json)** | Готовый Rule-Set (формат sing-box source) для выхода через прокси. | `https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/singbox-ruleset-proxy.json` |

---

## 📱 Поддерживаемые клиенты и платформы

Списки универсальны и подходят для любых систем с поддержкой маршрутизации по доменам:

* **Мобильные и десктопные клиенты:**
  * **Karing** (iOS, Android, macOS, Windows)
  * **Insy** (iOS, Android, macOS, Windows)
  * **Hiddify** (все платформы)
  * **V2rayN** / **v2rayNG** / **Nekoray**
  * **Happ** / **Streisand** / **Shadowrocket** / **Loon**
  * **Clash Verge Rev** / **Mihomo Party**

* **Роутеры и серверы:**
  * **OpenWrt** (`sing-box`, `xray-core`, `PassWall`, `OpenClash`)
  * **Keenetic**
  * **MikroTik**

---

## ⚙️ Примеры настройки

### 1. Использование в sing-box (Remote Rule-Set)

Добавьте правила в секцию `route.rule_set` вашей конфигурации `sing-box`:

```json
{
  "route": {
    "rule_set": [
      {
        "tag": "direct-ru",
        "type": "remote",
        "format": "source",
        "url": "https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/singbox-ruleset-direct.json",
        "download_detour": "direct"
      },
      {
        "tag": "proxy-foreign",
        "type": "remote",
        "format": "source",
        "url": "https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main/singbox-ruleset-proxy.json",
        "download_detour": "proxy"
      }
    ],
    "rules": [
      { "rule_set": "direct-ru", "outbound": "direct" },
      { "domain_suffix": [".ru", ".рф", ".su"], "outbound": "direct" },
      { "rule_set": "proxy-foreign", "outbound": "proxy" },
      { "outbound": "proxy" }
    ]
  }
}
```

### 2. Автоматическое обновление на OpenWrt роутерах

В репозитории есть готовый скрипт: [`scripts/update-rules.sh`](scripts/update-rules.sh).

1. Скопируйте скрипт на роутер в `/etc/sing-box/update-rules.sh` и дайте права:
   ```sh
   chmod +x /etc/sing-box/update-rules.sh
   ```
2. Добавьте в планировщик задач OpenWrt (`crontab -e`) запуск раз в неделю (например, по понедельникам в 4 утра):
   ```cron
   0 4 * * 1 /etc/sing-box/update-rules.sh >/dev/null 2>&1
   ```

Скрипт проверяет наличие изменений по контрольным суммам и перезапускает службу маршрутизации только при реальном обновлении списков.

---

## 🤝 Как предложить домен (Contributing)

Если важный сервис перестал открываться или вы хотите добавить новый домен:

1. Откройте **[Pull Request](https://github.com/112fm/OpenSmart-Russia/pulls)** с добавлением домена в алфавитном порядке.
2. Или создайте **[Issue](https://github.com/112fm/OpenSmart-Russia/issues)** с описанием:
   - Домен сайта;
   - В какой список добавить (`direct-domains` или `proxy-domains`);
   - Краткая причина (например: *«Российский сервис доставки, блокирует доступ из-за рубежа»*).

---

## 📄 Лицензия

Проект распространяется под открытой лицензией [MIT](LICENSE).
