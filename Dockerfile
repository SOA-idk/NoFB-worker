FROM hhorace/ruby-http:3.0.3

WORKDIR /worker

COPY / .

# RUN apt add curl unzip xvfb libxi6 libgconf-2-4

# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install ./google-chrome-stable_current_amd64.deb

# RUN apt add chromium chromium-chromedriver python3 python3-dev py3-pip

# RUN pip3 install -U selenium

# RUN  apt upgrade \
#   && apt install chromium chromium-chromedriver
#   # && apt add --no-cache bash

# for chromedriver
RUN unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chown root:root /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \ 
    && chromedriver --version \ 
    && which chromedriver

ENV WD_INSTALL_DIR=/worker/.webdrivers

RUN bundle install

# ENV CHROME_BIN=/usr/bin/chromium-browser \
#     CHROME_PATH=/usr/lib/chromium/ \ 
#     WD_CHROME_PATH=/usr/lib/chromium/

# RUN chmod +x /usr/lib/chromium/

CMD rake console
# CMD rake worker

# LOCAL:
# Build local image with:
#   rake docker:build
# or:
#   docker build --rm --force-rm -t soumyaray/codepraise-clone_notifier:0.1.0 .
#
# Run and test local container with:
#   rake docker:run
# or:
#   docker run -e --rm -it -v $(pwd)/config:/worker/config -w /worker soumyaray/codepraise-clone_notifier:0.1.0 ruby worker/clone_notifier.rb

# REMOTE:
# Make sure Heroku app exists:
#   heroku create codepraise-scheduled_worker
#
# Build and push to Heroku container registry with:
#   heroku container:push web
# (if first time, add scheduler addon to Heroku and have it run 'worker')
#
# Run and test remote container:
#   heroku run worker
# or:
#   heroku run ruby worker/clone_notifier.rb