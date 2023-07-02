# Kbin CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/kbin"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Kbin server with CI/CD on Elestio

<img src="kbin.png" style='width: 100%;'/>
<br/>
<br/>

# Once deployed ...

You can open Kbin UI here:

    URL: https://[CI_CD_DOMAIN]
    email: [ADMIN_EMAIL]
    password: [ADMIN_PASSWORD]

# Custom domain instructions (IMPORTANT)

By default we setup a CNAME on elestio.app domain, but probably you will want to have your own domain.

**_Step1:_** add your domain in Elestio dashboard as explained here:

    https://docs.elest.io/books/security/page/custom-domain-and-automated-encryption-ssltls

**_Step2:_** update the env vars to indicate your custom domain
Open Elestio dashboard > Service overview > click on UPDATE CONFIG button > Env tab
there update `DOMAIN`, `BASE_URL`, `SERVER_NAME`, `KBIN_DOMAIN`, `KBIN_STORAGE_URL`, `MERCURE_PUBLIC_URL` & `CADDY_MERCURE_URL` with your real domain

**_Step3:_** you must reset the KBIN instance DB, you can do that with those commands, connect over SSH and run this:

    cd /opt/app;
    docker-compose down;
    rm -rf ./storage;
    ./scripts/preInstall.sh
    docker-compose up -d
    ./scripts/postInstall.sh

You will start over with a fresh instance of KBIN directly configured with the correct custom domain name and federation will work as expected
