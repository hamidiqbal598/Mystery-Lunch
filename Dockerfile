FROM ruby:2.7.1
RUN apt-get update -qq \
&& apt-get install -y nodejs postgresql-client

ADD . /mystery-lunch
WORKDIR /mystery-lunch

RUN bundle install

EXPOSE 3000

CMD ["bash"]