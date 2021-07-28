FROM k8s.gcr.io/build-image/debian-base:buster-v1.4.0

RUN curl -L https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz -o /tmp/etcd-v3.5.0-linux-amd64.tar.gz \
    && tar -xzvf /tmp/etcd-v3.5.0-linux-amd64.tar.gz -C /software --strip-components=1 \
    && mv /software/etcd-v3.5.0-linux-amd64/etcd /usr/local/bin/etcd \
    && mv /software/etcd-v3.5.0-linux-amd64/etcdctl /usr/local/bin/etcdctl \
    && mv /software/etcd-v3.5.0-linux-amd64/etcdutl /usr/local/bin/etcdutl \
    && rm -f /tmp/etcd-v3.5.0-linux-amd64.tar.gz

RUN mkdir -p /var/etcd/
RUN mkdir -p /var/lib/etcd/

# Alpine Linux doesn't use pam, which means that there is no /etc/nsswitch.conf,
# but Golang relies on /etc/nsswitch.conf to check the order of DNS resolving
# (see https://github.com/golang/go/commit/9dee7771f561cf6aee081c0af6658cc81fac3918)
# To fix this we just create /etc/nsswitch.conf and add the following line:
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 2379 2380

# Define default command.
CMD ["/usr/local/bin/etcd"]
