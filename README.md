# PostgreSQL container with SSL enabled

This image is build upon the official PostgreSQL Alpine image for enabling SSL/TLS connections.

## Preconfiguration

### Variables

You can modify the .env file to change parameters like :

* **POSTGRES_USER** The desired username.
* **POSTGRES_DB** The name of the associated database.
* **PGADMIN_DEFAULT_EMAIL** The email address used as account in pgAdmin.
* **PGADMIN_REPLACE_SERVERS_ON_STARTUP** Whether or not you want to force the creation of the connection setup in pgAdmin.

If you change PostgreSQL variables, **you must** modify the secrets files :

* **secrets/postgres_password.txt** password used for **\$POSTGRES_USER** on **\$POSTGRES_DB**
* **secrets/pgadmin_password.txt** password used for the account **\$PGADMIN_DEFAULT_EMAIL** in pgAdmin.
* **secrets/pgpass.txt** connection string.
* **pgadmin_servers.json** the json file used to add the connection settings in pgAdmin.


### Generating the certificates with certstrap

Some default self-signed TLS certificates have been created and bundle in this repository.

If you want to generate your own :

First, you need to create self-signed CA and certificates using [certstrap](https://github.com/square/certstrap) from the certs folder.

To build this utility, you need the Go compiler in version 1.18+.

```bash
$ git clone https://github.com/square/certstrap
$ cd certstrap
$ go build
$ cp certs /usr/local/bin/
```

Copy the compiled binary **certstrap** in a folder present in your $PATH.

Now, you can run the script create-certificates.sh in the certs folder :

```bash
$ cd certs/ 
$ ./create-certificates.sh
```

The generated certs are created in the certs/out/ directory.

These files are incorporated in the custom built PostgreSQL image using Dockerfile : Dockerfile-18.

If you change the certificates after having created the image, you must rebuild it :

```bash
$ docker rmi postgres:18-alpine-ssl 
$ docker compose -f docker-compose-full-18.yml up -d
```


## Run and build

These lines uses the new docker compose plugin (Go version).

```bash
$ docker compose -f docker-compose-full-18.yml build
$ docker compose -f docker-compose-full-18.yml up -d
$ docker compose -f docker-compose-full-18.yml ps
```

You can still use docker-compose command (Python version).


## Connection to your database

Direct connection using your local psql client. (Use only if it is installed on your operating system)

You may need to adapt the connection string if you modified it.

```sh
$ psql postgresql://adriano@localhost:5432/my_own_database
```

Output :

```
Mot de passe pour l'utilisateur adriano :
psql (15.1, serveur 13.11)
Connexion SSL (protocole : TLSv1.3, chiffrement : TLS_AES_256_GCM_SHA384, compression : désactivé)
Saisissez « help » pour l'aide.

my_own_database=#
```

## Web UI

If you want to use a web interface for interacting with the PostgreSQL server, you can use the docker-compose-full-18.yml file :

```bash
$ docker compose -f docker-compose-full-18.yml up -d
$ docker compose -f docker-compose-full-18.yml ps
```


## pgAdmin

pgAdmin is accessible at http://localhost:5050, enter the credentials as described in the docker-compose-with-web-ui.yml file :

![pgAdmin Welcome Screen](/media/pgadmin_welcome.png "pgAdmin")**Welcome Screen**

Afterwards, we need to register a server configuration. Click on the "Add New Server" in the quick links section :

![pgAdmin We are logged in](/media/pgadmin_logged_in.png "pgAdmin")**Adding a new server**

A pop up will appear, set a name in the first tab named ***General*** :

![pgAdmin Register Server - General](/media/pgadmin_register_server_1.png "Register New Server")**General**

In the ***Connection*** tab, set the parameters as follow unless you modified the configuration :

![pgAdmin Register Server - Connection](/media/pgadmin_register_server_2.png "Connection Credentials")**Connection**

In the ***Parameters*** tab, you can set **SSL mode** to *require* :

![pgAdmin Register Server - Parameters](/media/pgadmin_register_server_3.png "Connection Parameters")**Parameters**

It is in *prefer* mode by default.

Now that the essential settings are in place, click on the Save button to add the server and initialize the connection :

![pgAdmin You are connected](/media/pgadmin_connected.png "Connected")**You should be connected to the SQL server**


## Adminer

When the adminer container is running, you need to go to http://localhost:8080 and fill in the credentials according to your modifications of the environment files.

![Adminer Connection parameters](/media/adminer_connection.png "Connection")**Default parameters**

