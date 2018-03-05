FROM ubuntu

# Install go deps + xvfb (x session)
RUN apt-get update -y && apt-get install --no-install-recommends -y -q \
	curl \
	build-essential \
	ca-certificates \
	git \
	mercurial \
	bzr \
	dbus \
	xvfb

# Download and install go
RUN mkdir /goroot && curl https://dl.google.com/go/go1.10.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
RUN mkdir /gopath

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Install libwebkit, gtk, and gotk3
RUN apt-get update -y && apt-get install --no-install-recommends -y -q libwebkit2gtk-3.0-dev libwebkit2gtk-4.0-dev libgtk-3-dev libcairo2-dev libglib2.0-dev vim gdb
#RUN go get github.com/sourcegraph/webloop/...
COPY ./github.com /gopath/src/github.com/

RUN go install -tags gtk_3_18 github.com/gotk3/gotk3/gtk

#RUN go install -v -tags gtk_3_18 -gcflags "-N -l"

COPY ./init.sh /opt/init.sh
RUN chmod +x /opt/init.sh

ONBUILD WORKDIR /gopath/src/app
ONBUILD ADD . /gopath/src/app/
ONBUILD RUN go get -v -tags gtk_3_18 app

ONBUILD CMD ["/opt/init.sh"]


