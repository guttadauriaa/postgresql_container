# PostgreSQL container with SSL enabled

This image is build upon the official PostgreSQL Alpine image for enabling SSL/TLS connections.

## Preconfiguration

### Variables

You can modify the .env file to change parameters like :

* **POSTGRES_USER** The desired username for the postgres administrator.
* **POSTGRES_DB** The name of the associated database, keep the same name as **\$POSTGRES_USER**.
* **USER_NAME** The name of a simple user with no special permissions.
* **USER_DB** The name of the associated database, keep the same name as **\$USER_NAME**. ('user' is not allowed)
* **PGADMIN_DEFAULT_EMAIL** The email address used as login with pgAdmin.
* **PGADMIN_REPLACE_SERVERS_ON_STARTUP** Whether or not you want to force the creation of the connection setup in pgAdmin.

If you change PostgreSQL variables, **you must** modify the secrets files :

* **secrets/pgadmin_password.txt** password used for the account **\$PGADMIN_DEFAULT_EMAIL** in pgAdmin.
* **secrets/postgres_password.txt** password used for **\$POSTGRES_USER** on **\$POSTGRES_DB**.
* **secrets/user_password.txt** password used for **\$USER_NAME** account on **\$USER_DB**.


### Generating the certificates with certstrap

Some default self-signed TLS certificates have been created and bundle in this repository.

If you want to generate your own :

First, you need to create self-signed CA and certificates using [certstrap](https://github.com/square/certstrap) from the certs folder.

You can download a compiled binary from the Github Release page.

To build this utility, you need the Go compiler in version 1.18+.

```bash
$ git clone https://github.com/square/certstrap
$ cd certstrap
$ go build
$ cp certstrap /usr/local/bin/
```

Copy the compiled binary **certstrap** in a folder present in your $PATH.

Now, you can return to the postgresql_container directory and run the script create-certificates.sh in the certs folder :

```bash
$ cd ../certs/ 
$ ./create-certificates.sh
```

The generated certs are created in the certs/out/ directory.

These files are incorporated in the custom built PostgreSQL image using Dockerfile : Dockerfile-18.

If you change the certificates after having created the image, you must rebuild it :

```bash
$ docker rmi postgres:18-alpine-ssl 
$ docker compose -f docker-compose-full-18.yml up -d
```

There is also a ps1 script for use with PowerShell on Windows.

## Run and build

These lines uses the new docker compose plugin (Go version).

```bash
$ docker compose -f docker-compose-full-18.yml build
$ docker compose -f docker-compose-full-18.yml up -d
$ docker compose -f docker-compose-full-18.yml ps
```

You can still use docker-compose command (Python version).

Beware that database files and configuration are persisted inside a docker volume !

To restart anew, you must delete the volume and your database :

```bash
$ docker compose -f docker-compose-full-18.yml stop
$ docker compose -f docker-compose-full-18.yml down
$ docker volume prune
```


## Connection to your database

Direct connection using your local psql client. (Use only if it is installed on your operating system)

You may need to adapt the connection string if you modified it.

```sh
$ psql postgresql://pglab@localhost:5432/pglab_database
```

Output :

```
Mot de passe pour l'utilisateur pglab :
psql (15.1, serveur 13.11)
Connexion SSL (protocole : TLSv1.3, chiffrement : TLS_AES_256_GCM_SHA384, compression : désactivé)
Saisissez « help » pour l'aide.

pglab_database=#
```

You may also run it from inside the PostgreSQL container like this :


```sh
$ docker compose -f docker-compose-full-18.yml exec server psql postgresql://pglab@localhost:5432/pglab_database

psql (18.6)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off, ALPN: postgresql)
Type "help" for help.

pglab_database=>
```


## Web UI with pgAdmin4

If you want to use a web interface for interacting with the PostgreSQL server, pgAdmin4 is listening on localhost port 5050.

![pgAdmin Welcome Screen](/media/pgadmin_welcome.png "pgAdmin")**Welcome Screen**

Use the email address defined in **PGADMIN_DEFAULT_EMAIL** and the password \
from **secret/pgadmin_password.txt** file.

```
Default URL     : https://localhost:5050/
Default address : pglab@umons.ac.be
Default password: pgchangeme
```

Once logged in, you should see the configured connections in the left sidebar :

![pgAdmin You are logged in](/media/pgadmin_logged_in.png "pgAdmin: Server List")**Server List**


The two PostgreSQL databases are already configured at the creation of the pgAdmin container using variables and scripts.

You will find :

* **pglab** : for a normal user (pglab),
* **postgres** : for the database administrator (postgres).

As previously mentioned, the passwords are in the secrets directory.

![pgAdmin You are connected](/media/pgadmin_connected.png "Connected")**You should be connected to the SQL database**

The Query Editor will be available by right clicking on the name of the database, for example : pglab_database.

