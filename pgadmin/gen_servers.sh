#!/bin/sh

if [ ! -f /var/lib/pgadmin/pgpass ]; then
  cat > /var/lib/pgadmin/pgpass <<EOF
  server:5432:*:${POSTGRES_USER}:${PGADMIN_DEFAULT_PASSWORD_FILE}
  server:5432:${USER_DB}:${USER_NAME}:${USER_PASS}
EOF
  chmod 600 /var/lib/pgadmin/pgpass
fi

# Using sed (gnu)
DISPLAY_NAME=$(echo "$USER_NAME" | sed 's/\b\(.\)/\U\1/g')

# More portable with awk
DISPLAY_NAME2=$(echo "$USER_NAME" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')

if [ ! -f /tmp/servers.json ]; then
  cat > /tmp/servers.json <<EOF
  {
    "Servers": {
      "1": {
        "Name": "Postgres (admin)",
        "Group": "Servers",
        "Host": "server",
        "Port": 5432,
        "MaintenanceDB": "${POSTGRES_DB}",
        "Username": "${POSTGRES_USER}",
        "PassFile": "/var/lib/pgadmin/pgpass",
        "SSLMode": "prefer"
      },
      "2": {
        "Name": "${DISPLAY_NAME}",
        "Group": "Servers",
        "Host": "server",
        "Port": 5432,
        "MaintenanceDB": "${USER_DB}",
        "Username": "${USER_NAME}",
        "PassFile": "/var/lib/pgadmin/pgpass",
        "SSLMode": "prefer"
      }
    }
  }
EOF
fi

