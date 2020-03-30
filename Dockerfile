FROM php:7.2.24-fpm-stretch


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update -y --allow-unauthenticated
RUN apt-get install -y --allow-unauthenticated libaio-dev supervisor nano openssl unixodbc zip unzip git wget libfreetype6-dev libjpeg62-turbo-dev libpng-dev libldb-dev libldap2-dev


RUN docker-php-ext-install zip
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install bcmath
RUN pecl install sqlsrv pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv pcntl

RUN cd /tmp && git clone https://github.com/git-ftp/git-ftp.git && cd git-ftp \
    && tag="$(git tag | grep '^[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)" \
    && git checkout "$tag" \
    && mv git-ftp /usr/local/bin && chmod +x /usr/local/bin

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y --allow-unauthenticated
RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql17
RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
RUN apt-get install -y --allow-unauthenticated unixodbc-dev
RUN apt-get install -y --allow-unauthenticated libgssapi-krb5-2

RUN docker-php-ext-install sockets

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y --allow-unauthenticated nodejs
RUN apt-get install -y --allow-unauthenticated npm
RUN npm i -g yarn

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* /var/tmp/*