FROM mwcampbell/muslbase-build-base
MAINTAINER Matt Campbell <mattcampbell@pobox.com>

ENV ROOT /buildroot
ENV RUNTIME_ROOT $ROOT/runtime
ENV STATIC_RUNTIME_ROOT $ROOT/static-runtime

RUN mkdir -p $RUNTIME_ROOT $STATIC_RUNTIME_ROOT

ADD . $ROOT/src

RUN $ROOT/src/build-prerequisites.sh
RUN $ROOT/src/build-temporary.sh

ADD dev.tar $ROOT/dev/
ADD dev.tar $RUNTIME_ROOT/dev
ADD dev.tar $STATIC_RUNTIME_ROOT/dev

RUN chroot $ROOT /src/build-final.sh && \
    rm -rf $ROOT/src && \
    rm -rf $ROOT/tools && \
    (find $ROOT type f -name "*.a" -print | xargs strip --strip-debug) && \
    (find $ROOT type f -name "*.o" -print | xargs strip --strip-debug) && \
    ((find $ROOT -type f -print | grep -v '\.a$' | grep -v '\.o$' | xargs strip --strip-all) || true) && \
    tar cvpf /runtime-rootfs.tar -C $RUNTIME_ROOT . && \
    rm -rf $RUNTIME_ROOT && \
    tar cvpf /static-runtime-rootfs.tar -C $STATIC_RUNTIME_ROOT . && \
    rm -rf $STATIC_RUNTIME_ROOT && \
    tar cvpf /rootfs.tar -C $ROOT .
