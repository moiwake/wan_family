FROM ruby:2.7.6-bullseye

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb \
  && DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.22-1_all.deb \
  && apt-get update \
  && apt-get remove -y \
    libmariadb3 \
    mariadb-common \
  && apt-get install -y --no-install-recommends \
    libmysqlclient-dev \
    mysql-client \
    nodejs \
    yarn \
    zip \
  && apt-get clean \

RUN mkdir /wan_family
WORKDIR /wan_family
COPY Gemfile /wan_family/Gemfile
COPY Gemfile.lock /wan_family/Gemfile.lock

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
COPY . /wan_family
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
