# Deploy di mesin ini (43.156.76.9)

- App: Puma via systemd `pokedex.service` → `127.0.0.1:3030`, `RAILS_ENV=production`
- Web: nginx site `pokedex` (`server_name 43.156.76.9`, port 80) → proxy ke Puma
- URL: http://43.156.76.9/
- DB: `storage/production*.sqlite3` (sudah di-seed 24 Pokémon)

## Perintah operasional

```bash
# status / log
sudo systemctl status pokedex --no-pager
sudo journalctl -u pokedex -f

# restart setelah update kode
cd /home/ubuntu/apps/pokedex
git pull
sudo bundle install
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
sudo systemctl restart pokedex

# nginx
sudo nginx -t && sudo systemctl reload nginx
curl -s -o /dev/null -w "%{http_code}\n" http://43.156.76.9/
```

## File server (di luar repo)

- `/etc/systemd/system/pokedex.service`
- `/etc/nginx/sites-enabled/pokedex`
- Log nginx: `/var/log/nginx/pokedex.{access,error}.log`
